#!/bin/bash

echo -e "\e[32m ******Configuring redis******\e[0m"

component=redis

source components/common.sh

redis

echo -e "\e[32m ******Configuring redis Completed******\e[0m"

set-hostname $component

