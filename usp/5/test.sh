#!/bin/bash


s="01/02/0003"

IFS='/'

read -ra arr  <<< "$s"

echo "${arr[0]} ${arr[1]} ${arr[2]}" 
