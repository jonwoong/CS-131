########## PROJECT ##########

###### IMPORTS ######
import sys
import conf
import logging
import time
import json

from twisted.protocols import basic
from twisted.internet import protocol, reactor
from twisted.application import service, internet
from twisted.web.client import getPage

##### SERVER BEHAVIOR #####
class server(basic.LineReceiver):
	def __init__(self,factory):
		self.factory = factory

	def connectionMade(self):
		logging.info("{} received a client".format(self.factory.name))

	def connectionLost(self,reason):
		logging.info("{} lost a client".format(self.factory.name))

	def lineReceived(self,line):
		# get each argument
		arguments = line.split()

		# check for no arguments
		if len(arguments)<1:
			logging.info("{} received 0 argument command".format(self.factory.name))
			return

		# IAMAT, WHATSAT, AT, error
		command = arguments[0]

		##### IAMAT #####
		if command=="IAMAT":
			# check for invalid arg length
			if len(arguments) != 4: 
				logging.info("{} received invalid command: {}".format(self.factory.name,line))
				self.transport.write("? " + line + "\n")
				return

			# get arguments
			clientID = arguments[1]
			clientCoord = arguments[2]
			clientTime = arguments[3]

			# check for valid time input 
			if all(c.isdigit() or c== '.' # contains digit or decimal
				and clientTime.count('.')==1 # contains only 1 decimal
				for c in clientTime)==False:
				logging.info("{} received invalid time: {}".format(self.factory.name,clientTime))
				self.transport.write("? " + line + "\n")
				return

			# check for valid coordinates
			if all(c.isdigit() or c=='+' or c=="-" or c=='.'  # contains digit or + or - .
				and clientCoord.count('.')==2 # contains only 2 decimals
				for c in clientCoord)==False:
				logging.info("{} received invalid coordinates: {}".format(self.factory.name,clientCoord))
				self.transport.write("? " + line + "\n")
				return

			# received valid command
			logging.info("{} received valid command: {}".format(self.factory.name,line))

			# save clientID
			self.factory.clients.append(clientID)

			# calculate time difference
			timeDiff = time.time() - float(clientTime)
			# contents of original IAMAT message
			responseBody = clientID + ' ' + clientCoord + ' ' + clientTime

			# respond with AT message
			if timeDiff>0:
				response = "AT {} +{} {}".format(self.factory.name, timeDiff, responseBody)
			else:
				response = "AT {} {} {}".format(self.factory.name, timeDiff, responseBody)
				
			self.transport.write(response + "\n")
			logging.info("{} responded to '{}' with '{}'".format(self.factory.name,line,response))

			# save AT message
			self.factory.clientData.append((clientID,(response,clientTime))) # clientID: [response,clientTime]

			# notify neighbors
			logging.info("{} sent client data to neighbors".format(self.factory.name))
			self.updateNeighbor(response)

		##### WHATSAT #####
		elif command=="WHATSAT":
			# check for invalid arg length
			if len(arguments) != 4:
				logging.info("{} received invalid command: {}".format(self.factory.name,line))
				self.transport.write("? " + line + "\n")
				return

			# get arguments
			clientID = arguments[1]
			radius = arguments[2]
			upperBound = arguments[3]

			# check for valid radius
			if radius.isdigit()==False:
				logging.info("{} recieved invalid radius: {}".format(self.factory.name,radius))
				self.transport.write("? " + line + "\n")
				return
			if int(radius)>50:
				logging.info("{} received out of bound radius: {}".format(self.factory.name,radius))
				self.transport.write("? " + line + "\n")
				return

			# check for valid upper bound
			if upperBound.isdigit()==False:
				logging.info("{} recieved invalid upper bound: {}".format(self.factory.name,upperBound))
				self.transport.write("? " + line + "\n")
				return
			if int(upperBound)>20:
				logging.info("{} received out of bound upper bound: {}".format(self.factory.name,upperBound))
				self.transport.write("? " + line + "\n")
				return

			# check if client is known
			if not (clientID in self.factory.clients):
				logging.info("{} could not identify client: {}".format(self.factory.name,clientID))
				self.transport.write("? " + line + "\n")
				return

			# received valid command
			logging.info("{} received valid command: {}".format(self.factory.name,line))

			# get corresponding AT message
			clientDict = dict(self.factory.clientData)
			atMsg = clientDict[clientID][0] # original AT message

			# build query
			atArgs = atMsg.split()
			clientCoord = atArgs[4].replace('+', ' +').replace('-', ' -').strip().replace(' ', ',')
			query = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={}&radius={}&sensor=false&key={}".format(clientCoord,str(radius),conf.API_KEY)
			logging.info("{} built query URL: {}".format(self.factory.name,query))

			# send query and handle results
			queryResult = getPage(query)
			queryResult.addCallback(callback = lambda x:(self.handleQuery(x,atMsg,upperBound,query)))

		##### AT #####
		elif command=="AT":
			# check for valid arg length
			if len(arguments) != 6:
				logging.info("{} received invalid command: {}".format(self.factory.name,line))
				self.transport.write("? " + line + "\n")
				return

			# get args
			sender = arguments[1]
			timeDiff = arguments[2]
			clientID = arguments[3]
			clientCoord = arguments[4]
			clientTime = arguments[5]

			# check if AT data is already known
			clientDict = dict(self.factory.clientData)
			if (clientID in self.factory.clients) and (clientTime <= clientDict[clientID][1]):
				logging.info("{} received old or duplicate AT info: {}".format(self.factory.name,line))
				return

			# save clientID
			self.factory.clients.append(clientID)

			# store message
			self.factory.clientData.append((clientID,(line,clientTime)))
			logging.info("{} received AT data: {}".format(self.factory.name,line))

			# update neighbors
			self.updateNeighbor(line,sender)
			logging.info("{} sent client data to neighbors".format(self.factory.name))

		##### MISC #####
		else:
			logging.info("{} received invalid command: {}".format(self.factory.name,line))
			self.transport.write("? " + line + "\n")

	##### HANDLE QUERY #####
	def handleQuery(self,response,atMsg,upperBound,query):
		# get response from Google
		jsonResponse = json.loads(response)
		# get results
		results = jsonResponse["results"]
		# castrate results
		jsonResponse["results"] = results[0:int(upperBound)]
		# build response to client
		responseMsg = "{}\n{}\n\n".format(atMsg,json.dumps(jsonResponse, indent=4))
		# output response to client
		self.transport.write(responseMsg)
		logging.info("{} responded to WHATSAT message with: {}".format(self.factory.name,responseMsg))

	### UPDATE NEIGHBOR (FLOODING) ###
	def updateNeighbor(self,message,exclude = ''):
		for neighbor in conf.NEIGHBORS[self.factory.name]:
			if neighbor != exclude:
				# connect to neighbor as a client
				reactor.connectTCP('localhost',conf.PORT_NUM[neighbor],clientFactory(message))
		return

##### SERVER SETTINGS #####
class serverFactory(protocol.ServerFactory):
	def __init__(self,name):
		self.name = name
		self.port = conf.PORT_NUM[self.name]
		self.clients = [] # stores clientIDs
		self.clientData = [] # stores clientID:[msg,time]
		self.log = self.name + ".log"
		logging.basicConfig(filename=self.log, level=logging.DEBUG, filemode='a')
		logging.info("{} started on port {}".format(self.name,self.port))

	def buildProtocol(self,addr):
		return server(self)

	def stopFactory(self):
		logging.info("{} shutdown".format(self.name))

##### CLIENT BEHAVIOR #####
class client(basic.LineReceiver):
	def __init__(self,factory):
		self.factory = factory

	# upon connection, immediately send message and disconnect
	def connectionMade(self):
		self.sendLine(self.factory.message)
		self.transport.loseConnection()

##### CLIENT SETTINGS #####
class clientFactory(protocol.ClientFactory):
	def __init__(self,message):
		self.message = message

	def buildProtocol(self,addr):
		return client(self)

##### MAIN #####
def main():
	# check for proper server usage
	if len(sys.argv) !=2:
		print "Usage: python server.py [SERVER_NAME]"
		exit()

	# get server parameters
	serverName = sys.argv[1]
	portNumber = conf.PORT_NUM[serverName]

	# build server settings
	factory = serverFactory(serverName)

	# run
	reactor.listenTCP(portNumber,factory)
	reactor.run()

if __name__ == '__main__':
    main()