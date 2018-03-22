#!/bin/bash

# delete old rawResults if exists
file="rawResults.txt"
[[ -f "$file" ]] && rm -f "$file"

# files to extract data from
testResults=(synchronizedResults.txt unsynchronizedResults.txt getNSetResults.txt betterSafeResults.txt betterSorryResults.txt nullResults.txt)

# extract the data
for tR in "${testResults[@]}"
do
	echo ===== $tR RESULTS =====
	while IFS='' read -r line;
	do
		if [[ $line == =* ]] # lines containing # of threads and # of swaps
			then
				# extract threads & swaps
				threads=$(echo "$line" | cut -d ' ' -f 3 | sed 's/[a-z]//g' | sed 's/=//g' )
				swaps=$(echo "$line" | cut -d ' ' -f 4 | sed 's/[a-z]//g' | sed 's/=//g' )
			fi
		if [[ $line == T* ]] # lines containing ns/transition
			then
				transitionTime=$(echo "$line" | cut -d ' ' -f 3)
				echo -e $threads'\t'$swaps'\t'$transitionTime
			fi
	done < "$tR"
done > rawResults.txt


