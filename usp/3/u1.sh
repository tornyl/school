#!/bin/bash

directory=*
flag_a=false

while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
		-a)
			flag_a=true
			shift
			;;
		*)
			directory=$key
			shift
			;;
	esac
done

if $flag_a
then
	shopt -s dotglob
fi


for file in "$directory"/*; do
	name=$(basename "$file")
	type=""
	if [ -f "$file" ]; then
	 type="-"
	elif [ -d "$file" ]; then
	 type="d"
	elif [ -L "$file" ]; then
	   type="l"
	fi

	read_p="-"	
	if [ -r "$file" ]; then
		read_p="r"
	fi
	

	write_p="-"
	if [ -w "$file" ]; then
		write_p="w"
	fi
	
	exec_p="-"
	if [ -x "$file" ]; then
		exec_p="x"
	fi
	
	echo "$name $type $read_p$write_p$exec_p" 
done

