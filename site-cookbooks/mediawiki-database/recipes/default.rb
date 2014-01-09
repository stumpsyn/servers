# Sets up the database for MediaWiki
mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database_user node['mediawiki-database']['user'] do
  connection mysql_connection_info
  password node['mediawiki-database']['password']
end

mysql_database node['mediawiki-database']['name'] do
  connection mysql_connection_info
  owner node['mediawiki-database']['user']
end

mysql_database_user node['mediawiki-database']['user'] do
  connection mysql_connection_info
  action :grant
  privileges [:all]
  database_name node['mediawiki-database']['name']
end
