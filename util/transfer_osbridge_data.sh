#!/bin/bash

# Run this script on a new instance of the OSB server, with the old IP as an argument.
# It will transfer databases and rsync relevant data to the new machine.

host=$1

dirs_to_copy=(
  /var/www/osbridge-ocw/shared/public/system/
  /var/www/badges/
  /var/www/common_assets/
  /var/www/mediawiki/
  /var/www/wordpress/
  ~/db_backups_for_transfer/
)

backup_timestamp=`date +%Y-%m-%d_%H:%M:%S`

backup_scripts="
  mkdir -p ~/db_backups_for_transfer;

  echo '---';
  echo 'Dumping OCW database';
  echo 'Showing password from database.yml';
  grep password /var/www/osbridge-ocw/shared/config/database.yml;
  mysqldump -uosbridge_ocw -p osbridge_ocw | gzip > ~/db_backups_for_transfer/ocw_${backup_timestamp}.sql.gz;

  echo '---';
  echo 'Dumping WordPress database';
  echo 'Showing password from wp-config.php';
  grep DB_PASSWORD /var/www/wordpress/wp-config.php;
  mysqldump -uwordpress -p osbridge_wordpress | gzip > ~/db_backups_for_transfer/wordpress_${backup_timestamp}.sql.gz;

  echo '---';
  echo 'Dumping MediaWiki database';
  echo 'Showing password from LocalSettings.php';
  grep wgDBpassword /var/www/mediawiki/LocalSettings.php;
  mysqldump -umediawiki -p mediawiki | gzip > ~/db_backups_for_transfer/mediawiki_${backup_timestamp}.sql.gz;
"

ssh ${host} ${backup_scripts}

for dir in "${dirs_to_copy[@]}";
do
  sudo rsync -vhxaz --exclude=wp-config.php reidab@${host}:${dir} ${dir};
done

echo '---'
echo 'Loading OCW database'
echo 'Showing password from database.yml'
grep password /var/www/osbridge-ocw/shared/config/database.yml
gunzip < ~/db_backups_for_transfer/ocw_${backup_timestamp}.sql.gz | mysql -uosbridge_ocw -p -S /var/run/mysql-default/mysqld.sock osbridge_ocw

echo '---'
echo 'Loading WordPress database'
echo 'Showing password from wp-config.php'
grep DB_PASSWORD /var/www/wordpress/wp-config.php
gunzip < ~/db_backups_for_transfer/wordpress_${backup_timestamp}.sql.gz | mysql -uwordpress -p -S /var/run/mysql-default/mysqld.sock osbridge_wordpress

echo '---'
echo 'Loading MediaWiki database'
echo 'Showing password from LocalSettings.php'
grep wgDBpassword /var/www/mediawiki/LocalSettings.php
gunzip < ~/db_backups_for_transfer/mediawiki_${backup_timestamp}.sql.gz | mysql -umediawiki -p -S /var/run/mysql-default/mysqld.sock mediawiki
