#!/bin/bash

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep nova

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database nova;"
 sleep 3
 mysql -u root -h localhost -e "grant all privileges on nova.* to nova@'localhost' identified by 'password';"
 sleep 3
 mysql -u root -h localhost -e "grant all privileges on nova.* to nova@'%' identified by 'password';"
fi

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep nova_api

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database nova_api;"
 sleep 3
 mysql -u root -h localhost -e "grant all privileges on nova_api.* to nova_api@'localhost' identified by 'password';"
 sleep 3
 mysql -u root -h localhost -e "grant all privileges on nova_api.* to nova_api@'%' identified by 'password';"
fi

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep placement

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database placement;"
 sleep 3
 mysql -u root -h localhost -e "grant all privileges on placement.* to placement@'localhost' identified by 'password';"
 sleep 3
 mysql -u root -h localhost -e "grant all privileges on placement.* to placement@'%' identified by 'password';"
fi

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep nova_cell0

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database nova_cell0;"
 sleep 3
 mysql -u root -h localhost -e "grant all privileges on nova_cell0.* to nova_cell0@'localhost' identified by 'password';"
 sleep 3
 mysql -u root -h localhost -e "grant all privileges on nova_cell0.* to nova_cell0@'%' identified by 'password';"
 mysql -u root -h localhost -e "flush privileges;"
fi

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
