#!/bin/bash

echo -e "\e[32m ******Configuring user******\e[0m"
component=user
source components/common.sh

NodeJS

echo -n "configuring $component systemd file: "
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' $Appuser_home/systemd.service
#sed -i -e 's/MONGO_ENDPOINT/mongod.roboshop.internal/' $Appuser_home/systemd.service
mv $Appuser_home/systemd.service /etc/systemd/system/${component}.service
stat $?

echo -n "Generating Artifacts for application: "
cd $Appuser_home
npm install &>> $Logfile
stat $?

service_start


echo -e "***** \e[35m $component Configuration Is Completed \e[0m ******"
