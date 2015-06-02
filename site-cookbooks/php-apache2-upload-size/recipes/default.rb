file "/etc/php5/apache2/conf.d/upload_max_filesize.ini" do
    owner "root"
    group "root"
    mode "0755"
    action :create
    content [
      "upload_max_filesize = #{node['php_apache2_upload_size']['upload_max_filesize']}",
      "post_max_size = #{node['php_apache2_upload_size']['post_max_size']}"
    ].join("\n")
    notifies :reload, resources(:service => "apache2")
end

