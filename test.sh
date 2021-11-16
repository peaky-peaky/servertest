#!/bin/bash

echo "start openstack configuration"
PREV_IFS=$IFS
IFS="
"

if [ $? -ne 0 ]; then
 for i in $(cat ~/servertest/neutron-register)
 do
 IFS=$PREV_IFS
 `mysql -u root -h 7.1.1.20 -e $i`
 if [ $? -eq 0 ]; then
  echo $i "is ok"
 else
  echo "error.."
  exit 1
 fi
 done
fi
