#!/bin/bash

# Run this script on a new instance of the Calagator server, with the old IP as an argument.
# 
# It will transfer the database, insert missing migration records, and reindex.
# It assumes a copy of Calagator has already been deployed to /var/www/calagator/current.

host=$1

dirs_to_copy=(
  /var/www/calagator/shared/db/
)

loadpath="/var/www/calagator/shared/ruby/bin:/var/www/calagator/shared/bin:$PATH"
prefix="sudo -u calagator PATH=${loadpath} RAILS_ENV=production"

sudo stop calagator

for dir in "${dirs_to_copy[@]}";
do
  sudo rsync -vhxaz reidab@${host}:${dir} ${dir};
done

cd /var/www/calagator/current
${prefix} bin/rails runner 'ActiveRecord::Base.connection.assume_migrated_upto_version("20150604010248")'
${prefix} bin/rake sunspot:reindex:calagator
echo "Updating counter caches…"
${prefix} bin/rake update_counter_caches

sudo start calagator
