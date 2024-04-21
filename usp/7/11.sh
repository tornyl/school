#!/bin/bash


if [[ $# -ne 1 ]]; then
    exit 1
fi

html_file=$1


echo "$(sed -n "/<a .*href=.*>/{
                p
            };" "$html_file"  |  grep -o "href=\"[^\"]*\"" | grep -Po "(?<=\").*(?=\")" )" 





