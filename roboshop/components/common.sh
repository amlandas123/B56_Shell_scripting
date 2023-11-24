#!/bin/bash

user_id=$(id -u)
Logfile=/tmp/${component}.log
App_user=roboshop
Appuser_home="/home/${App_user}/${component}"
component_url="https://github.com/stans-robot-project/${component}/archive/main.zip"

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

create_user(){
    echo -n "Adding Application User: "
    id $App_user
    if [ $? -ne 0 ];then
        useradd $App_user
        stat $?
    else
        echo -e "\e[31m User Exist \e[0m"
    fi
}

download_cleanup_extract(){
    echo -n "Download components: "
    curl -s -L -o /tmp/${component}.zip $component_url
    stat $?

    echo -n "Clean Up filesexisting components: "
    rm -rf $Appuser_home &>> $Logfile
    stat $?

    echo -n "Extracting components: "
    cd /home/roboshop
    unzip /tmp/${component}.zip &>> $Logfile
    stat $?
}

config_components(){
    echo -n "Configuring $component permissions: "
    mv ${Appuser_home}-main $Appuser_home
    chown -R ${App_user}:${App_user} $Appuser_home
    chmod 770 $Appuser_home
    stat $?

    echo -n "configuring $component systemd file: "
    sed -i -e 's/MONGO_DNSNAME/mongod.roboshop.internal/' $Appuser_home/systemd.service
    mv $Appuser_home/systemd.service /etc/systemd/system/${component}.service
    stat $?

}

service_start(){
    echo -n "Starting ${component} service: "
    systemctl daemon-reload
    systemctl enable ${component} &>> $Logfile
    systemctl start ${component}
    stat $?
}

NodeJS(){
    #echo -n " NodeJS installation: "
    #curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
    yum install nodejs -y &>> $Logfile
    stat $?

    create_user     #call create user function
    download_cleanup_extract  #call function to download,cleanup and extract
    config_components   #call function for configuring components

    echo -n "Generating Artifacts for application: "
    cd /home/roboshop
    npm install &>> $Logfile
    stat $?

    service_start       #call function to start service


}