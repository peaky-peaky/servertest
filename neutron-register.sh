#!/bin/bash

mysql -u root -h localhost -e "create database neutron_ml2;"
mysql -u root -h localhost -e "grant all privileges on neutron_ml2.* to neutron@'localhost' identified by 'password';"
mysql -u root -h localhost -e "grant all privileges on neutron_ml2.* to neutron@'%' identified by 'password';"
