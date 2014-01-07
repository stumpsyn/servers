name = node['server-banner']['domain'] || node['set_fqdn'] || node.name

include_recipe "server-banner::default"

template "/etc/nginx/sites-available/server-banner" do
  source "nginx_banner_conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    name: name
  )
  notifies :reload, "service[nginx]"
end

nginx_site "server-banner"
