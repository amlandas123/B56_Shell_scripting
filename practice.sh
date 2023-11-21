#!/bin/bash

echo -e "\e[32m Enter Your name: \e[0m \t"
read name
echo -e "\e[31m Enter Your age: \e[0m \t]"
read age

if [ $age -lt 18 ]; then
      echo " You are not eligible to Enter"
else 
      echo " Welcome $name to the Hall
fi

          