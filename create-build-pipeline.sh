#!/bin/bash
set -e

if [ "$DATA_HOME" = "" ]; then
    echo "DATA_HOME variable is not set; please set it before running this script."
    exit 1
fi

SONAR_MYSQL_HASH=$(docker run -itd mercer/sonar-mysql)
SONAR_MYSQL_NAME=$(docker inspect -f "{{ .Name }}" $SONAR_MYSQL_HASH)
SONAR_HASH=$(docker run -itd -p 9000:9000 --link $SONAR_MYSQL_NAME:db mercer/sonar)
SONAR_NAME=$(docker inspect -f "{{ .Name }}" $SONAR_HASH)
ARTIFACTORY_HASH=$(docker run -itd -p 8081:8080 mattgruter/artifactory)
ARTIFACTORY_NAME=$(docker inspect -f "{{ .Name }}" $ARTIFACTORY_HASH)
REGISTRY_HASH=$(docker run -itd -p 5000:5000 registry)
REGISTRY_NAME=$(docker inspect -f "{{ .Name }}" $REGISTRY_HASH)
JENKINS_HASH=$(docker run -itd -p 8080:8080 -u root -v $DATA_HOME/jenkins:/var/jenkins_home --link $SONAR_MYSQL_NAME:SONAR_MYSQL --link $SONAR_NAME:SONAR --link $ARTIFACTORY_NAME:ARTIFACTORY mercer/jenkins)
JENKINS_NAME=$(docker inspect -f "{{ .Name }}" $JENKINS_HASH)

docker build -t crosbymichael/dockerui github.com/crosbymichael/dockerui
docker run -d -p 9001:9000 -v /var/run/docker.sock:/docker.sock crosbymichael/dockerui -e /docker.sock

printf "\nNew containers created: $SONAR_MYSQL_NAME, $SONAR_NAME, $ARTIFACTORY_NAME, $REGISTRY_NAME, $JENKINS_NAME\n\n"
docker ps -a
