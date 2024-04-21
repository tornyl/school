#!/bin/bash


echo "$( ps aux | awk '
    FNR == 1 {
        user_field = 0
        memory_index = 0
        for( i = 1; i< NF; i++){
            if ( $i == "USER"){
                user_index = i
            }

            if ( $i == "RSS"){
                memory_index = i
            }
        }
    }

    FNR != 1 {
    users[$(user_index)] += $(memory_index)
    }
    
    END {
        for (user in users){
            {print user " " users[user]}
        }

    }

 ')"
