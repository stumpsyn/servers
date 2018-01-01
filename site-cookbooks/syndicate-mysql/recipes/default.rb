remote_file "/tmp/mysql-apt-config_0.8.9-1_all.deb" do
  source "https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb"
  mode 0644
  checksum "89f4298803f44b903e47897a0edfe9716d88b27c5f5d0f7e6b2867bf45b91a98"
end

dpkg_package "mysql-apt-config" do
  source "/tmp/mysql-apt-config_0.8.9-1_all.deb"
  action :install
end

apt_update

mysql_service 'default' do
  port '3306'
  version '5.7'
  package_name 'mysql-community-server'
  socket node['mysql']['socket']
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
  notifies :update, 'apt_update', :before
end

mysql_client 'default' do
  action :create
  version '5.7'
  package_name 'mysql-community-client'
end

package 'libmysqlclient-dev' do
  action :install
end

gem_package 'mysql2' do
  gem_binary RbConfig::CONFIG['bindir'] + '/gem'
  version '0.4.10'
  action :install
end
