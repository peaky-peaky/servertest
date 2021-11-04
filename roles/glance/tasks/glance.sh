#!/bin/bash

mysql -u root -h 7.1.1.20 -e "SELECT user, host FROM mysql.user;" > ~/servertest/roles/glance/tasks/sqlresult
cat ~/servertest/roles/glance/tasks/sqlresult | grep glance

if [ $? -ne 0 ]; then
 mysql -u root -h 7.1.1.20 -e "create database glance;"
 mysql -u root -h 7.1.1.20 -e "grant all privileges on glance.* to glance@'localhost' identified by 'password';"
 mysql -u root -h 7.1.1.20 -e "grant all privileges on glance.* to glance@'%' identified by 'password';"
 mysql -u root -h 7.1.1.20 -e "flush privileges;"
fi

mysql -u root -h 7.1.1.20 -e "SELECT user, host FROM mysql.user;" > ~/servertest/roles/glance/tasks/sqlresult
