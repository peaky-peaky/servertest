#!/bin/bash

cat ~/openstackope/roles/novauser/tasks/nova-result | grep nova-conductor

if [ $? -ne 0 ]; then
  su -s /bin/bash placement -c "placement-manage db sync"
  su -s /bin/bash nova -c "nova-manage api_db sync"
  su -s /bin/bash nova -c "nova-manage cell_v2 map_cell0"
  su -s /bin/bash nova -c "nova-manage db sync"
  su -s /bin/bash nova -c "nova-manage cell_v2 create_cell --name cell1"
fi


