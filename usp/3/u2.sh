#!/bin/bash

min=0
max=100


case $# in
	1)
		max=$1
		shift
		;;
	2)
		min=$1
		max=$2
		shift
		;;

esac

echo $min $max


guessed=false

while [ "$guessed" != true ];do
	diff=$(($max - $min))
	(( diff /=2 ))
	center=$(( $min + $diff))
	echo "Je hodnotva vetsi nez $center ?"
	read answer
	if [ "$answer" = "n" ]; then
		max=$center
	elif [ "$answer" = "a" ]; then
		min=$(( $center + 1))
	else
	 	exit 1
	fi

	if [ $min = $max ]; then
		echo "Hodnota je $min"
		guessed=true
	fi
done
