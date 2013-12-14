nginx_site 'default' do
  enable false
end

file '/etc/nginx/conf.d/default.conf' do
  action :delete
end
