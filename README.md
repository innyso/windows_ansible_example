# Packer, Windows, Ansible

This responsitory consist of an example for creating and provisioning a windows machine

1. Create a windows base box using [Packer](https://www.packer.io/intro/)
1. Create a windows virtual machine on vmware_fusion
1. Setup WinRM for the virtual machine for Ansible
1. Using ansible to customise the vitual machine

## Create Windows Base box

### prereq
1. You need to install packer, follow this [link](https://www.packer.io/intro/) for installation instruction
1. You need to have git install
1. This example is build against vmware_fusion but similar script can be use to build for VirtualBox etc
1. This example uses Windows 10 Enterprise as the based iso but you are free to use anything

### steps
1. Clone [this repo](https://github.com/joefitzgerald/packer-windows) to use as a template
1. In answer_files/10/Autounattend.xml, comment out <ProductKey> and update InstallFrom to the following so that it will pick up the first selection from the InstallFrom prompt

```
<MetaData wcm:action="add">
	<Key>/IMAGE/NAME</Key>
	<Value>Windows 10 Enterprise Evaluation</Value>
	<Key>/image/index</Key>
	<Value>1</Value>
</MetaData>
```
1. Follow the instruction to get the md5 and update the path to the iso
1. Follow the instruction to disable windows update if you dont want to wait for 2 hours
1. run `packer build -only=vmware-iso windows_10.json | ts '[%Y-%m-%d %H:%M:%S]'` to start the process of creating the box for vagrant. This process will take 2 hours if enable to windows update step

## Create Windows 10 Virtual Machine using vagrant on vmware_fusion

### prereq
1. You have completed the previous step with the resulting windows_10_vmware.box file
1. You have vagrant installed
1. You have vmware fusion installed
1. You have purchase a copy of the vagrant vmware plugin [here](https://www.vagrantup.com/vmware/)
1. You have install the vagrant-vmware-fusion plugin

### steps
1. Add the vagrant box 
```
vagrant box add --name <your custom name of the box> <path to .box file>
```
1. Navigate to the vagrant folder to find a sample Vagrantfile. This Vagrantfile will create a windows 10 virtual box on vmware_fusion with 4GB of memory and 4 cores.
1. Update the Vagrantfile to use the <your custom box name> for config.vm.box
1. Run `vagrant up --provider vmware_fusion`, this should only take less than 10 minutes. It will fail when it tries to provision it using ansible which we will look at in the next section.
1. Now you should have a windows 10 vm created in vmware_fusion and you should be able to login using vagrant/vagrant

## Provision the windows 10 vagrant box using ansible

### prereq
1. Install ansible locally using `brew install ansible`. You need to be on version 2.2+ in order to use some of the new windows ansible feature.
1. Obtain a copy of the windows 10 license key and export it as an environment var `export ACTIVATION_KEY=XXXX-XXXXXX-XXXX-XXXXX`
1. Obtain a copy of the visual studio enterprise license key and export it as an environment var `export VS_ACTIVATION_KEY=XXXX-XXXXXX-XXXX-XXXXX`

### steps
1. Navigate to the vagrant folder
1. The current ansible script will activate the windows 10 vm if it is not actiavted. After that it will install git, chocolatey and visual studio 2017 and activate the visual studio if activation key is supplied (See [here](https://docs.microsoft.com/en-us/visualstudio/install/automatically-apply-product-keys-when-deploying-visual-studio) for the list of MPC code if you are using a different flavors of visual studio)
1. Run `vagrant provision`

## Ansible playbook
The ansible playbook is just an example to demonstrate how we can use ansible to provision a windows machine, it should follow the roles and playbook model to make it more maintainable.

