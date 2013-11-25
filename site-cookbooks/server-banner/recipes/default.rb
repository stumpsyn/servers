name = node['server-banner']['domain'] || node['set_fqdn'] || node.name

directory "/var/www/server-banner" do
  recursive true
end

image = node['server-banner']['image']
if image
  cookbook_file "/var/www/server-banner/#{image}" do
    source image
  end
end

template "/var/www/server-banner/index.html" do
  source "index.html.erb"
  variables(
    server_name: name,
    background_color: node['server-banner']['background_color'],
    text_color: node['server-banner']['text_color'],
    link: node['server-banner']['link'],
    image: node['server-banner']['image']
  )
end

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

