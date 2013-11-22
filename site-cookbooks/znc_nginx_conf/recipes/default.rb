template "/etc/nginx/sites-available/znc_webadmin" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    server_name: node['znc_nginx_conf']['server_name'],
    internal_port: node['znc_nginx_conf']['port'] || node['znc']['port'].gsub('+','')
  )
  notifies :reload, "service[nginx]"
end

nginx_site "znc_webadmin"
