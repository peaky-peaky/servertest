#!/bin/bash

ansible-playbook -i inventory/hosts ope.yml

openstack project list > ~/servertest/roles/keystone/tasks/prolist
cat ~/roles/keystone/tasks/prolist | grep service

if [ $? -ne 0 ]; then
 openstack project create --domain default --description "Service Project" service
fi

openstack user list 
cat ~/servertest/roles/keystone/tasks/userlist | grep glance

if [ $? -ne 0 ]; then
 openstack user create --domain default --project service --password servicepassword glance 
 openstack role add --project service --user glance admin
 openstack service create --name glance --description "OpenStack Image service" image 
 openstack endpoint create --region RegionOne image public http://7.1.1.20:9292 
 openstack endpoint create --region RegionOne image internal http://7.1.1.20:9292 
 openstack endpoint create --region RegionOne image admin http://7.1.1.20:9292 
fi
