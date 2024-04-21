#!/bin/bash


if [[ $# -ne 2 ]]; then
    exit 1
fi

user_data_file=$1
template_file=$2

user_data=$(<"$user_data_file")
template=$(<"$template_file")
template_name=$(basename "$template_file")
template_name="${template_name%.*}"
i=0
while read -r line ||  [[ $line ]]; do
    read -ra arr <<< "$line"  
    
    #sed -e "s/JMENO/${arr[0]}/;s/PRIJMENI/${arr[1]}/;1i ${arr[2]}\n" "$template_file" > template_"$(( i+1 ))".txt
    sed -e "s/JMENO/${arr[0]}/;s/PRIJMENI/${arr[1]}/;1i ${arr[2]}\n" "$template_file" > "$template_name""$(( i+1 ))".txt


    (( i++ ))
done < $user_data_file





