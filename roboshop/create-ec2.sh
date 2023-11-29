#!/bin/bash

#This script is going to create EC2 instances

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq .Images[].ImageId | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=B56-Security-group |jq .SecurityGroups[].GroupId |sed -e 's/"//g')
Ins_type=t3.micro
Hosted_zone_id="Z07819082GXA8VTNL4M4B"
component=$1
echo -e "\e[32m $component Server Creation In Progress \e[0m"
private_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro --security-group-ids ${SG_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')

echo -e "\e[32m $component DNS record Creation In Progress \e[0m"
sed -e 's/Component/${component}' -e 's/Ipaddress/${private_IP}' route53.json > /tmp/DNS.json
aws route53 change-resource-record-sets --hosted-zone-id ${Hosted_zone_id} --change-batch file:///tmp/DNS.json