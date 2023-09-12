#!/bin/bash

if [ "$#" -eq 2 ]; then
	CMD=$1
	ARG=$2
	if  command -v $CMD > /dev/null ; then
		echo "$ $CMD $ARG"
		command $CMD $ARG
	else
		echo "ERRORE: comando inesistente"
        	exit 101
	fi

else
	echo "ERRORE: due argomenti richiesti"
	exit 100
fi
