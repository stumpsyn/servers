name "base"
run_list %W(
  recipe[apt]
  recipe[postfix]
)
