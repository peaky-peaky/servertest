#!/bin/bash

echo "start openstack configuration"
PREV_IFS=$IFS
IFS="
"

if [ -e ~/openstackope/1stope.yml ]; then
 ansible-playbook -i inventory/hosts 1stope.yml
else
 echo "prepare1styamlfile"
 exit 1
fi

openstack project list > /root/openstackope/roles/keystone/tasks/prolist
cat ~/openstackope/roles/keystone/tasks/prolist | grep service


if [ $? -ne 0 ]; then
 openstack project create --domain default --description "Service Project" service
fi

openstack user list > /root/openstackope/roles/keystone/tasks/userlist 
cat ~/openstackope/roles/keystone/tasks/userlist | grep glance

if [ $? -ne 0 ]; then
 echo "start create glance user"
 for g in $(cat ~/openstackope/glance-user)
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

openstack user list > /root/openstackope/roles/keystone/tasks/userlist

if [ -e ~/openstackope/2ndope.yml ]; then
 ansible-playbook -i inventory/hosts 2ndope.yml
else
 echo "prepare2ndyamlfile"
 exit 1
fi

openstack user list > /root/openstackope/roles/keystone/tasks/userlist
cat ~/openstackope/roles/keystone/tasks/userlist | grep nova 

if [ $? -ne 0 ]; then
 echo "start create nova user"
 for n in $(cat ~/openstackope/nova-user)
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


openstack user list > /root/openstackope/roles/keystone/tasks/userlist


if [ -e ~/openstackope/3rdope.yml ]; then
 ansible-playbook -i inventory/hosts 3rdope.yml
else
 echo "prepare3rdyamlfile"
 exit 1
fi

sleep 12
openstack compute service list > /root/openstackope/roles/novauser/tasks/nova-result


if [ -e ~/openstackope/4thope.yml ]; then
 ansible-playbook -i inventory/hosts 4thope.yml
else
 echo "prepare4thyamlfile"
 exit 1
fi

sleep 12
openstack compute service list > /root/openstackope/roles/novauser/tasks/nova-result

for service in api conductor scheduler novncproxy
do
systemctl stop nova-$service
done

openstack user list > /root/openstackope/roles/keystone/tasks/userlist
cat ~/openstackope/roles/keystone/tasks/userlist | grep neutron

if [ $? -ne 0 ]; then
 echo "start create neutron user"
 for j in $(cat ~/openstackope/neutron-user)
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

mysql -u root -h localhost -e "show databases;" > ~/openstackope/roles/mariadb/tasks/sqlresult
cat ~/sqlresult | grep neutron_ml2

if [ $? -ne 0 ]; then
 sh ~/openstackope/neutron-register.sh
fi

mysql -u root -h localhost -e "show databases;" > ~/openstackope/roles/mariadb/tasks/sqlresult

if [ -e ~/openstackope/5thope.yml ]; then
 ansible-playbook -i inventory/hosts 5thope.yml
else
 echo "prepare5thyamlfile"
 exit 1
fi

openstack network agent list  > /root/openstackope/roles/neutron/tasks/neutron-result

for service in api conductor scheduler novncproxy
do
systemctl stop nova-$service
done


if [ -e ~/openstackope/6thope.yml ]; then
 ansible-playbook -i inventory/hosts 6thope.yml
else
 echo "prepare6thyamlfile"
 exit 1
fi

openstack network list > ~/network-result
cat ~/network-result | grep sharednet1

if [ $? -ne 0 ]; then
 sh ~/openstackope/network-register.sh
fi


openstack subnet list > ~/subnet-result
sh ~/openstackope/subnet-register.sh


cat ~/openstackope/roles/keystone/tasks/prolist | grep hiroshima

if [ $? -ne 0 ]; then
 sh ~/openstackope/hiroshima.sh
fi


if [ -e ~/openstackope/7thope.yml ]; then
 ansible-playbook -i inventory/hosts 7thope.yml
else
 echo "prepare7thyamlfile"
 exit 1
fi


echo "Opereation is Success!!"
