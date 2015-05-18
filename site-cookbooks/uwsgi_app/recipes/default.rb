#
# Cookbook Name:: uwsgi_app
# Recipe:: default
#

include_recipe "user"

# Load configuration and set defaults
base_config = node['uwsgi_app']
apps = base_config['apps']

apps.each do |app_to_load|
  app = data_bag_item(base_config['data_bag'], app_to_load)

  unless app
    log "Could not find data bag for app '#{app_to_load}'" do
      level :warn
    end
    next
  end

  app_name = app['id']
  domains = app['domains'] || []
  domains << "#{app_name}.local"

  deploy_path = app['deploy_path'] || "/var/www/#{app_name}"
  shared_path = File.join(deploy_path, 'shared')
  current_path = File.join(deploy_path, 'current')
  venv_path = File.join(shared_path, 'venv')
  app_subdir = app['app_subdir']

  user_name = app['user'] || app_name
  user_home = app['user_home'] || deploy_path
  uwsgi_module = app['wsgi_module'] || "wsgi.py"

  django_settings_module = app['django_settings_module'] || "#{app_name}.settings"
  uwsgi_threads = app['threads'] || [0, 16]
  uwsgi_workers = app['workers'] || 5
  uwsgi_socket = app['socket'] || "#{shared_path}/tmp/sockets/uwsgi.sock"

  uwsgi_config_path = app['config_path'] || File.join(shared_path, 'config', 'uwsgi_config.ini')
  uwsgi_params_path = app['uwsgi_params_path'] || File.join(shared_path, 'config', 'uwsgi_params')

  template_context = {
    app_name: app_name,
    domains: domains,
    deploy_path: deploy_path,
    shared_path: shared_path,
    current_path: current_path,
    app_dir: File.join(current_path, app_subdir),
    venv_path: venv_path,
    user: user_name,
    django_settings_module: django_settings_module,
    uwsgi_threads: uwsgi_threads,
    uwsgi_workers: uwsgi_workers,
    uwsgi_socket: uwsgi_socket,
    uwsgi_module: uwsgi_module,
    uwsgi_config_path: uwsgi_config_path,
    uwsgi_params_path: uwsgi_params_path
  }

  # Create the user
  user_account user_name do
    home user_home
    ssh_keys app['ssh_keys']
  end

  # Ensure the shared path, config, pids, and log dirs exist
  %w(shared shared/log shared/config shared/tmp shared/tmp/pids shared/tmp/sockets).each do |subdir|
    directory File.join(deploy_path, subdir) do
      owner user_name
      mode "0775"
      recursive true
    end
  end

  python_virtualenv venv_path do
    owner user_name
    group 'admin'
    action :create
  end

  python_pip "uwsgi"

  # Generate the uwsgi config
  template uwsgi_config_path do
    source "uwsgi_config.ini.erb"
    owner user_name
    mode "0644"
    variables template_context
  end

  template uwsgi_params_path do
    source "uwsgi_params"
    owner user_name
    mode "0644"
  end

  # Generate nginx config
  template "/etc/nginx/sites-available/#{app_name}.conf" do
    source "nginx_site.conf.erb"
    mode 0644
    owner "root"
    group "root"
    variables template_context
    notifies :reload, "service[nginx]"
  end

  nginx_site "#{app_name}.conf"

  service_name = 'uwsgi'

  vassals_path = File.join('etc', service_name, 'vassals')

  directory vassals_path do
    owner 'root'
    mode "0755"
    recursive true
  end

  link File.join(vassals_path, "#{app_name}.ini") do
    to uwsgi_config_path
  end

  # Generate upstart script to run the app
  template "/etc/init/#{service_name}.conf" do
    source "upstart_uwsgi.conf.erb"
    mode 0644
    owner "root"
    group "root"
    variables template_context
  end

  service service_name do
    action :start
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
end
