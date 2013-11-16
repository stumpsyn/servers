#
# Cookbook Name:: calagator
# Recipe:: default
#

include_recipe "user"

# Load configuration and set defaults
calagator = node['calagator']

ruby_path = "/opt/rubies/#{calagator['ruby_version'].gsub(' ', '-')}"
app_name = calagator['app_name']
user_name = calagator['user'] || app_name
deploy_path = calagator['deploy_path'] || "/var/www/#{calagator['app_name']}"
shared_path = File.join(deploy_path, 'shared')
user_home = calagator['user_home'] || deploy_path

# Install the desired ruby version
ruby_install_ruby calagator["ruby_version"] do
  prefix_path ruby_path
end

# Install bundler
gem_package "bundler" do
  gem_binary "#{ruby_path}/bin/gem"
end

# Create the user
user_account user_name do
  home user_home
  ssh_keys calagator['ssh_keys']
end

# Ensure the shared path and log dir exist
directory File.join(shared_path, "log") do
  owner user_name
  mode "0775"
  recursive true
end

# Link the installed ruby into the shared path
link File.join(shared_path, "ruby") do
  owner user_name
  to ruby_path
end

# Add the installed ruby to the user's PATH
file File.join(user_home, ".bashrc") do
  owner user_name
  mode "0644"
  content [
    File.read("/etc/skel/.bashrc"),
    "export PATH=#{shared_path}/ruby/bin:#{shared_path}/bin:$PATH:/sbin"
  ].join("\n")
end

# Generate nginx config
template "/etc/nginx/sites-available/#{app_name}.conf" do
  source "nginx_site.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    app_name: app_name,
    deploy_path: deploy_path,
    shared_path: shared_path
  )
  notifies :reload, "service[nginx]"
end

nginx_site "#{app_name}.conf"

service_name = "#{app_name}_puma"

# Generate upstart script to run the app
template "/etc/init/#{service_name}.conf" do
  source "upstart_puma.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    app_name: app_name,
    deploy_path: deploy_path,
    shared_path: shared_path,
    user: user_name
  )
end

# Let the user sudo to control the service
sudo user_name do
  user user_name
  runas 'root'
  nopasswd true
  commands [
    "/sbin/start #{service_name}",
    "/sbin/stop #{service_name}",
    "/sbin/restart #{service_name}",
    "/sbin/reload #{service_name}"
  ]
end

