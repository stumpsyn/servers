name "calagator"
run_list %W(
  role[web]
  recipe[ruby_install]
  recipe[xml]
  recipe[sqlite]
  recipe[puma_app]
  recipe[hipsnip-solr]
  recipe[solr-cores]
  recipe[solr-cores::sunspot_schema]
)

override_attributes(
  platform_packages: {
    pkgs: [
      {name: "libsqlite3-dev"}
    ]
  },
  ruby_install: { 
    version: "0.3.1",
  },
  puma_app: {
    apps: [
      'calagator'
    ]
  },
  java: {
    jdk_version: 7
  },
  solr: {
    version: '4.5.1',
    checksum: '8726fa10c6b92aa1d2235768092ee2d4cd486eea1738695f91b33c3fd8bc4bd7',
    cores: %w(calagator_production)
  },
  jetty: {
    port: 8983,
    version: '9.0.7.v20131107',
    link: 'http://eclipse.org/downloads/download.php?file=/jetty/9.0.7.v20131107/dist/jetty-distribution-9.0.7.v20131107.tar.gz&r=1',
    checksum: '6140d4c08bc52583cb55aba4344f328172328709f05552a669176e5659ca36c8'
  }
)

