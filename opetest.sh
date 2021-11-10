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
