#!/bin/bash

cat ~/sqluser | grep 7.1.1.20

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

 mysql -u root -h localhost -e "CREATE USER root@7.1.1.20;"
 mysql -u root -h localhost -e "GRANT ALL PRIVILEGES ON *.* to root@7.1.1.20 WITH GRANT OPTION;"
 cp ~/servertest/roles/mariadb/tasks/.my.cnf ~/
 systemctl restart mysql
fi

mysql -u root -h 7.1.1.20 -e "SELECT user, host FROM mysql.user;" > ~/sqluser
mysql -u root -h 7.1.1.20 -e "show databases;" > ~/sqlresult
cat ~/sqlresult | grep keystone

if [ $? -ne 0 ]; then
 mysql -u root -h 7.1.1.20 -e "create database keystone;"
 mysql -u root -h 7.1.1.20 -e "grant all privileges on keystone.* to keystone@'localhost' identified by 'password';"
 mysql -u root -h 7.1.1.20 -e "grant all privileges on keystone.* to keystone@'%' identified by 'password';"
fi

mysql -u root -h 7.1.1.20 -e "show databases;" > ~/sqlresult
