# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "dc" do |dc|
    dc.vm.box = "ubuntu/trusty64"
    
    dc.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    
    dc.vm.provision "shell", path: "configure-dc.sh"
    
    dc.vm.network "private_network", ip: "192.168.50.4", virtualbox__intnet: "active_directory_network"
  end

  config.vm.define "client" do |client|
    client.vm.box = "ferhaty/win7ie10winrm"
    
    client.vm.guest = :windows
    
    client.vm.communicator = "winrm"
    client.winrm.username = "IEUser"
    client.winrm.password = "Passw0rd!"

    client.vm.provider "virtualbox" do |v|
      v.gui = true
    end
    
    client.vm.network "private_network", ip: "192.168.50.5", virtualbox__intnet: "active_directory_network"
    
    client.vm.provision "shell", path: "configure-dns.bat"
    client.vm.provision "shell", path: "join-domain.ps1"
  end

end
