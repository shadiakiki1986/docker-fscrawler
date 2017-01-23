#!/bin/sh
set -e
if [ "$FSCRAWLER_VER" == "2.2" ]; then
  echo "install fscrawler 2.2"
  wget https://oss.sonatype.org/content/repositories/snapshots/fr/pilato/elasticsearch/crawler/fscrawler/2.2-SNAPSHOT/fscrawler-2.2-20170121.085715-101.zip
else
  echo "install fscrawler 2.1"
  wget https://repo1.maven.org/maven2/fr/pilato/elasticsearch/crawler/fscrawler/2.1/fscrawler-2.1.zip
fi

unzip fscrawler*.zip
rm fscrawler*.zip
mv fscrawler-* fscrawler
