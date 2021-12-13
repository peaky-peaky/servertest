#!/bin/bash


projectID=$(openstack project list | grep service | awk '{print $2}')

openstack network create --project $projectID \
--share --provider-network-type flat --provider-physical-network physnet1 sharednet1
