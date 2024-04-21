#!/bin/bash


dirname(){
	local path="$1"
	if [[ "$#" -eq 0 ]]; then
		echo 
		return 0;
	fi
	if [[ "$path" == "/" ]]; then
		echo "$path"
		return 0;
	fi

	if [[  "${path: -1}" == "/" ]]; then
		path="${path%/}"
	fi

	if [[ "$path" != *"/"* ]]; then
		echo "."
		return 0
	fi


	path="${path%/*}"

	echo "$path"
}


basename(){
	local path="$1"
	if [[ "$#" -eq 0 ]]; then
		echo 
		return 0;
	fi

	if [[ "$path" == "/" ]]; then
		echo "$path"
		return 0;
	fi

	if [[  "${path: -1}" == "/" ]]; then
		path="${path%/}"
	fi

	path="${path##*/}"

	echo "$path"

}


: '
# testy

path1="/home/torny/Documents/somefile.txt"
path2="/home/torny/Documents/"
path3="somefile.txt"
path4="/"
path5="."
path6=" "
dir=$( dirname "$path6") 
basename=$( basename "$path3") 
echo "$dir"
echo "$basename"
'

