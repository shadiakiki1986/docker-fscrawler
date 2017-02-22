#!/bin/sh
# Managing Docker & Docker Compose versions on Travis
# https://graysonkoonce.com/managing-docker-and-docker-compose-versions-on-travis-ci/

DOCKER_VERSION=1.13.1-0~ubuntu-trusty
DOCKER_COMPOSE_VERSION=1.11.2

# starting versions
docker --version
docker-compose --version

# list docker-engine versions
apt-cache madison docker-engine

# upgrade docker-engine to specific version
# EDIT: it turns out that my test passed without updating docker-engine .. so skipping this
#- sudo apt-get -o Dpkg::Options::="--force-confnew" install -y docker-engine=${DOCKER_VERSION}

# reinstall docker-compose at specific version
# https://docs.docker.com/compose/install/
sudo rm -f /usr/local/bin/docker-compose
curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
chmod +x docker-compose
sudo mv docker-compose /usr/local/bin

# show versions again
docker --version
docker-compose --version
