#!/bin/bash
user_id=$(id -u)
Logfile=/tmp/temp.log
if [ $user_id -ne 0 ];then
        echo -e "\e[32m Please run the program as sudo user \e[0m"
        exit 1
fi

stat(){
    if [ $1 -eq 0 ];then
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failure \e[0m"
    fi
}

create_user(){
    echo -n "Adding Application User $username"
    id $username >> $Logfile
    if [ $? -ne 0 ];then
        useradd $username
        stat $?
    else
        echo -e "\e[31m User Already Exist \e[0m"
    fi
}

echo -e "\e[36m Enter username to be added: \e[0m"
read username
create_user
