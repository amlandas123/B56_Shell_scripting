#!/bin/bash

n=7
for (( i=1 ; i<=$n ; i++ )); 
do
    if [ (i % 2) -eq 0 ];then 
        echo -e "\e[32m $i \e[0m"
    fi    
done
