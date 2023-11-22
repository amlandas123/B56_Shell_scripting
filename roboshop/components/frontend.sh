#!/bin/bash

#echo -e "\e[32m ******Configuring Frontend******\e[0m"

user_id=$(id -u)
component=frontend
app_log= "/tmp/${component}.log"

if [ $user_id -ne 0 ];then
        echo -e "\e[32m Please run the program as sudo user \e[0m"
        exit 1
fi
stat(){
    if [ $1 -eq 0 ];then
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failure \e[0m"
    fi
}

echo -e "\e[32m ******Configuring $component******\e[0m"

echo -n "Installing Nginx:"
yum install nginx -y  &>>  $app_log
stat $?


echo -n "Downloading Nginx $Component  :"
curl -s -L -o /tmp/${component}.zip "https://github.com/stans-robot-project/$component/archive/main.zip"
stat $?

echo -n "Enabling Nginx:"
systemctl enable nginx &>> $app_log
stat $?

echo -n "starting Nginx:"
systemctl start nginx &>> $app_log
stat $?


echo -n "Nginx Status:"
systemctl status nginx &>> $app_log
stat $?
echo -n "Component cleanup"
cd /usr/share/nginx/html
rm -rf *
stat $?

echo -n "Component Extraction"
unzip -o /tmp/${component}.zip &>> $app_log
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -e "\e[32m ******Configuring $component Successful******\e[0m"



