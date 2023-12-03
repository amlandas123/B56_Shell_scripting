#!/bin/bash(

#This script is going to terminate EC2 instances
if [ -z $1 ] || [ -z $2 ]; then
        echo -e "\e[31m You have entered wrong input . Please Supply the argument\e[0m"
        echo -e "\e[31m For Example: \e[0m: bash create-ec2.sh <components name>"
        exit 0
fi 
component=$1
env=$2

stop_server(){
     echo -e "\e[36m $component-$env Server stopping In Progress \e[0m"
     instance_id=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=${component}-${env}" | jq .Reservations[].Instances[].InstanceId | sed -e 's/"//g')
     aws ec2 terminate-instances --instance-ids ${instance_id}
     echo -e "\e[36m $component-$env Server is stopped \e[0m"

}

if [ $1 == "stop" ];then
    for i in frontend mongodb catalogue user cart redis mysql shipping rabbitmq payment;do
        component=$i
        stop_server
    done 
else    
    stop_server   
fi

 