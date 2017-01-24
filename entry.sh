#!/bin/sh

set -e

cp /data/fscrawler/home/* /root/.fscrawler -r
cp /data/fscrawler/files/* /root/files -r

if [ "$FSCRAWLER_VER" == "2.2" ]; then
  bin/fscrawler --trace --restart myjob
else
  # since --restart was only introduced in 2.2, resort to rm
  rm -f ~/.fscrawler/myjob/_status.json
  bin/fscrawler --trace myjob
fi
