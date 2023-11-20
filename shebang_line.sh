
#!/bin/bash

echo -e "\e[31:43m Enter your name:\e[0m\t"
read name
echo -e "\e[36m Enter your ID:\e[0m\t"
read id
useradd -u $id $name
echo -e "\e[94m User $name with id $id has been added succesfully\e[0m\n"
echo $?