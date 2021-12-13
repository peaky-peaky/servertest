#!/bin/bash

projectID=$(openstack project list | grep service | awk '{print $2}')

openstack subnet create subnet1 --network sharednet1 --project $projectID --subnet-range 10.0.1.0/24 --allocation-pool start=10.0.1.2,end=10.0.1.254 --dns-nameserver 8.8.8.8
