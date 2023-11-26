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
systemctl enable mysqld &>> $Logfile
systemctl start mysqld &>> $Logfile
systemctl status mysqld &>> $Logfile
stat $?

echo -n "**** Extracting Default root password ****"
default_root_passwd= grep "temporary password" /var/log/mysqld.log | awk '{print $NF}'
stat $?



