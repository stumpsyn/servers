name "web"
run_list %W(
  role[base]
  recipe[nginx::repo]
  recipe[nginx]
)

override_attributes(
  :nginx => {
    :version => "1.5.6"
  },
  :firewall => {
    :rules => [
      {"http" => {
          "port" => "80"
        }
      },
      {"https" => {
          "port" => "443"
        }
      }
    ]
  }
)
