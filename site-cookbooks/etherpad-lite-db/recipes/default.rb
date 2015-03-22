postgres_connection_info = {
  :host     => '127.0.0.1',
  :username => 'postgres',
  :password => node['postgresql']['password']['password']
}

postgresql_database_user 'etherpad' do
  connection postgres_connection_info
  action   :create
  createdb true
  login    true
end

postgresql_database 'etherpad' do
  connection postgres_connection_info
  owner 'etherpad'
end

