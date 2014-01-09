name = node['server-banner']['domain'] || node['set_fqdn'] || node.name

include_recipe "server-banner::default"

template "/etc/apache2/sites-available/00-server-banner" do
  source "apache_banner_conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    name: name
  )
  notifies :reload, "service[apache2]"
end

apache_site "00-server-banner"

