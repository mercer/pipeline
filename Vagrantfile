# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
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
    
    box.vm.provider :digital_ocean do |digital_ocean, override|
      digital_ocean.name = "pipeline"
      digital_ocean.token = ENV['VAGRANT_DIGITALOCEAN_TOKEN']
      digital_ocean.image = "14.04 x64"
      digital_ocean.region = "ams2"
      digital_ocean.size = "1gb"

      override.vm.box = "digital_ocean"
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = "~/.ssh/id_rsa"
    end

    box.vm.provider :aws do |aws, override|
      aws.access_key_id = ENV['VAGRANT_AWS_IAM_ACCESS_KEY_ID']
      aws.secret_access_key = ENV['VAGRANT_AWS_IAM_ACCESS_KEY_SECRET']

      aws.keypair_name = ENV['VAGRANT_AWS_EC2_KEY_PAIR_NAME']
      aws.security_groups = [ ENV['VAGRANT_AWS_EC2_SECURITY_GROUP'] ] # make sure this security group includes ssh access
      aws.ami = "ami-4d594d08"
      aws.region = "us-west-1"
      aws.instance_type = "t2.small"

      override.vm.box = "aws"
      override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = ENV['VAGRANT_AWS_EC2_PRIVATE_KEY_PATH']
    end
  end
end
