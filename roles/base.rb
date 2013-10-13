name "base"
run_list %W(
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
)

override_attributes(
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
  }
)
