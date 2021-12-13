#!/bin/bash

projectID=$(openstack project list | grep service | awk '{print $2}')

openstack subnet create subnet2 --network sharednet1 --project $projectID --subnet-range 10.0.2.0/24 --allocation-pool start=10.0.2.2,end=10.0.2.254 --dns-nameserver 8.8.8.8
