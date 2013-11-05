name "calagator"
run_list %W(
  role[web]
  recipe[sqlite]
  recipe[ruby_install]
  recipe[calagator]
)

override_attributes(
  ruby_install: { 
    version: "0.3.1",
  }
)

