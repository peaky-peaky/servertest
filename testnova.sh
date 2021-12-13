#!/bin/bash

echo "start openstack configuration"
PREV_IFS=$IFS
IFS="
"
cat ~/openstackope/roles/keystone/tasks/userlist | grep nova

if [ $? -ne 0 ]; then
 echo "start create nova user"
 for g in $(cat ~/openstackope/nova-user)
 do
 IFS=$PREV_IFS
 $g
 if [ $? -eq 0 ]; then
  echo $g "is ok"
 else
  echo "error.."
  exit 1
 fi
 done
fi
