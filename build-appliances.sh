#!/bin/bash
set -e
DIR="$( cd "$( dirname "$0" )" && pwd )"

# build infrastructure
docker build -t="mercer/jenkins" "$DIR/jenkins"
docker build -t="mercer/registry" "$DIR/registry"
docker build -t="mercer/artifactory" "$DIR/artifactory"
docker build -t="mercer/sonar-mysql" "$DIR/sonar-mysql"
docker build -t="mercer/sonar" "$DIR/sonar"