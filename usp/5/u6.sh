#!/bin/bash



if [[ $# -ne 1 ]]; then
    exit 1
fi

dir=$1

for i in {1..1000}; do
    random_number=$(printf "%04d" $(( RANDOM % 10000)))
    filename="XYZ$random_number"
    #filename=$(printf "%04d" $i)

    file_path="$dir/$filename.jpg"
    touch "$file_path"

    month=$(printf "%02d" $(( 1 + (RANDOM % 12) )))
    day=$(printf "%02d" $(( 1 + (RANDOM % 31) )))
    year=$(printf "%04d" $(( 1 + (RANDOM % 9999) )))

    date="$month/$day/$year"

    echo "$date" > "$file_path"



done
