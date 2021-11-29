#!/bin/bash

echo "start openstack configuration"
PREV_IFS=$IFS
IFS="
"
cat ~/servertest/roles/keystone/tasks/userlist | grep neutron

if [ $? -ne 0 ]; then
 echo "start create neu user"
 for g in $(cat ~/servertest/neutron-user)
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
