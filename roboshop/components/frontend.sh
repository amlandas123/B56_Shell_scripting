#!/bin/bash

#echo -e "\e[32m ******Configuring Frontend******\e[0m"

user_id=$(id -u)
component=$1

if [ $user_id -ne 0 ];then
        echo -e "\e[32m Please run the program as sudo user \e[0m"
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

echo -n "starting Nginx"
systemctl start nginx &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then 
    echo -e "\e[32m Successfully Started \e[0m"
else 
    echo -e "\e[31m Failure \e[0m"
fi 

echo -n " Nginx Status"
systemctl status nginx &>> /tmp/frontend.log

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf



