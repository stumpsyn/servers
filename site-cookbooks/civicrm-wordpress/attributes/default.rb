default['civicrm-wordpress']['wordpress-path'] = "/var/www/wordpress"
default['civicrm-wordpress']['url'] = "http://softlayer-dal.dl.sourceforge.net/project/civicrm/civicrm-stable/4.4.3/civicrm-4.4.3-wordpress.zip"
default['civicrm-wordpress']['checksum'] = "b225bb75eecd554d18e63f26cc044e48ebc89472b33373f4fdb7afff35e6d8aa"

default['civicrm-wordpress']['db']['name'] = 'civicrm'
default['civicrm-wordpress']['db']['user'] = 'civicrm'

# The following attributes should be set via secrets
default['civicrm-wordpress']['db']['password'] = nil
