#!/bin/bash

error(){
	CODE=$1
	case $CODE in
		10)
			echo "no parameters passed - Usage: checkusername.sh <username list>"
			;;
		20)
			echo "too many parameters passed (max 5) - Usage: checkusername.sh <username list>"
			;;
	esac

	exit $CODE
}

# Faccio il controllo sugli argomenti
if [[ "$#" == 0 ]]; then 
	error 10
fi
if [[ "$#" > 5 ]]; then
       	error 20
fi

# Scorro utente per utente
for USER in $@; do
	# echo $USER
	
	id $USER &> /dev/null 
	
	if [ "$?" -eq 0 ]; then
		echo "user $USER found:"
		id $USER
		chage -l $USER
		grep $USER /etc/passwd
	else
		echo "user $USER not found"
	fi
done
