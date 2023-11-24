#!/bin/bash

user_id=$(id -u)
Logfile=/tmp/${component}.log
App_user=roboshop
Appuser_home=/home/${App_user}/${component}
cat_url=https://github.com/stans-robot-project/${component}/archive/main.zip
