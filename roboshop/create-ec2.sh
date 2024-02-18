#!/bin/bash(

#This script is going to create EC2 instances
if [ -z $1 ] || [ -z $2 ]; then
        echo -e "\e[31m You have entered wrong input . Please Supply the argument\e[0m"
        echo -e "\e[31m For Example: \e[0m: bash create-ec2.sh <components name>"
        exit 0
fi 
component=$1
env=$2
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq .Images[].ImageId | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=B56-Security-group |jq .SecurityGroups[].GroupId |sed -e 's/"//g')
Ins_type=t3.micro
Hosted_zone_id="Z09824163U3ILH99HO9CG"
#instance_id=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=user-dev" | jq .Reservations[].Instances[].InstanceId | sed -e 's/"//g')

create_server(){
    echo -e "\e[36m $component-$env Server Creation In Progress \e[0m"
    private_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro --security-group-ids ${SG_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}-${env}}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')
    echo -e "\e[32m $component-${env} Server Creation is completed \e[0m"
    echo -e "\e[36m $component-${env} DNS record Creation In Progress \e[0m \n\n"
    sed -e "s/Component/${component}-${env}/" -e "s/Ipaddress/${private_IP}/" route53.json > /tmp/DNS.json
    aws route53 change-resource-record-sets --hosted-zone-id ${Hosted_zone_id} --change-batch file:///tmp/DNS.json
    echo -e "\e[32m $component-${env} DNS record has been created \e[0m"

}


if [ $1 == "all" ];then
    for i in frontend mongodb catalogue user cart redis mysql shipping rabbitmq payment;do
        component=$i
        create_server
    done 
else    
    create_server   
fi

   