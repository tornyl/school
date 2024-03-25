#!/bin/bash


if [[ $# -ne 1 ]]; then
    exit 1
fi

echo "$(

     

    awk '
        BEGIN { len =  0 }
        {
            names[$1] +=1 
            len +=1

        }
        END {


        for (name in names){
            print name " " names[name]
        }

        }

    '  $1 | sort -k 1  
)"
