# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "pipeline" do |box|
    box.vm.box = "phusion/ubuntu-14.04-amd64"
    box.vm.hostname = "pipeline"


    if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
      pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
        "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
        "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; "
      pkg_cmd << "usermod -a -G docker vagrant; "
      box.vm.provision :shell, :inline => pkg_cmd
      box.vm.provision "shell", path: "create-build-pipeline.sh"
    end
    
    box.vm.provider :virtualbox do |provider|
      provider.name = "pipeline_virtualbox"
      provider.memory = 2048
    end
    
    box.vm.provider :digital_ocean do |provider, override|
      provider.name = "pipeline_digitalocean"
      provider.token = ENV['VAGRANT_DIGITALOCEAN_TOKEN']
      provider.image = "14.04 x64"
      provider.region = "ams2"
      provider.size = "1gb"

      override.vm.box = "digital_ocean"
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
      override.ssh.private_key_path = "~/.ssh/id_rsa"
    end
  end
end
