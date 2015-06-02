default['syndicate-wordpress']['version'] = "4.2.2"
default['syndicate-wordpress']['install-path'] = "/var/www/wordpress/"

default['syndicate-wordpress']['multisite'] = true
default['syndicate-wordpress']['multisite_primary_domain'] = "stumptownsyndicate.org"

default['syndicate-wordpress']['db']['name'] = 'syndicate_wordpress'
default['syndicate-wordpress']['db']['user'] = 'wordpress'

default['syndicate-wordpress']['sites'] = []
default['syndicate-wordpress']['plugins'] = []

# These attributes should all be set via secrets
default['syndicate-wordpress']['db']['password'] = nil
default['syndicate-wordpress']['auth_key'] = nil
default['syndicate-wordpress']['secure_auth_key'] = nil
default['syndicate-wordpress']['logged_in_key'] = nil
default['syndicate-wordpress']['nonce_key'] = nil
default['syndicate-wordpress']['auth_salt'] = nil
default['syndicate-wordpress']['secure_auth_salt'] = nil
default['syndicate-wordpress']['logged_in_salt'] = nil
default['syndicate-wordpress']['nonce_salt'] = nil
