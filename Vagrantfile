# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "pipeline" do |box|
    box.vm.box = "dummy"
    box.ssh.private_key_path = "~/.ssh/id_rsa"

    box.vm.provision :shell, :inline => <<-SH
      command_exists() {
        command -v "$@" > /dev/null 2>&1
      }
      if !(command_exists docker || command_exists lxc-docker); then
        curl -sSL https://get.docker.com/ | sh
        gpasswd -a ubuntu docker
        service docker restart && sleep 3
        docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
      else
        echo "stopping all containers..." && docker stop $(docker ps -a -q)
        echo "deleting all containers..." && docker rm $(docker ps -a -q)
      fi
      docker pull registry
      docker pull mercer/jenkins:latest
      REGISTRY_HASH=$(docker run -itd -p 5000:5000 registry)
      REGISTRY_NAME=$(docker inspect -f "{{ .Name }}" $REGISTRY_HASH)
      JENKINS_HASH=$(docker run -itd -p 8080:8080 -v /vagrant/data/jenkins:/jenkins mercer/jenkins:latest)
      JENKINS_NAME=$(docker inspect -f "{{ .Name }}" $JENKINS_HASH)
      echo "jenkins container is called: $JENKINS_NAME"
      curl -s ip.jsontest.com
    SH

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
    end
  end
end
