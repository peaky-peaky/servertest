#!/bin/bash

echo "start openstack configuration"
PREV_IFS=$IFS
IFS="
"

if [ -e ~/servertest/1stope.yml ]; then
 ansible-playbook -i inventory/hosts 1stope.yml
else
 echo "prepare1styamlfile"
 exit 1
fi

openstack project list > /root/servertest/roles/keystone/tasks/prolist
cat ~/servertest/roles/keystone/tasks/prolist | grep service


if [ $? -ne 0 ]; then
 openstack project create --domain default --description "Service Project" service
fi

openstack user list > /root/servertest/roles/keystone/tasks/userlist 
cat ~/servertest/roles/keystone/tasks/userlist | grep glance

if [ $? -ne 0 ]; then
 echo "start create glance user"
 for g in $(cat ~/servertest/glance-user)
 do
 IFS=$PREV_IFS
 $g
 if [ $? -eq 0 ]; then
  echo $g "is ok"
 else
  echo "error.."
  exit 1
 fi
 done
fi

openstack user list > /root/servertest/roles/keystone/tasks/userlist

if [ -e ~/servertest/2ndope.yml ]; then
 ansible-playbook -i inventory/hosts 2ndope.yml
else
 echo "prepare2ndyamlfile"
 exit 1
fi

openstack user list > /root/servertest/roles/keystone/tasks/userlist
cat ~/servertest/roles/keystone/tasks/userlist | grep nova 

if [ $? -ne 0 ]; then
 echo "start create nova user"
 for n in $(cat ~/servertest/nova-user)
 do
 IFS=$PREV_IFS
 $n
 if [ $? -eq 0 ]; then
  echo $n "is ok"
 else
  echo "error.."
  exit 1
 fi
 done
fi


openstack user list > /root/servertest/roles/keystone/tasks/userlist


if [ -e ~/servertest/3rdope.yml ]; then
 ansible-playbook -i inventory/hosts 3rdope.yml
else
 echo "prepare3rdyamlfile"
 exit 1
fi

sleep 12
openstack compute service list > /root/servertest/roles/novauser/tasks/nova-result


if [ -e ~/servertest/4thope.yml ]; then
 ansible-playbook -i inventory/hosts 4thope.yml
else
 echo "prepare4thyamlfile"
 exit 1
fi

sleep 12
openstack compute service list > /root/servertest/roles/novauser/tasks/nova-result

for service in api conductor scheduler novncproxy
do
systemctl stop nova-$service
done

openstack user list > /root/servertest/roles/keystone/tasks/userlist
cat ~/servertest/roles/keystone/tasks/userlist | grep neutron

if [ $? -ne 0 ]; then
 echo "start create neutron user"
 for j in $(cat ~/servertest/neutron-user)
 do
 IFS=$PREV_IFS
 $j
 if [ $? -eq 0 ]; then
  echo $j "is ok"
 else
  echo "error.."
  exit 1
 fi
 done
fi

mysql -u root -h localhost -e "show databases;" > ~/servertest/roles/mariadb/tasks/sqlresult
cat ~/sqlresult | grep neutron_ml2

if [ $? -ne 0 ]; then
 sh ~/servertest/neutron-register.sh
fi

mysql -u root -h localhost -e "show databases;" > ~/servertest/roles/mariadb/tasks/sqlresult

if [ -e ~/servertest/5thope.yml ]; then
 ansible-playbook -i inventory/hosts 5thope.yml
else
 echo "prepare5thyamlfile"
 exit 1
fi

openstack network agent list  > /root/servertest/roles/neutron/tasks/neutron-result

for service in api conductor scheduler novncproxy
do
systemctl stop nova-$service
done

echo "Opereation is Success!!"
