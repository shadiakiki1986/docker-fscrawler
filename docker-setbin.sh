# Usage: docker-setbin.sh $FS_BRANCH es5 $FSCRAWLER_VERSION
set -ex
FS_BRANCH=$1
ES_VERSION_i=$2
FSCRAWLER_VERSION=$3

ls /runtime/fscrawler-$FS_BRANCH/distribution/$ES_VERSION_i/target/
cp /runtime/fscrawler-$FS_BRANCH/distribution/$ES_VERSION_i/target/fscrawler-$ES_VERSION_i-$FSCRAWLER_VERSION.zip .
unzip fscrawler-$ES_VERSION_i-$FSCRAWLER_VERSION.zip
rm fscrawler-$ES_VERSION_i-$FSCRAWLER_VERSION.zip
ln -s $PWD/fscrawler-$ES_VERSION_i-$FSCRAWLER_VERSION/bin/fscrawler /usr/local/bin/fscrawler-$ES_VERSION_i


#RUN ls fscrawler-$ES_VERSION-$FSCRAWLER_VERSION; \
#    mv fscrawler-$ES_VERSION-$FSCRAWLER_VERSION/* .; \
#   rmdir fscrawler-$ES_VERSION-$FSCRAWLER_VERSION;
## LICENSE   NOTICE   README.md   bin   lib

