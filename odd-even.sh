#!/bin/bash
echo -e "\e[36m ****Odd or Even Please check**** \e[0m"
echo -e "\e[32m Enter the number: \e[0m"
read num
if [ `expr $num % 2` == 0 ]
then
	echo "$num is even";
else
	echo "$num is Odd";
fi
