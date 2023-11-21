#!/bin/bash

n=10
for (( i=1 ; i<=$n ; i++ )); 
do
    if $[(i % 2) -eq 0 ];then
        echo -e"\e[32m The number is even \e[0m"
    else
        echo -e"\e[36m The number is odd \e[0m"
    fi
done
