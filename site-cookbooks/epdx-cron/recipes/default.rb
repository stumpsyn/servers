def rake_env(command)
  shared_path = "/var/www/epdx/shared"
  env_path = "#{shared_path}/ruby/bin:#{shared_path}/bin:$PATH:/usr/local/bin:/usr/bin"

  "cd /var/www/epdx/current && /bin/bash -l -c 'PATH=#{env_path} RAILS_ENV=production bundle exec #{command}'"
end

calagator_task = rake_env("rake calagator:update_count >/dev/null 2>&1")
sphinx_task = rake_env("rake thinking_sphinx:index >> /var/www/sites/epdx.org/current/log/cron-thinking_sphinx-index.log 2>&1")

cron "ePDX Calagator Count Update" do
  command calagator_task
  minute "*/5"
  user "epdx"
  mailto "root@stumptownsyndicate.org"
end

cron "ePDX Sphinx Indexing" do
  command sphinx_task
  minute "9"
  hour "2"
  user "epdx"
  mailto "root@stumptownsyndicate.org"
end
