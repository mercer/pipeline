# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "pipeline" do |box|
    box.vm.box = "dummy"

    box.vm.synced_folder ".", "/vagrant", type: "rsync",
        :rsync_excludes => ['.git', 'data']

    box.vm.provision :shell, :args => "", :path => "provision.sh"

    box.vm.provider :virtualbox do |virtualbox, override|
      virtualbox.name = "pipeline"
      virtualbox.memory = 2048
      
      override.vm.box = "phusion/ubuntu-14.04-amd64"
      override.vm.hostname = "pipeline"
    end
    
    box.vm.provider :digital_ocean do |digitalocean, override|
      digitalocean.name = "pipeline"
      digitalocean.token = ENV['VAGRANT_DIGITALOCEAN_TOKEN']
      digitalocean.image = "14.04 x64"
      digitalocean.region = "ams2"
      digitalocean.size = "1gb"

      override.vm.box = "digital_ocean"
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = "~/.ssh/id_rsa"
    end

    box.vm.provider :aws do |aws, override|
      aws.access_key_id = ENV['VAGRANT_EC2_ACCESS_KEY_ID']
      aws.secret_access_key = ENV['VAGRANT_EC2_SECRET_ACCESS_KEY']

      aws.keypair_name = "vagrant"
      aws.security_groups = [ "vagrant" ] # make sure this security group includes ssh access
      aws.ami = "ami-4d594d08"
      aws.region = "us-west-1"
      aws.instance_type = "t2.micro"

      override.vm.box = "aws"
      override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = "~/.ssh/id_rsa"
    end
  end
end
