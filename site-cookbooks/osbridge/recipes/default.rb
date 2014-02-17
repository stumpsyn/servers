#
# Cookbook Name:: osbridge
# Recipe:: default
#
# Copyright 2014, Stumptown Syndicate
#
# All rights reserved
#

# Disable the osbridge-ocw nginx configuration written by the puma_app cookbook
nginx_site "osbridge-ocw.conf" do
  enable false
end

# Write a replacement config file, supporting OCW, WordPress, Mediawiki, and static assets
template "/etc/nginx/sites-available/osbridge.conf" do
  source "osbridge_nginx.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :reload, "service[nginx]"
end

nginx_site "osbridge.conf"
