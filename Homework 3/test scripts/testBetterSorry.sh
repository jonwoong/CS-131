#!/bin/bash

# delete old betterSorryResults if exists
file="betterSorryResults.txt"
[[ -f "$file" ]] && rm -f "$file"

javac *.java

states=(BetterSorry)
threads=(1 2 4 8 16 32)
swaps=(100 1000 10000 100000 1000000)
maxval=(127)
entry1=(25)
entry2=(25)
entry3=(25)
entry4=(25)
entry5=(25)

for st in "${states[@]}"
do
	for sw in "${swaps[@]}"
	do
		for t in "${threads[@]}"
		do
			for i in 1 2 3 4 5 # test each combination of (threads, swaps, states) 5 times
			do
				echo "=== ${st} threads=${t} swaps=${sw} maxval=${maxval} ${entry1} ${entry2} ${entry3} ${entry4} ${entry5} ==="
				timeout 3s java UnsafeMemory $st $t $sw $maxval $entry1 $entry2 $entry3 $entry4 $entry5
				echo ""	
			done	
		done
	done
done > betterSorryResults.txt

echo "===== BETTERSORRY TEST COMPLETE ======"