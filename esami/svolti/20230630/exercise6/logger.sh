#!/bin/bash

# Nome del file di log
LOG_FILE="./logger.log"

# Stampa "hello docker" NUMBER volte nel file di log
for ((i = 1; i <= NUMBER; i++)); do
	echo "hello docker" >> "$LOG_FILE"
done
cat $LOG_FILE
