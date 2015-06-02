# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.4.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.box = "ubuntu-14.04-server"

  config.vm.define "lucca.local" do |web|
    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    web.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh"
    web.vm.network :forwarded_port, guest: 80, host: 8001
    web.vm.network :forwarded_port, guest: 443, host: 4431
    web.vm.network :forwarded_port, guest: 8983, host: 8983

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    web.vm.network :private_network, ip: "192.168.66.10"
  end

  config.vm.define "bunsen.local" do |web|
    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    web.vm.network :forwarded_port, guest: 22, host: 2200, id: "ssh"
    web.vm.network :forwarded_port, guest: 80, host: 8002
    web.vm.network :forwarded_port, guest: 443, host: 4432
    web.vm.network :forwarded_port, guest: 7777, host: 7777
    web.vm.network :forwarded_port, guest: 6667, host: 6667
    web.vm.network :forwarded_port, guest: 6697, host: 6697

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    web.vm.network :private_network, ip: "192.168.66.11"
  end

  config.vm.define "beaker.local" do |web|
    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    web.vm.network :forwarded_port, guest: 22, host: 2201, id: "ssh"
    web.vm.network :forwarded_port, guest: 80, host: 8003
    web.vm.network :forwarded_port, guest: 443, host: 4433

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    web.vm.network :private_network, ip: "192.168.66.12"
  end

  config.vm.define "arroway.local" do |web|
    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    web.vm.network :forwarded_port, guest: 22, host: 2202, id: "ssh"
    web.vm.network :forwarded_port, guest: 80, host: 8004
    web.vm.network :forwarded_port, guest: 443, host: 4434

    web.vm.network :forwarded_port, guest: 5500, host: 5500

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    web.vm.network :private_network, ip: "192.168.66.13"
  end

  config.vm.define "banzai.local" do |web|
    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    web.vm.network :forwarded_port, guest: 22, host: 2203, id: "ssh"
    web.vm.network :forwarded_port, guest: 80, host: 8005
    web.vm.network :forwarded_port, guest: 443, host: 4435

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    web.vm.network :private_network, ip: "192.168.66.14"
  end

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    #vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    # vb.customize ["modifyvm", :id, "--memory", "1024"]

    vb.memory = 2048
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file base.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #
  # config.vm.provision :puppet do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
