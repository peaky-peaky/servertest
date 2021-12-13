#!/bin/bash

mysql -u root -h localhost -e "SELECT user, host FROM mysql.user;" > ~/sqlresult
cat ~/openstackope/roles/glance/tasks/sqlresult | grep glance

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database glance;"
 mysql -u root -h localhost -e "grant all privileges on glance.* to glance@'localhost' identified by 'password';"
 mysql -u root -h localhost -e "grant all privileges on glance.* to glance@'%' identified by 'password';"
 mysql -u root -h localhost -e "flush privileges;"
fi

mysql -u root -h localhost -e "SELECT user, host FROM mysql.user;" > ~/sqlresult
