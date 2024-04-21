#!/usr/bin/awk -f


{ 
    for ( i = 1; i <= NF; i++){
    matrix[NR, i] = $i
    }
    max_rows = NR
    max_cols = ( NF > max_cols) ? NF : max_cols
}

END {
    for (i = 1; i <= max_cols; i++){
        row= ""
        for( j = 1; j <= max_rows; j++){
              if ( j > 1){
                  row = row " "
              }
              row = row matrix[j, i]
        }
        print row 
    }
}
