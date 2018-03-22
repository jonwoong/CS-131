#!/bin/bash

# delete old testResults if exists
file="testResults.txt"
[[ -f "$file" ]] && rm -f "$file"

# make all scripts executable
chmod 777 *.sh

# compile all java files
javac *.java

# states to test
tests=(testSynchronized testUnsynchronized testGetNSet testBetterSafe testBetterSorry testNull)

for t in "${tests[@]}" # run each test script
do
	sh ./$t.sh
done 

# extract all data 
sh ./extractData.sh