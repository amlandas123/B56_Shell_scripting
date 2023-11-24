#!/bin/bash

user_id=$(id -u)
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