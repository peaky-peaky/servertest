#!/bin/bash

openstack project create --domain default --description "Hiroshima Project" hiroshima
openstack user create --domain default --project hiroshima --password userpassword serverworld
openstack role create CloudUser
openstack role add --project hiroshima --user serverworld CloudUser
