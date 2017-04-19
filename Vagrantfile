# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "Windows_10_Enterprise_v1607"
  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "4096"
    v.vmx["numvcpus"] = "4"
  end

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "shell", path: "scripts/ConfigureRemotingForAnsible.ps1"
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.verbose = true
    ansible.extra_vars = {
      activation_key: ENV['ACTIVATION_KEY'],
      vs_activation_key: ENV['VS_ACTIVATION_KEY']
    }
  end

end
