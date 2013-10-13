name "base"
run_list %W(
  recipe[chef-solo-search]
  recipe[user::data_bag]
  recipe[apt]
  recipe[postfix]
  recipe[openssh]
  recipe[ntp]
  recipe[vim]
  recipe[zsh]
  recipe[rsync]
  recipe[htop]
  recipe[logrotate]
  recipe[fail2ban]
  recipe[sudo]
  recipe[unattended-upgrades]
  recipe[ufw]
  recipe[shm_noexec]
  recipe[sysctl]
)

default_attributes(
  :users => ["reidab"],
  :openssh => {
    :permit_root_login => 'no',
    :password_authentication => 'no'
  },
  :authorization => {
    :sudo => {
      :groups => %w(admin),
      :passwordless => true,
      :agent_forwarding => true,
      :include_sudoers_d => true
    }
  },
  :firewall => {
    :rules => [
    ]
  },
  :sysctl => {
    :params => {
      :net => {
        :ipv4 => {
          :icmp_echo_ignore_broadcasts => 1,
          :icmp_ignore_bogus_error_responses => 1,
          :tcp_syncookies => 1,
          :tcp_max_syn_backlog => 2048,
          :tcp_synack_retries => 2,
          :tcp_syn_retries => 5,
          :conf => {
            :all => {
              :rp_filter => 1,
              :accept_source_route => 0,
              :send_redirects => 0,
              :accept_redirects => 0,
              :log_martians => 1,
            },
            :default => {
              :rp_filter => 1,
              :accept_source_route => 0,
              :send_redirects => 0,
              :accept_redirects => 0,
              :log_martians => 1,
            }
          }
        },
        :ipv6 => {
          :conf => {
            :all => {
              :accept_source_route => 0,
              :accept_redirects => 0,
            },
            :default => {
              :accept_source_route => 0,
              :accept_redirects => 0,
            }
          }
        }
      }
    }
  }
)
