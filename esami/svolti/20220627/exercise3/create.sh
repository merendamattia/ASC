#!/bin/bash

for ((i = 1; i <= 50; i++)); do
	DIR="exercise3_directory$i"
	mkdir -p "$DIR"
	for ((j = 1; j <= 5; j++)) do
		current_date=$(date +'%Y-%m-%d-%H:%M:%S')
    		FILE="$DIR/file${j}_${current_date}.txt"
    		touch "$FILE"
	done
done
