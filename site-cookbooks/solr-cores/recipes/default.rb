#
# Cookbook Name:: solr-cores
# Recipe:: default
#

# Expects solr to have been installed using the hipsnip-solr cookbook, 
# and depends on attributes set by that recipe.
include_recipe "hipsnip-solr"

node['solr']['cores'].each do |core|
  ruby_block 'Copy Solr core example configuration' do
    block do
      config_files = File.join(node['solr']['extracted'],'/example/solr/collection1')
      Chef::Log.info "Copying #{config_files} into #{node['solr']['home']}"
      FileUtils.cp_r(config_files, "#{node['solr']['home']}/#{core}")
      FileUtils.chown_R(node['jetty']['user'],node['jetty']['group'],node['solr']['home'])
      raise "Failed to copy Solr core configuration files" unless File.exists?(File.join(node['solr']['home'], 'solr.xml'))
    end

    action :create
    notifies :restart, "service[jetty]"

    not_if do
      File.exists?(File.join(node['solr']['home'], core))
    end
  end

  file File.join(node['solr']['home'], core, 'core.properties') do
    owner node['jetty']['user']
    group node['jetty']['group']
    mode 0644
    content "name=#{core}"
    notifies :restart, "service[jetty]"
  end

  template File.join(node['solr']['home'],core,'conf','solrconfig.xml') do
    owner node['jetty']['user']
    group node['jetty']['group']
    mode 0644
    source "core_solrconfig.xml.erb"
    variables core: core
    notifies :restart, "service[jetty]"
  end
end

# Remove default collection if not included
directory File.join(node['solr']['home'], 'collection1') do
  action :delete
  recursive true
  notifies :restart, "service[jetty]"
  not_if do
    node['solr']['cores'].include?('collection1')
  end
end
