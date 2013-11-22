name "znc_server"
run_list(
  "recipe[znc]",
  "recipe[znc::module_colloquy]",
  # "recipe[znc::logs2html]",
  "recipe[znc_nginx_conf]"
)

znc_port = "7777"

default_attributes(
  platform_packages: {
    pkgs: [
      {name: "python3-dev"}
    ]
  },
  znc: {
    install_method: "source",
    url: "http://znc.in/nightly",
    version: "latest",
    configure_options: ["--enable-python"],
    init_style: "upstart",
    port: "+#{znc_port}",
    modules: [
      "webadmin",
      "adminlog",
      "fail2ban"
    ],
    extra_conf: %q{
      // Set up a web-only non-SSL listener for nginx to proxy
      <Listener listener1>
        AllowIRC = false
        AllowWeb = true
        IPv4 = true
        IPv6 = true
        Port = 7780
        SSL = false
      </Listener>
    }
  },
  znc_nginx_conf: {
    server_name: "znc.stumptownsyndicate.org",
    port: 7780
  },
  firewall: {
    rules: [
      {"znc" => {
          "port" => znc_port
        }
      }
    ]
  }
)
