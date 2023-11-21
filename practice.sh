#!/bin/bash

echo -e "\e[32m Enter Your name: \e[0m \t"
read name
echo -e "\e[32m Enter Your age: \e[0m \t]"
read age

if [ $age -lt 18 ]; then
      echo -e "\e[31m You are not eligible to Enter \e[0m"
      exit 0
else 
      echo -e "\e[36m Welcome $name to the Hall \e[0m"
      exit 1
fi

          