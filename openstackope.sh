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
 echo "create glance user"
 openstack user create --domain default --project service --password servicepassword glance
 openstack role add --project service --user glance admin
 openstack service create --name glance --description "OpenStack Image service" image
 openstack endpoint create --region RegionOne image public http://7.1.1.20:9292
 openstack endpoint create --region RegionOne image internal http://7.1.1.20:9292
 openstack endpoint create --region RegionOne image admin http://7.1.1.20:9292
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
 openstack user create --domain default --project service --password servicepassword nova
 openstack role add --project service --user nova admin
 openstack user create --domain default --project service --password servicepassword placement
 openstack role add --project service --user placement admin
 openstack service create --name nova --description "OpenStack Compute service" compute
 openstack service create --name placement --description "OpenStack Compute Placement service" placement
 openstack endpoint create --region RegionOne compute public http://7.1.1.20:8774/v2.1/%\(tenant_id\)s
 openstack endpoint create --region RegionOne compute internal http://7.1.1.20:8774/v2.1/%\(tenant_id\)s
 openstack endpoint create --region RegionOne compute admin http://7.1.1.20:8774/v2.1/%\(tenant_id\)s
 openstack endpoint create --region RegionOne placement public http://7.1.1.20:8778
 openstack endpoint create --region RegionOne placement internal http://7.1.1.20:8778
 openstack endpoint create --region RegionOne placement admin http://7.1.1.20:8778
fi

openstack user list > /root/servertest/roles/keystone/tasks/userlist


if [ -e ~/servertest/3rdope.yml ]; then
 ansible-playbook -i inventory/hosts 3rdope.yml
else
 echo "prepare3rdyamlfile"
 exit 1
fi

openstack compute service list > /root/servertest/roles/novauser/tasks/nova-result


if [ -e ~/servertest/4thope.yml ]; then
 ansible-playbook -i inventory/hosts 4thope.yml
else
 echo "prepare4thyamlfile"
 exit 1
fi

openstack compute service list > /root/servertest/roles/novauser/tasks/nova-result

openstack user list > /root/servertest/roles/keystone/tasks/userlist
cat ~/servertest/roles/keystone/tasks/userlist | grep neutron

if [ $? -ne 0 ]; then
 echo "start create neutron user"
 openstack user create --domain default --project service --password servicepassword neutron
 openstack role add --project service --user neutron admin
 openstack service create --name neutron --description "OpenStack Networking service" network
 openstack endpoint create --region RegionOne network public http://7.1.1.20:9696
 openstack endpoint create --region RegionOne network internal http://7.1.1.20:9696
 openstack endpoint create --region RegionOne network admin http://7.1.1.20:9696
fi

openstack user list > /root/servertest/roles/keystone/tasks/userlist
cat ~/sqlresult | grep neutron_ml2

if [ $? -ne 0 ]; then
 for i in $(cat ~/servertest/neutron-register)
 do
 IFS=$PREV_IFS
 `mysql -u root -h 7.1.1.20 -e $i`
 if [ $? -eq 0 ]; then
  echo $i "is ok"
 else
  echo "error.."
  exit 1
 fi
 done
fi

mysql -u root -h 7.1.1.20 -e "show databases;" > ~/sqlresult

if [ -e ~/servertest/5thope.yml ]; then
 ansible-playbook -i inventory/hosts 5thope.yml
else
 echo "prepare5thyamlfile"
 exit 1
fi

openstack network agent list  > /root/servertest/roles/neutron/tasks/neutron-result

echo "Opereation is Success!!"
