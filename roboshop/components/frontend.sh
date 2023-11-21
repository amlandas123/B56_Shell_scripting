#!/bin/bash

#echo -e "\e[32m ******Configuring Frontend******\e[0m"

user_id=$(id -u)
component=$1

if [ $user_id -ne 0 ];then
        echo -e"\e[32m Please run the program as sudo user \e[0m"
#        echo -e"\e[31m Example usage:\n \t\t \e[0m sudo bash scriptname componentname"
        exit 1
fi

echo -e "\e[32m ******Configuring Frontend******\e[0m"

echo -n "Installing Nginx:"
yum install -y nginx &>> /tmp/frontend.log

if [ $? -eq 0 ];then
        echo -e "\e[32m Nginx Installed Successfully [0m"
else
        echo -e "\e[31m Nginx Installation failed [0m"
fi

echo -n "Downloading Component $1 :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
if [ $? -eq 0 ] ; then 
    echo -e "\e[32m Success \e[0m"
else 
    echo -e "\e[31m Failure \e[0m"
fi 


echo -n "Enabling Nginx"
systemctl enable nginx &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then 
    echo -e "\e[32m Successfully Enabled \e[0m"
else 
    echo -e "\e[31m Failure \e[0m"
fi 



