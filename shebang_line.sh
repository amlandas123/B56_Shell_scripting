
#!/bin/bash

echo -e "Enter your name:\t"
read name
echo -e "enter your ID:\t"
read id
useradd -u $id $name
echo -e "User $name has been added succesfully\n"