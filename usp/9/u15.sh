#!/bin/bash


if [[ $# -ne 1 ]]; then
    exit 1
fi

seconds_back="$(( $1 * 24 * 3600 ))"
seconds_since_epoch="$(date \+\%s)"
since=$(( seconds_since_epoch - seconds_back ))

result="$( last pts/{0..9} |
            awk  -v since="$since" '
    {
        record_date=$4" "$5" "$6" "$7
        cmd =  "date -d " "\""record_date "\"" " +%s --utc"
        cmd | getline output
        if ( output - since > 0){
            if( match($NF, /in/)){
                users[$1]+=output - since
            }else{
                o2 = $NF
                gsub(/\(/,"",$NF)
                gsub(/\)/,"",$NF)
                gsub(/\+/," ",$NF)
                gsub(/\:/," ",$NF)
                len=split($NF, duration, " ")
                dur=0
                if(len == 3){
                    dur+=duration[1] * 24 * 3600 + duration[2] * 3600 + duration[3] * 60 
                }else{ 
                    dur+=duration[1] * 3600 + duration[2] * 60 
                }

                users[$1]+=dur
            }
        }    
    }

    END {
    for(user in users){
        if(user != ""){
            m  = (users[user] % 3600) / 60
            h  = (users[user] % (3600*24)) / 3600
            d  = users[user] / (3600*24)

            print user" (" int(d) "+" int(h) ":" int(m) ")"
        }
    }
}
      
    ')"

echo "$result"




