#!/bin/bash

javac *.java

threads=$1
swaps=$2
maxval=$3
entry1=$4
entry2=$5
entry3=$6
entry4=$7
entry5=$8

echo "=== UNSYNCHRONIZED threads=${threads} swaps=${swaps} maxval=${maxval} ${entry1} ${entry2} ${entry3} ${entry4} ${entry5} ==="
timeout 3s java UnsafeMemory Unsynchronized $1 $2 $3 $4 $5 $6 $7 $8
echo ""

echo "=== GETNSET threads=${threads} swaps=${swaps} maxval=${maxval} ${entry1} ${entry2} ${entry3} ${entry4} ${entry5} ==="
java UnsafeMemory GetNSet $1 $2 $3 $4 $5 $6 $7 $8
echo ""

echo "=== SYNCHRONIZED threads=${threads} swaps=${swaps} maxval=${maxval} ${entry1} ${entry2} ${entry3} ${entry4} ${entry5} ==="
java UnsafeMemory Synchronized $1 $2 $3 $4 $5 $6 $7 $8
echo ""

echo "=== BETTERSAFE threads=${threads} swaps=${swaps} maxval=${maxval} ${entry1} ${entry2} ${entry3} ${entry4} ${entry5} ==="
java UnsafeMemory BetterSafe $1 $2 $3 $4 $5 $6 $7 $8
echo ""

echo "=== BETTERSORRY threads=${threads} swaps=${swaps} maxval=${maxval} ${entry1} ${entry2} ${entry3} ${entry4} ${entry5} ==="
timeout 3s java UnsafeMemory BetterSorry $1 $2 $3 $4 $5 $6 $7 $8
echo ""