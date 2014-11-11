#!/bin/bash
set -e

printf "starting containers ...\n"
docker start $(docker ps -a -q)
