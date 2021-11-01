#!bin/bash

openstack user list > ~/roles/keystone/tasks/userlist

cat ~/roles/keystone/tasks/userlist | grep service

if [ $? -ne 0 ]; then
 openstack project create --domain default --description "Service Project" service 
fi

openstack user list > ~/roles/keystone/tasks/userlist
