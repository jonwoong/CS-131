#!/bin/bash

# kill active servers
kill $(lsof -t -i:12000) &
kill $(lsof -t -i:12001) &
kill $(lsof -t -i:12002) &
kill $(lsof -t -i:12003) &
kill $(lsof -t -i:12004) &

# run servers
python server.py Alford &
python server.py Ball &
python server.py Hamilton &
python server.py Holiday &
python server.py Welsh