name "base"
run_list %W(
  recipe[apt]
  recipe[postfix]
  recipe[openssh]
  recipe[ntp]
  recipe[vim]
  recipe[zsh]
  recipe[rsync]
)

override_attributes(
  'openssh' => {
    'permit_root_login' => 'no',
    'password_authentication' => 'no'
  }
)
