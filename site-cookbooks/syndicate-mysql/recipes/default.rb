mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'default' do
  port '3306'
  version '5.6'
  socket node['mysql']['socket']
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end
