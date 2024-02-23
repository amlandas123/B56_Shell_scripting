#!/bin/bash(

#This script is going to terminate EC2 instances
if [ -z $1 ] || [ -z $2 ]; then
        echo -e "\e[31m You have entered wrong input . Please Supply the argument\e[0m"
        echo -e "\e[31m For Example: \e[0m: bash create-ec2.sh <components name>"
        exit 0
fi 
component=$1
env=$2
Hosted_zone_id="Z09824163U3ILH99HO9CG"

stop_server(){
     echo -e "\e[36m $component-$env Server stopping In Progress \e[0m"
     instance_id=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=${component}-${env}" | jq .Reservations[].Instances[].InstanceId | sed -e 's/"//g')
     private_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro --security-group-ids ${SG_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}-${env}}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')
     aws ec2 terminate-instances --instance-ids ${instance_id}
     echo -e "\e[36m $component-$env Server is stopped \e[0m"
     echo -e "\e[36m $component-${env} DNS record Deletion In Progress \e[0m \n\n"
     #sed -e "s/component/${component}-${env}/" route53del.json > /tmp/DNS.json
     aws route53 change-resource-record-sets --hosted-zone-id ${Hosted_zone_id} --change-batch file:/home/centos/shell-scripting/B56_Shell_scripting/roboshop/route53del.json
     echo -e "\e[32m $component-${env} DNS record has been deleted \e[0m"

}

if [ $1 == "stop" ];then
    for i in frontend mongodb catalogue user cart redis mysql shipping rabbitmq payment;do
        component=$i
        stop_server
    done 
else    
    stop_server   
fi

 