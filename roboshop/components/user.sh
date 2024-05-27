#!/bin/bash

echo -e "\e[32m ******Configuring user******\e[0m"
component=user
source components/common.sh

NodeJS

echo -e "***** \e[35m $component Configuration Is Completed \e[0m ******"
set-hostname $component