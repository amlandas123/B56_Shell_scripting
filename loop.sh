#!/bin/bash

n=7
for (( i=1 ; i<=$n ; i++ )); 
do
    num = i%2
    if [ num -eq 0 ];then 
        echo -e "\e[32m $num \e[0m"
    fi    
done
