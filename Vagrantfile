# -*- mode: ruby -*-
# vi: set ft=ruby :

# set http_proxy=http://myuser:mypassword@myserver:3128
# set https_proxy=%http_proxy%
# vagrant box add generic/ubuntu2004

ENV["LC_ALL"] = "fr_FR.UTF-8"
PROXY_ON = false
PROXY_SERVER = ""

Vagrant.configure("2") do |config|
  puts "proxyconf..."
  if Vagrant.has_plugin?("vagrant-proxyconf")
    puts "find proxyconf plugin !"
    if ENV["http_proxy"]
      puts "http_proxy: " + ENV["http_proxy"]
      config.proxy.http = ENV["http_proxy"]
      PROXY_ON = true
      PROXY_SERVER =  ENV["http_proxy"]
    end
    if ENV["https_proxy"]
      puts "https_proxy: " + ENV["https_proxy"]
      config.proxy.https = ENV["https_proxy"]
    end
    if ENV["no_proxy"]
      config.proxy.no_proxy = ENV["no_proxy"]
    end
  end

  config.vm.box = "generic/ubuntu2004"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.boot_timeout = 180
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "3072"
    vb.cpus = 2
    vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
  end

  config.vm.define 'master' do |myvm|
    myvm.vm.hostname = "master.jobjects.net"
    myvm.vm.network "private_network", ip: "192.168.56.150"
    myvm.vm.provision "ansible_local" do |ansible|
      ansible.playbook       = "provision.yml"
      ansible.verbose        = true
      ansible.install        = true
      ansible.limit          = "all" # or only "nodes" group, etc.
      ansible.inventory_path = "inventory.txt"
      ansible.config_file = "/vagrant/ansible.cfg"
      #ansible.host_key_checking = false
      #ansible.raw_ssh_args = ["-o ControlMaster=auto", "-o ControlPersist=60s", "-o UserKnownHostsFile=/dev/null", "-o IdentitiesOnly=yes"]
      ansible.extra_vars = {
        PROXY_ON: PROXY_ON,
        PROXY_SERVER: PROXY_SERVER
      }
    end
# =end
  end

end
