mysql_connection_info = {
  :username => 'root',
  :password => node['mysql']['server_root_password'],
  :socket => node['mysql']['socket']
}

node['simple-mysql-database']['databases'].each do |db_to_load|
  db = Chef::EncryptedDataBagItem.load('simple-mysql-database', db_to_load).to_hash

  unless db
    log "Could not find data bag for database '#{db_to_load}'" do
      level :warn
    end
    next
  end

  mysql_database_user db['user'] do
    connection mysql_connection_info
    password db['password']
  end

  mysql_database db['name'] do
    connection mysql_connection_info
    owner db['user']
  end

  mysql_database_user db['user'] do
    connection mysql_connection_info
    action :grant
    privileges [:all]
    database_name db['name']
  end
end
