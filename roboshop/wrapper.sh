#!/bin/bash

bash components/$1.sh

if [ $? -nq 0 ]; then
        echo -e "\e[31m You have entered wrong input \e[0m"
        echo -e "\e[31m For Example: \e[0m: bash wrapper.sh <components name>"
fi        