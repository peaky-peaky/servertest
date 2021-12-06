#!/bin/bash

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep nova

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database nova;"
 mysql -u root -h localhost -e "grant all privileges on nova.* to nova@'localhost' identified by 'password';"
 mysql -u root -h localhost -e "grant all privileges on nova.* to nova@'%' identified by 'password';"
fi

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep nova_api

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database nova_api;"
 mysql -u root -h localhost -e "grant all privileges on nova_api.* to nova@'localhost' identified by 'password';"
 mysql -u root -h localhost -e "grant all privileges on nova_api.* to nova@'%' identified by 'password';"
fi

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep placement

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database placement;"
 mysql -u root -h localhost -e "grant all privileges on placement.* to placement@'localhost' identified by 'password';"
 mysql -u root -h localhost -e "grant all privileges on placement.* to placement@'%' identified by 'password';"
fi

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep nova_cell0

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database nova_cell0;"
 mysql -u root -h localhost -e "grant all privileges on nova_cell0.* to nova@'localhost' identified by 'password';"
 mysql -u root -h localhost -e "grant all privileges on nova_cell0.* to nova@'%' identified by 'password';"
fi

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
