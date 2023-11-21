#!/bin/bash

n=7
for (( i=1 ; i<=$n ; i++ )); 
do
    num=(i % 2)
    if [ num == 0 ];then
        echo $num
    fi
done
