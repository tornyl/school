#!/bin/bash



if [[ $# -ne 1 ]]; then
    exit 1
fi

dir="$1"


for file in "$dir"/*; do

    if [[ -f "$file" ]]; then

        content=$(<"$file")

        #echo "$file:   content: $content"



        IFS='/'
        read -ra arr  <<< "$content"

        new_dir="${arr[2]}/${arr[1]}/${arr[0]}"
        
        mkdir -p "$(dirname "$file")/$new_dir"

        #mv "$file" "./$new_dir/$(basename "$file")"
        mv "$file" "$(dirname "$file")/$new_dir/$(basename "$file")"

    fi

done


