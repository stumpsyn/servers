mysql_service 'default' do
  port '3306'
  version '5.6'
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end
