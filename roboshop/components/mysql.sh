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
default_root_passwd=$(grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
echo $default_root_passwd
stat $?

echo "show databases;" | mysql -uroot -pRoboShop@1 &>> $Logfile
if [ $? -ne 0 ]; then 
    echo -n "Changing $component root password:"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1'" | mysql --connect-expired-password -uroot -p$defdefault_root_passwd &>> $Logfile
    stat $?
fi 


echo "show plugins;" |  mysql -uroot -pRoboShop@1 | grep validate_password &>> $Logfile
if [ $? -eq 0 ]; then 
    echo -n "Uninstalling password-validate-plugin:"
    echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1 &>> $Logfile
    stat $?
fi 

echo -n "Downloading $component Schema:"
curl -s -L -o /tmp/${component}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $? 

echo -n "Extracting Schema:"
unzip -o /tmp/${component}.zip  &>> $Logfile
stat $? 

echo -n "Injecting Schema:"
cd ${component}-main 
mysql -u root -pRoboShop@1 <shipping.sql &>> $Logfile
stat $? 

