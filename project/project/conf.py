# A configuration file for the Twisted Places proxy herd

# Google Places API key
API_KEY="its_a_secret!"

# TCP port numbers for each server instance (server ID: case sensitive)
# Please use the port numbers allocated by the TA.
PORT_NUM = {
    'Alford': 12000,
    'Ball': 12001,
    'Hamilton': 12002,
    'Holiday': 12003,
    'Welsh': 12004
}

NEIGHBORS = {
	'Alford': ['Hamilton', 'Welsh'],
	'Ball': ['Holiday', 'Welsh'],
	'Hamilton': ['Holiday'],
	'Welsh': ['Alford', 'Ball'],
	'Holiday': ['Ball', 'Hamilton'],
}

PROJ_TAG="Fall 2016"