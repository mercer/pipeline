# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "pipeline" do |box|
    box.vm.box = "dummy"
    #box.vm.synced_folder ".", "/vagrant", type: "rsync"
    box.ssh.private_key_path = "~/.ssh/id_rsa"

    box.vm.provision :shell, :inline => <<-SH
      curl -sSL https://get.docker.com/ | sh
      export DATA_HOME=/vagrant/data
      /vagrant/create-build-pipeline.sh
    SH

    box.vm.provider :virtualbox do |virtualbox, override|
      virtualbox.name = "pipeline_virtualbox"
      virtualbox.memory = 2048
      
      override.vm.box = "phusion/ubuntu-14.04-amd64"
      override.vm.hostname = "pipeline"
    end
    
    box.vm.provider :digital_ocean do |digitalocean, override|
      digitalocean.name = "pipeline_digitalocean"
      digitalocean.token = ENV['VAGRANT_DIGITALOCEAN_TOKEN']
      digitalocean.image = "14.04 x64"
      digitalocean.region = "ams2"
      digitalocean.size = "1gb"

      override.vm.box = "digital_ocean"
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    end

    box.vm.provider :aws do |aws, override|
      aws.access_key_id = ENV['VAGRANT_EC2_ACCESS_KEY_ID']
      aws.secret_access_key = ENV['VAGRANT_EC2_SECRET_ACCESS_KEY']

      aws.keypair_name = "vagrant"
      aws.security_groups = [ "vagrant" ]
      aws.ami = "ami-4d594d08"
      aws.region = "us-west-1"
      aws.instance_type = "m3.medium"

      override.vm.box = "aws"
      override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      override.ssh.username = "ubuntu"
    end
  end
end
