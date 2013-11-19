cookbook_path ["cookbooks", "site-cookbooks"]
node_path     "nodes"
role_path     "roles"
data_bag_path "data_bags"
encrypted_data_bag_secret "secret_key"

knife[:berkshelf_path] = "cookbooks"
