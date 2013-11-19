# Stumptown Syndicate Servers

[Chef](http://www.opscode.com/chef/) cookbooks and configuration for servers run by [Stumptown Syndicate](http://stumptownsyndicate.org). For more information about these servers, consult the [Server Notes](http://stumptownsyndicate.org/wiki/Tech/Server_Notes) on the wiki.

## Getting Started

Dependencies for this code are managed using [Bundler](http://bundler.io/) and [librarian-chef](https://github.com/applicationsonline/librarian-chef). You can grab the code and install the dependencies with:

    $ git clone git@github.com:stumpsyn/servers.git syndicate-servers
    $ cd syndicate-servers
    $ bundle install
    $ librarian-chef install

You'll also probably need a secret key to encrypt data bags. If you're working on the Syndicate servers, ask [Reid](reid@stumptownsyndicate.org) for this. If you're using this code to set up your own servers, you can generate a key by running:

    $ openssl rand -base64 512 > secret_key

## Local Development & Testing

We use [Vagrant](http://vagrantup.com) for bootstrapping basic server VMs locally for testing. We do not, however, use its chef solo integration, opting instead to keep the deployment process consistent between development and production.

You can easily download the Ubuntu 12.04 base box and build an initial VM with `vagrant up`. Once this is finished running, you can stop the VM with `vagrant halt` (or `vagrant suspend`), or wipe the slate clean with `vagrant destroy`.
    
You'll then want to dump vagrant's SSH config to a file, so you can reference it when provisioning later on. You should only need to update this file when adding new VMs to the Vagrantfile.

    $ vagrant ssh-config lucca.local > vagrant_ssh_config
    $ vagrant ssh-config bunsen.local >> vagrant_ssh_config

You can then install chef on the VM using:

    $ knife solo prepare lucca.local -F vagrant_ssh_config

and apply the configuration with:

    $ knife solo cook lucca.local -F vagrant_ssh_config

or combine the previous two commands with:

    $ knife solo bootstrap lucca.local -F vagrant_ssh_config

## Configuring Actual Servers

If you have sufficient access to the target server, you can apply the configuration using:

    $ knife solo cook lucca.stumptownsyndicate.org

## Secrets

There is infrastructure in place to manage secrets using encrypted data bags. In order to use this, you'll need to acquire the `secret_key` from someone who has it and put it in the same directory as this README.

If, for example, you wanted to set a widget's password attribute:

    {
      widget: {
        color: "orange",
        password: "foo" <-- Shh! Secret!
      }
    }


You could create an encrypted `widget` item in the `secrets` databag, like so:

    $ knife solo data bag create secrets widget

This will launch an editor where you can add your password:

    {
      "id": "widget",
      "password": "foo"
    }

When you're done editing, the data bag's attributes will be ecrypted with aes-265-cbc using the secret_key.

You can then edit the bag using:

    $ knife solo data bag edit secrets widget

In order to add these secrets to the node's attributes, you can add the `secrets` recipe to the node's run list, and list the secret bags that should be loaded in the node's `secrets` attribute.

	{
	  "run_list": [
	    "recipe[secrets]",
	    "recipe[widgets]",
	  ],
	  "secrets": ["widget"],
	  "widget": {
	    "color": "orange",
	  }
	}

At runtime, the contents of the encrypted data bag (minus its ID attribute) will be merged with the existing "widget" attribute.