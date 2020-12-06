# Based on https://github.com/dadoonet/fscrawler/issues/314#issuecomment-282823207

# 2020-12-04: For 2.7-SNAPSHOT, upgraded from 16.04 to 20.04, and openjdk-8-jdk to openjdk-14-jdk
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openjdk-14-jdk wget unzip maven tesseract-ocr tesseract-ocr-fra

RUN update-ca-certificates -f

WORKDIR /runtime

#---------------------------
# Set 1: pre-2018-10-04
# Until issue fscrawler/461 is closed via PR 475 (in fscrawler 2.5)
# Use my own fork/branch
# https://github.com/dadoonet/fscrawler/pull/475
# ENV FS_BRANCH=fscrawler-2.5
#ENV FS_UPSTREAM=shadiakiki1986

# set 2
# ENV FS_BRANCH=issue_461_rest_pipeline
# ENV FS_UPSTREAM=shadiakiki1986

# set 3: 2018-10-04: PR was merged, so move back to upstream
#ENV FS_BRANCH=master
ENV FS_BRANCH=fscrawler-2.6
ENV FS_UPSTREAM=dadoonet

#----------------------------
RUN wget https://github.com/$FS_UPSTREAM/fscrawler/archive/$FS_BRANCH.zip
RUN unzip $FS_BRANCH.zip
# RUN cd fscrawler-$FS_BRANCH && mvn compile
WORKDIR /runtime/fscrawler-$FS_BRANCH

# build
# RUN mvn clean install -X -DskipTests # > /dev/null
RUN mvn clean package -DskipTests # > /dev/null

RUN mkdir /usr/share/fscrawler

# continue
WORKDIR /usr/share/fscrawler
ENV PATH /usr/share/fscrawler/bin:$PATH

# ensure fscrawler user exists
RUN addgroup --system fscrawler && adduser --system --ingroup fscrawler fscrawler

# grab su-exec (alpine) or gosu (ubuntu) for easy step-down from root
# and bash for "bin/fscrawler" among others
RUN apt-get update && apt-get install -y gosu bash openssl

#-----------------------------
# usually same as FS_BRANCH, except *-SNAPSHOT that map to FS_BRANCH=master
# ENV FSCRAWLER_VERSION=2.5-SNAPSHOT
# ENV FSCRAWLER_VERSION=2.5
#ENV FSCRAWLER_VERSION=2.6-SNAPSHOT
ENV FSCRAWLER_VERSION=2.6
#ENV FSCRAWLER_VERSION=2.7-SNAPSHOT

#  ls /runtime/fscrawler-$FS_BRANCH/distribution/$ES_VERSION_i/target/ \
#  # archive-tmp classes fscrawler-es6-2.6.jar fscrawler-es6-2.6.zip generated-sources maven-archiver maven-status

# Now cp and unzip the generated zip file from the maven build above
#RUN for ES_VERSION_i in "${ES_VERSION_a[@]}"; do \
COPY docker-setbin.sh .
RUN bash docker-setbin.sh $FS_BRANCH es5 $FSCRAWLER_VERSION
RUN bash docker-setbin.sh $FS_BRANCH es6 $FSCRAWLER_VERSION

# set default binary "fscrawler"
RUN ln -s $PWD/fscrawler-es6-$FSCRAWLER_VERSION/bin/fscrawler /usr/local/bin/fscrawler

# check
RUN ls -al /usr/local/bin/
RUN which fscrawler fscrawler-es5 fscrawler-es6

# Remove logs path from below as it was just copy-pasted from elasticsearch
# 		./logs \
RUN set -ex; \
	for path in \
		./data \
		./config \
	; do \
		mkdir -p "$path"; \
		chown -R fscrawler:fscrawler "$path"; \
	done;

# shopt from https://unix.stackexchange.com/a/6397/312018
# RUN /bin/bash -c "shopt -s dotglob nullglob; mv /runtime/fscrawler-$FSCRAWLER_VERSION/* .; ls -al /runtime/fscrawler-$FSCRAWLER_VERSION; rmdir /runtime/fscrawler-$FSCRAWLER_VERSION;"

#RUN chown -R fscrawler:fscrawler .
#USER fscrawler

VOLUME /usr/share/fscrawler/data
RUN mkdir /usr/share/fscrawler/config-mount \
  && touch /usr/share/fscrawler/config-mount/empty

COPY entry.sh /

ENTRYPOINT ["/entry.sh"]
CMD ["fscrawler", "--trace", "--config_dir", "/usr/share/fscrawler/config", "myjob"]
