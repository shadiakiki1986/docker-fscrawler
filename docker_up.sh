#!/bin/sh
set -e

# up elasticsearch
docker-compose \
  -f elasticsearch-docker/docker-compose.yml \
  -f docker-compose.yml \
  up -d --build \
  elasticsearch1

echo "Wait for elasticsearch1 to complete its 'up' sequence (15 secs)"
sleep 15

# continue by up'ing fscrawler
docker-compose \
  -f elasticsearch-docker/docker-compose.yml \
  -f docker-compose.yml \
  up -d --build \
  fscrawler

# Here I just sleep while fscrawler runs its first index
echo "Wait for fscrawler to complete its first indexing (10 secs)"
sleep 10
