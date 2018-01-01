name = node['server-banner']['domain'] || node['set_fqdn'] || node.name

directory "/var/www/server-banner" do
  recursive true
  owner 'www-data'
  group 'admin'
  mode '0755'
end

image = node['server-banner']['image']
if image
  cookbook_file "/var/www/server-banner/#{image}" do
    source image
    owner 'www-data'
    group 'admin'
    mode '0755'
  end
end

template "/var/www/server-banner/index.html" do
  source "index.html.erb"
  owner 'www-data'
  group 'admin'
  mode '0755'
  variables(
    server_name: name,
    background_color: node['server-banner']['background_color'],
    text_color: node['server-banner']['text_color'],
    link: node['server-banner']['link'],
    image: node['server-banner']['image']
  )
end

