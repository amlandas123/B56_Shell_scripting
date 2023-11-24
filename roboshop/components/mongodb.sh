#!/bin/bash

echo -e "\e[32m ******Configuring mongodb******\e[0m"
component=mongodb
source components/common.sh
mongo_DB    #Calling function from common.sh

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

echo -e "\e[32m ******Completed Configuring mongodb******\e[0m"