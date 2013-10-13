name "base"
run_list %W(
  recipe[apt]
  recipe[postfix]
  recipe[openssh]
  recipe[ntp]
  recipe[vim]
)

override_attributes(
  'openssh' => {
    'permit_root_login' => 'no',
    'password_authentication' => 'no'
  }
)
