#!/bin/bash

error() {
	CODE=$1
	case $CODE in
		10) echo "Usage: createuser.sh <filename> <add/remove>"
		;;
		11) echo "File does not exist"
		;;
		12) echo "Operations avaiable: add/remove"
		;;
	esac

	exit $CODE
}

add_user(){
	username=$1
	uid=$2
	id $username 2> /dev/null >/dev/null
	
	if [ "$?" -ne 0 ]; then
		if [ "$uid" -lt 4000 ]; then
			echo "User $username not created (invalid UID)"
		else
			useradd -u $uid $username
			echo "User $username created (UID: $uid)"
		fi 
	else
		echo "User $username already exists"
	fi
}

remove_user(){
	username=$1
	id $username 2> /dev/null >/dev/null

       	if [ "$?" -eq 0 ]; then
		userdel -r $username
		echo "User $username removed"
       	else
               	echo "User $username does not exist"
       	fi
}

if [ "$#" -ne 2 ]; then
	error 10
fi

FILE=$1
OPERATION=$2

if ! test -e $FILE; then
	error 11
fi

while IFS=: read -r nome cognome uid; do
	# echo "$nome $cognome $uid"
	username="${nome:0:1}${cognome}"
	
	case $OPERATION in
		add) add_user $username $uid
		;;
		remove) remove_user $username
		;;
		*) error 12
		;;
	esac

done < $FILE
exit 0
