#!/bin/bash
set -e

command_exists() {
    command -v "$@" > /dev/null 2>&1
}
docker-pid() {
    docker inspect --format '{{ .State.Pid }}' "$@"
}
docker-ip() {
    docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

if !(command_exists docker || command_exists lxc-docker); then
    apt-get update
    apt-get install -y -q ncdu nmap htop
    apt-get clean
    curl -sSL https://get.docker.com/ | sh
    gpasswd -a ubuntu docker
    service docker restart && sleep 3
    docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
    sudo apt-get -s -y vagrant
else
    echo "stopping all containers..." && docker stop $(docker ps -a -q)
    echo "deleting all containers..." && docker rm $(docker ps -a -q)
fi

mkdir -p /data

docker pull registry
REGISTRY_VOLUMES="-v /data/registry:/tmp/registry"
REGISTRY_HASH=$(docker run -itd -p 5000:5000 $REGISTRY_VOLUMES registry)
REGISTRY_NAME=$(docker inspect -f "{{ .Name }}" $REGISTRY_HASH)
REGISTRY_IP=$(docker-ip $REGISTRY_NAME)
echo "docker registry container is called: $REGISTRY_NAME"

docker pull jpetazzo/dind:latest
DOCKER_HASH=$(docker run --privileged -d -p 2375:2375 -e PORT=2375 -e DOCKER_DAEMON_ARGS="--insecure-registry $REGISTRY_IP:5000" jpetazzo/dind)
DOCKER_NAME=$(docker inspect -f "{{ .Name }}" $DOCKER_HASH)
DOCKER_IP=$(docker-ip $DOCKER_NAME)
echo "docker service container is called: $DOCKER_NAME"

docker pull mercer/jenkins:latest
JENKINS_VOLUMES="-v /data/jenkins:/jenkins"
JENKINS_LINKS="--link $REGISTRY_NAME:registry --link $DOCKER_NAME:docker_host"
JENKINS_ENV="-e DOCKER_HOST=$DOCKER_IP:2375 -e REGISTRY_HOST=$REGISTRY_IP:5000"
JENKINS_HASH=$(docker run -itd -p 8080:8080 $JENKINS_ENV $JENKINS_VOLUMES $JENKINS_LINKS mercer/jenkins:latest)
JENKINS_NAME=$(docker inspect -f "{{ .Name }}" $JENKINS_HASH)
echo "jenkins container is called: $JENKINS_NAME"

curl -s ip.jsontest.com
