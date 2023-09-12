#!/bin/bash

errore() {
	CODE=$1
	case $CODE in
		10)
			echo "only two numbers"
		;;
		11)
			echo "nothing to do"
		;;
		12)
			echo "only numbers please"
		;;
	esac

	exit $CODE
}

if [ "$#" -eq 0 ]; then
	errore 11
fi

if [ "$#" -ne 2 ]; then
	errore 10
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
	if [[ "$2" =~ ^[0-9]+$ ]]; then
		MAX=0
		if [ "$1" -gt "$2" ]; then
			MAX=$1
		else
			MAX=$2
		fi
		echo "The larger of the two numbers is: $MAX"
		exit 0
	fi
fi

errore 12

