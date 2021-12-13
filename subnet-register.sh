#!/bin/bash

for subnet in 1 2
do
cat ~/subnet-result | grep subnet${subnet}
if [ $? -ne 0 ]; then
 sh ~/openstackope/subnet${subnet}.sh
 if [ $? -eq 0 ]; then
 echo "subnet"${subnet} created
 else
 echo "subnet"${subnet} error..
 fi
fi
done
