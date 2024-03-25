#!/bin/bash


if [[ $# -ne 1 ]]; then
    exit 1
fi

echo "$(

     

    awk '
        {
            n = length($2)
            first_letter = substr($2, 1 ,1)
            reminder = substr($2, 2, n - 1)
            lower_reminder = tolower(reminder)
            print $1 " " first_letter lower_reminder
                  
        }

    '  $1  > tmp_ && mv tmp_ $1
)"
