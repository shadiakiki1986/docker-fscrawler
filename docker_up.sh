#!/bin/sh
set -e

# up elasticsearch
docker-compose \
  -f elasticsearch-docker/docker-compose.yml \
  -f docker-compose.yml \
  up -d --build \
  elasticsearch1

# Wait for elasticsearch1 to complete its 'up' sequence
# Note that this section can be replaced with a simple "sleep 15"
# but I grep for the end of its up because travis takes different time than locally on my machine
#
# Ref: Monitoring a file until a string is found
# http://superuser.com/a/548193/642842
echo "Wait for elasticsearch1 to complete its 'up' sequence"
fifo=/tmp/tmpfifo.$$
mkfifo "${fifo}" || exit 1
docker-compose \
  -f elasticsearch-docker/docker-compose.yml \
  -f docker-compose.yml \
  logs -f \
  elasticsearch1 >${fifo} &
tailpid=$! # optional
grep -m 1 "\[RED\]" "${fifo}"
kill "${tailpid}" # optional
rm "${fifo}"

# continue by up'ing fscrawler
docker-compose \
  -f elasticsearch-docker/docker-compose.yml \
  -f docker-compose.yml \
  up -d --build \
  fscrawler

# Here I just sleep while fscrawler runs its first index
echo "Wait for fscrawler for 10 seconds"
sleep 10
