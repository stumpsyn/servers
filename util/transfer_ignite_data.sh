#!/bin/bash

# Run this script on a new instance of the Ignite server, with the old IP as an argument.
# It will transfer the database and rsync relevant data to the new machine.

host=$1

dirs_to_copy=(
  /var/www/ignite-portland-proposals/shared/config/
  /var/www/ignite-portland-proposals/shared/db/
  /var/www/ignite-portland-proposals/shared/public/system/
  /var/www/ignite-corvallis-proposals/shared/config/
  /var/www/ignite-corvallis-proposals/shared/db/
  /var/www/ignite-corvallis-proposals/shared/public/system/
)

for dir in "${dirs_to_copy[@]}";
do
  sudo rsync -vhxaz reidab@${host}:${dir} ${dir};
done

