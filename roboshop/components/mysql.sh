#!/bin/bash

echo -e "\e[32m ******Configuring mysql******\e[0m"

component=mysql

source components/common.sh

echo -n "***** Configuring $component *****"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "***** Installing $component *****"
yum install mysql-community-server -y
stat $?

echo -n "**** starting $component ****"
systemctl enable $component &>> $Logfile
systemctl start $component &>> $Logfile
systemctl status $component &>> $Logfile
stat $?



