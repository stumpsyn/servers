wordpress_path = node['civicrm-wordpress']['wordpress-path']
plugins_path = File.join(wordpress_path, 'wp-content', 'plugins')
install_path = File.join(plugins_path, 'civicrm')

ark "civicrm" do
  action :put
  path plugins_path
  url node['civicrm-wordpress']['url']
  checksum node['civicrm-wordpress']['checksum']
  owner "wordpress"
end

bash "set ownership and permissions" do
  code <<-BASH
    chown -R wordpress:www-data #{install_path}
    find #{install_path} -type d -exec chmod 775 {} \\;
    find #{install_path} -type f -exec chmod 664 {} \\;
  BASH
end

directory File.join(plugins_path, 'files') do
  owner "wordpress"
  group "www-data"
  mode 0775
end

raise "Must set node['civicrm-wordpress']['db']['password'] via secrets" unless node['civicrm-wordpress']['db']['password']

# Set up the database
mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database_user node['civicrm-wordpress']['db']['user'] do
  connection mysql_connection_info
  password node['civicrm-wordpress']['db']['password']
end

mysql_database node['civicrm-wordpress']['db']['name'] do
  connection mysql_connection_info
  owner node['civicrm-wordpress']['db']['user']
end

mysql_database_user node['civicrm-wordpress']['db']['user'] do
  connection mysql_connection_info
  action :grant
  privileges [:all]
  database_name node['civicrm-wordpress']['db']['name']
end
