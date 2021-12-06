#!/bin/bash

cat ~/servertest/roles/mariadb/tasks/sqluser | grep root

if [ $? -ne 0 ]; then
 expect -c '
     spawn mysql_secure_installation;
     expect "Enter current password for root (enter for none):";
     send "\n";
     expect "Set root password?";
     send "n\n";
     expect "Remove anonymous users?";
     send "n\n";
     expect "Disallow root login remotely?";
     send "n\n";
     expect "Remove test database and access to it?";
     send "n\n";
     expect "Reload privilege tables now?";
     send "y\n";
     interact;'

 #cp ~/servertest/roles/mariadb/tasks/.my.cnf ~/
 systemctl restart mysql
fi

mysql -u root -h localhost -e "SELECT user, host FROM mysql.user;" > ~/sqluser
mysql -u root -h localhost -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep keystone

if [ $? -ne 0 ]; then
 mysql -u root -h localhost -e "create database keystone;"
 mysql -u root -h localhost -e "grant all privileges on keystone.* to keystone@'localhost' identified by 'password';"
 mysql -u root -h localhost -e "grant all privileges on keystone.* to keystone@'%' identified by 'password';"
fi

mysql -u root -h localhost -e "show databases;" > ~/sqlresult
