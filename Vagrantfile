# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  # Default provider
  config.vm.provider "virtualbox" do |vbox|
    vbox.memory = 512
  end

  # Install additional puppet modul required by syslog_ng
  config.vm.provision :shell do |shell|
  shell.inline = "mkdir -p /etc/puppet/modules;
                  test -e /etc/puppet/modules/concat || puppet module install puppetlabs/concat"
  end

  # machines
  config.vm.define "logserver" do |logserver|
    logserver.vm.network "private_network", ip: "10.0.3.100"
    logserver.vm.provision :puppet do |puppet|
      puppet.module_path = ["puppet/modules"]
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.options = "--verbose"
      puppet.facter = {
        "hostname" => "logserver",
        "vagrant"  => 1
      }
    end
  end

  config.vm.define "logclient_1" do |logclient_1|
    logclient_1.vm.network "private_network", ip: "10.0.3.21"
    logclient_1.vm.provision :puppet do |puppet|
      puppet.module_path = ["puppet/modules"]
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.options = "--verbose"
      puppet.facter = {
        "hostname" => "logclient_1",
        "vagrant"  => 1
      }
    end
  end

  config.vm.define "logclient_2" do |logclient_2|
    logclient_2.vm.network "private_network", ip: "10.0.3.22"
    logclient_2.vm.provision :puppet do |puppet|
      puppet.module_path = ["puppet/modules"]
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.options = "--verbose"
      puppet.facter = {
        "hostname" => "logclient_2",
        "vagrant"  => 1
      }
    end
  end

  config.vm.define "logclient_3" do |logclient_3|
    logclient_3.vm.network "private_network", ip: "10.0.3.23"
    logclient_3.vm.provision :puppet do |puppet|
      puppet.module_path = ["puppet/modules"]
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.options = "--verbose"
      puppet.facter = {
        "hostname" => "logclient_3",
        "vagrant"  => 1
      }
    end
  end

end