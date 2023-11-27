#!/bin/bash

user_id=$(id -u)
Logfile=/tmp/${component}.log

## Variabls for Application
App_user=roboshop
Appuser_home="/home/${App_user}/${component}"
component_url="https://github.com/stans-robot-project/${component}/archive/main.zip"

##Variables for Database
mongo_url=https://raw.githubusercontent.com/stans-robot-project/${component}/main/mongo.repo
schema_url=https://github.com/stans-robot-project/${component}/archive/main.zip
redis_url=https://raw.githubusercontent.com/stans-robot-project/$component/main/${component}.repo

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
        echo -e "\e[31m User Already Exist \e[0m"
    fi
}
#This Function is for NodeJS
download_cleanup_extract(){
    echo -n "Download components: "
    curl -s -L -o /tmp/${component}.zip $component_url
    stat $?

    echo -n "Clean Up $App_user existing components: "
    rm -rf $Appuser_home &>> $Logfile
    stat $?

    echo -n "Extracting components: "
    cd /home/roboshop
    unzip -o /tmp/${component}.zip &>> $Logfile
    stat $?
}
#This Function is for NodeJS
config_components(){
    echo -n "Configuring $component permissions: "
    mv ${Appuser_home}-main ${Appuser_home}
    chown -R ${App_user}:${App_user} $Appuser_home
    chmod 770 $Appuser_home
    stat $?

    echo -n "Configuring $component Systemd file: "
    sed -i -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' ${APPUSER_HOME}/systemd.service
    mv ${Appuser_home}/systemd.service /etc/systemd/system/${component}.service
    stat $?
}

}
#This Function is for NodeJS
service_start(){
    echo -n "Starting ${component} service: "
    systemctl daemon-reload
    systemctl enable ${component} &>> $Logfile
    systemctl start ${component}
    stat $?
}
#This Function is for NodeJS
NodeJS(){
    echo -n " NodeJS installation: "
    curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
    yum install nodejs -y &>> $Logfile
    stat $?

    create_user     #call create user function
    download_cleanup_extract  #call function to download,cleanup and extract
    config_components   #call function for configuring components
    
    echo -n "Generating Artifacts for application: "
    cd $Appuser_home
    npm install &>> $Logfile
    stat $?

    service_start
}

#This function is for Maven app installation
Maven(){
    echo -n "Installing Maven: "
    yum install maven -y  &>> $Logfile
    stat $?

    create_user      #Function calling for creating user

    download_cleanup_extract #Function Called for downloading, cleanup and extracting components

    echo -n "Generating Artifacts for application: "
    cd $Appuser_home
    mvn clean package &>> $Logfile
    mv target/shipping-1.0.jar shipping.jar
    stat $?

    config_components     #Function called for configuring installed components

    service_start        #Function called for Starting the Services
}





#This Function is for Mongo DB
config_mongodb(){
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
}
#This Function is for Mongo DB
mongo_DB(){
    echo -n "Setting mongo DB repos:"
    curl -s -o /etc/yum.repos.d/${component}.repo   $mongo_url
    stat $?

    echo -n "Installing ${component}: "
    yum install -y mongodb-org  &>> $Logfile
    stat $?

    config_mongodb
}

#This Function is for Redis
redis_config(){
    echo -n "Enabling Visibility of $component: "
    sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis.conf 
    sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis/redis.conf
    stat $?

    echo -n "Starting and Enabling $component"
    systemctl enable redis  &>> $Logfile
    systemctl start redis  &>> $Logfile
    systemctl status redis -l &>> $Logfile
}
#This Function is for Redis
redis(){
    echo -n "Dowloading repo and installing Redis: "
    curl -L $redis_url -o /etc/yum.repos.d/${component}.repo
    stat $?

    echo -n "Installing Redis: "
    yum install redis-6.2.13 -y &>> $Logfile
    stat $?

    redis_config
}










}