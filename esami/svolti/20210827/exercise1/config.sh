#!/bin/bash

for ((i = 1; i <= 10; i++)); do
	DIR="exercise1_dir${i}"
	mkdir $DIR
	for ((j = 10; j <= 30; j++)); do
		FILE="file${j}.txt"
		touch $DIR/$FILE
	done
done

tree
