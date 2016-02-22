#!/bin/bash

# Run this script on a new instance of the ePDX server, with the old IP as an argument.
# It will transfer the database and rsync relevant data to the new machine.

host=$1

dirs_to_copy=(
  /var/www/epdx/shared/public/system/
  ~/db_backups_for_transfer/
)

backup_timestamp=`date +%Y-%m-%d_%H:%M:%S`

backup_scripts="
  mkdir -p ~/db_backups_for_transfer;

  echo '---';
  echo 'Dumping ePDX database';
  echo 'Showing password from database.yml';
  grep password /var/www/epdx/shared/config/database.yml;
  mysqldump -uepdx -p epdx_production | gzip > ~/db_backups_for_transfer/epdx_${backup_timestamp}.sql.gz;
"
ssh ${host} ${backup_scripts}

for dir in "${dirs_to_copy[@]}";
do
  sudo rsync -vhxaz reidab@${host}:${dir} ${dir};
done

echo '---'
echo 'Loading ePDX database'
echo 'Showing password from database.yml'
grep password /var/www/epdx/shared/config/database.yml
gunzip < ~/db_backups_for_transfer/epdx_${backup_timestamp}.sql.gz | mysql -uepdx -p -S /var/run/mysql-default/mysqld.sock epdx_production


echo '---'
echo "Rebuilding search index…"

loadpath="/var/www/epdx/shared/ruby/bin:/var/www/epdx/shared/bin:$PATH"
prefix="sudo -u epdx PATH=${loadpath} RAILS_ENV=production"

cd /var/www/epdx/current
${prefix} /var/www/epdx/shared/ruby/bin/bundle exec rake ts:rebuild
