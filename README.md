# Stumptown Syndicate Servers

[Chef](http://www.opscode.com/chef/) cookbooks and configuration for servers run by [Stumptown Syndicate](http://stumptownsyndicate.org).

## Local Development & Testing

We use [Vagrant](http://vagrantup.com) for bootstrapping basic server VMs locally for testing. We do not, however, use its chef solo integration, opting instead to keep the deployment process consistent between development and production.

You can easily download the Ubuntu 12.04 base box and build an initial VM with `vagrant up`. Once this is finished running, you can stop the VM with `vagrant halt` (or `vagrant suspend`), or wipe the slate clean with `vagrant destroy`.
    
You'll then want to dump vagrant's SSH config to a file, so you can reference it when provisioning later on. You should only need to update this file when adding new VMs to the Vagrantfile.

    $ vagrant ssh-config > vagrant_ssh_config

