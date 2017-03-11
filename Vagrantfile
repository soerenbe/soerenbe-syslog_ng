# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |vbox|
    vbox.memory = 512
    vbox.cpus = 1
    # USB 2.0 is enabled by default in virtualbox. Since most people dont't need ist and it causes a failure in the ARTACK/debian-jessie box,
    # we simply disable it.
    vbox.customize ["modifyvm", :id, "--usb", "off"]
    vbox.customize ["modifyvm", :id, "--usbehci", "off"]
  end
  # Workaround to skip nasty tty errors during provisioning
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"  

  config.vm.define "default" do |default|
    default.vm.provision "shell", path: "vagrant/init.sh"
    default.vm.synced_folder("vagrant/hiera", "/etc/puppet/hiera")
    
    default.vm.provision :puppet do |puppet|
      puppet.manifests_path = "vagrant/manifests"
      puppet.manifest_file = "site.pp"
      puppet.hiera_config_path = "vagrant/hiera/hiera.yaml"
      puppet.working_directory = "/etc/puppet/hiera"
      puppet.options = "--verbose"
      puppet.facter = {
        "fqdn"     => "default.vagrant.up",
        "vagrant"  => 1,
        "virtual"  => "virtualbox"
      }
    end # puppet
  end # config
end #vagrant
