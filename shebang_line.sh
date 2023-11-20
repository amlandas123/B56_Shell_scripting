
#!/bin/bash

echo -e "\e[31m Enter your name:\e[0m\t"
read name
echo -e "enter your ID:\t"
read id
useradd -u $id $name
echo -e "User $name with id $id has been added succesfully\n"