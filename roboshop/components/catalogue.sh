#!/bin/bash

echo -e "\e[32m ******Configuring catalogue******\e[0m"
source components/common.sh
component=catalogue



#echo -n " NodeJS installation: "
#curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install nodejs -y &>> $Logfile
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
stat $?

echo -n "Updating Mongodb DNS: "
sed -i -e 's/MONGO_DNSNAME/mongod.roboshop.internal/' $Appuser_home/systemd.service
stat $?

echo -n "Updating Mongod service: "
mv $Appuser_home/systemd.service /etc/systemd/system/${component}.service
stat $?

echo -n "Starting ${component} service: "
systemctl daemon-reload
systemctl enable ${component} &>> $Logfile
systemctl start ${component}
stat $?

