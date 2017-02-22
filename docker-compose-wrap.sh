#!/bin/sh
# Helper script to do docker up/run/...

# Copied from https://github.com/shadiakiki1986/ffa-elasticsearch
export FSCRAWLER_VER="2.2"
export ELASTIC_VERSION="5.1.2"
export ES_DOWNLOAD_URL="https://artifacts.elastic.co/downloads/elasticsearch"
export ES_JAVA_OPTS=""
export ELASTIC_REGISTRY="docker.elastic.co"
export VERSIONED_IMAGE="${ELASTIC_REGISTRY}/elasticsearch/elasticsearch:${ELASTIC_VERSION}"
export BASEIMAGE="${ELASTIC_REGISTRY}/elasticsearch/elasticsearch-alpine-base:latest"
export ES_NODE_COUNT="1"

# Getting the source directory of a Bash script from within
# http://stackoverflow.com/a/1482133/4126114
BASEDIR=`dirname "$0"`

docker-compose \
  -f $BASEDIR/elasticsearch-docker/docker-compose.yml \
  -f $BASEDIR/docker-compose.yml \
  $@
