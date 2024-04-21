#!/bin/bash

start=1
end=1
increment=1

case $# in
	1)
		end=$1
		shift
		;;
	2)
		start=$1
		end=$2
		shift
		;;
	3)
		start=$1
		end=$3
		increment=$2
		shift
		;;

esac


if [[ $start > $end  ]]; then
	increment=$(( $increment * -1 ))
fi


if (( (end - start) < 0 )); then
	abs=-1
else
	abs=1
fi

while (( ((end - start) * abs) >= ( increment * abs ) )); do
	echo $start
	start=$(( $start + $increment ))
done

echo $start
#for (( i=1 ; i<=((end - start) * abs) / ( increment * abs ) ; i++ )); do	
#	echo $(( start +  increment * i ))
#done

