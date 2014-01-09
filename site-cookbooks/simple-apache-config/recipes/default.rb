node['simple-apache-config']['sites'].each do |site|
  document_root = site['document_root'] || File.join('/','var', 'www', site['server_name'])

  directory document_root do
    group "admin"
    recursive true
  end

  template File.join('/','etc', 'apache2', 'sites-available', site['server_name']) do
    source "simple-apache-config.erb"
    variables(
      site: site,
      document_root: document_root
    )
    notifies :reload, "service[apache2]"
  end

  apache_site site['server_name']
end
