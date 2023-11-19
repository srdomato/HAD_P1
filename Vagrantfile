# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo wget https://apt.puppet.com/puppet7-release-focal.deb
    sudo dpkg -i puppet7-release-focal.deb
		sudo apt-get update
    sudo apt-get install -y puppetserver puppet-agent
   SHELL
   
   config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"        
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "default.pp"  
  end

end
