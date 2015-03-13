postgresql_database_user 'etherpad' do
  action   :create
  createdb true
  login    true
end

postgresql_database 'etherpad' do
  owner 'etherpad'
end

