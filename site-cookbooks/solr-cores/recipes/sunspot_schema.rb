#
# Cookbook Name:: solr-cores
# Recipe:: sunspot_schema
#

# Expects solr to have been installed using the hipsnip-solr cookbook, 
# and depends on attributes set by that recipe.
include_recipe "solr-cores::default"

node['solr']['cores'].each do |core|
  template File.join(node['solr']['home'],core,'conf','schema.xml') do
    owner node['jetty']['user']
    group node['jetty']['group']
    mode 0644
    source "sunspot_schema.xml.erb"
    notifies :restart, "service[jetty]"
  end
end

