#
# Cookbook Name:: calagator
# Recipe:: default
#

include_recipe "user"
include_recipe "ruby_install"

calagator = node['calagator']

ruby_path = "/opt/rubies/#{calagator['ruby_version'].gsub(' ', '-')}"
user_name = calagator['user'] || calagator['app_name']
deploy_path = calagator['deploy_path'] || "/var/www/#{calagator['app_name']}"
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
end

# Add the installed ruby to the user's PATH
file File.join(user_home, ".bashrc") do
  owner user_name
  mode "0644"
  content [
    File.read("/etc/skel/.bashrc"),
    "export PATH=#{ruby_path}/bin:$PATH"
  ].join("\n")
end

