#!/bin/bash

is_prime() {
    if [ "$1" -le 1 ]; then
        return 1 # False
    fi

    if [ "$1" -le 3 ]; then
        return 0 # True
    fi

    if [ "$1" -eq 2 ] || [ "$1" -eq 3 ]; then
        return 0 # True
    fi

    if [ $(( $1 % 2 )) -eq 0 ] || [ $(( $1 % 3 )) -eq 0 ]; then
        return 1 # False
    fi

    i=5
    while [ $(( i * i )) -le "$1" ]; do
        if [ $(( $1 % i )) -eq 0 ] || [ $(( $1 % (i + 2) )) -eq 0 ]; then
            return 1 # False
        fi
        i=$(( i + 6 ))
    done

    return 0 # True
}

if [ $# -lt 2 ]; then
	echo "ERRORE: Inserire almeno due parametri in ingresso"
	exit 100
fi

for item in $@; do
	if [[ "$item" =~ ^[0-9]+$ ]]; then #Verifico se è numero
		if is_prime $item; then
			echo "$item: è un numero primo"
		else
			echo "$item: non è un numero primo"	
		fi
	else
		echo "$item: non è un numero."
	fi
done

