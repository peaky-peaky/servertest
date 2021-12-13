#!/bin/bash

echo "start openstack configuration"
PREV_IFS=$IFS
IFS="
"
cat ~/sqlresult | grep neutron_ml2

if [ $? -ne 0 ]; then
 for i in $(cat ~/openstackope/neutron-register)
 do
 IFS=$PREV_IFS
 echo ${i} | mysql -u root -h 7.1.1.20
 if [ $? -eq 0 ]; then
  echo ${i} "is ok"
 else
  echo "error.."
  exit 1
 fi
 done
fi
