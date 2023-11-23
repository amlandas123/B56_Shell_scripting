#!/bin/bash

echo -e "\e[32m ******Configuring catalogue******\e[0m"
user_id=$(id -u)
component=catalogue
Logfile=/tmp/${component}.log
App_user=roboshop
Appuser_home=/home/${App_user}/${component}
cat_url=https://github.com/stans-robot-project/${component}/archive/main.zip

if [ user_id -ne 0 ];then
        echo -e "\e[31m Run the program as sudo user \e[0m "
        exit 1
fi

stat() {
    if [ $1 -eq 0 ];then
            echo -e "\e[32m Success \e[0m"
    else
            echo -e "\e[31m Failure \e[0m"
    fi
}

echo -n " NodeJS installation: "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install nodejs -y
stat $?

echo -n "Adding Application User: "
id $App_user
if [ $? -ne 0 ];then
    useradd $App_user
    stat $?
else
    echo -e "\e[31m User Exist \e[0m"
fi

echo -n "Download components: "
curl -s -L -o /tmp/${component}.zip $cat_url
stat $?

echo -n "Clean Up filesexisting components: "
rm -rf $Appuser_home &>> $Logfile
stat $?

echo -n "Extracting components: "
cd /home/roboshop
unzip /tmp/${component}.zip &>> $Logfile
stat $?

echo -n "Installing Components: "
mv catalogue-main catalogue
cd $Appuser_home
npm install &>> $Logfile




