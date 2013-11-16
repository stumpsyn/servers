name "calagator"
run_list %W(
  role[web]
  recipe[ruby_install]
  recipe[xml]
  recipe[sqlite]
  recipe[sqlite-dev]
  recipe[puma_app]
)

override_attributes(
  ruby_install: { 
    version: "0.3.1",
  },
  puma_app: {
    apps: [
      'calagator'
    ]
  }
)

