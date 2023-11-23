#!/bin/bash

echo -e "\e[32m ******Configuring mongodb******\e[0m"

user_id=$(id -u)
component=mongodb
mongo_url=https://raw.githubusercontent.com/stans-robot-project/${component}/main/mongo.repo
schema_url=https://github.com/stans-robot-project/${component}/archive/main.zip
Logfile=/tmp/${component}.log

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

echo -n "Setting mongo DB repos:"
curl -s -o /etc/yum.repos.d/${component}.repo   $mongo_url
stat $?


echo -n "Installing ${component}: "
yum install -y mongodb-org  &>> $Logfile
stat $?

echo -n "Enabling ${component}: "
systemctl enable mongod  &>> $Logfile
stat $?

echo -n "Starting ${component}: "
systemctl start mongod  &>> $Logfile
stat $?

echo -n "Enabling Visibility of ${component}: "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
systemctl restart mongod
stat $?

echo -n "Downloading the Schema: "
curl -s -L -o /tmp/mongodb.zip $schema_url 
stat $?

echo -n "Extracting the Zip file: "
cd /tmp
unzip -o mongodb.zip &>> $Logfile
stat $?

echo -n "Injecting the Schemas: "
cd mongodb-main
mongo < catalogue.js &>> $Logfile
mongo < users.js &>> $Logfile
stat $?