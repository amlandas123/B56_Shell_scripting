#!/bin/bash

echo -e "\e[32m ******Configuring shipping******\e[0m"

component=shipping

source components/common.sh

Maven

echo -e "\e[32m ******Completed Configuring shipping******\e[0m"

set-hostname ${component}

