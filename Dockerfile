# It suffices to use `FROM openjdk:alpine` to use alpine 3.4, but tesseract is included in apk in alpine 3.5
# so copying the openjdk:alpine dockerfile, but using alpine:3.5
# Ref: https://github.com/docker-library/openjdk/blob/0476812eabd178c77534f3c03bd0a2673822d7b9/8-jdk/alpine/Dockerfile
#      https://pkgs.alpinelinux.org/packages?name=tesseract-ocr&branch=&repo=&arch=&maintainer=
FROM alpine:3.5

# A few problems with compiling Java from source:
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#       really hairy.

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
  } > /usr/local/bin/docker-java-home \
  && chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u111
#                                 v   changed this from original from r0 to r1
#                                 v
#                                 v
#                                 v
ENV JAVA_ALPINE_VERSION 8.111.14-r1

RUN set -x \
  && apk add --no-cache \
    openjdk8="$JAVA_ALPINE_VERSION" \
  && [ "$JAVA_HOME" = "$(docker-java-home)" ]
############################################################
# Now that alpine 3.5 is installed, benefit by installing tesseract
RUN set -x && apk --update --no-cache add tesseract-ocr

#####################################################
# Rest of file shamelessly copied (more or less) from the elasticsearch:alpine dockerfile
# Ref: https://github.com/docker-library/elasticsearch/blob/f2e19796b765e2e448d0e8c651d51be992b56d08/5/alpine/Dockerfile

# ensure fscrawler user exists
RUN addgroup -S fscrawler && adduser -S -G fscrawler fscrawler

# grab su-exec for easy step-down from root
# and bash for "bin/fscrawler" among others
RUN apk add --no-cache 'su-exec>=0.2' bash openssl

WORKDIR /usr/share/fscrawler
ENV PATH /usr/share/fscrawler/bin:$PATH

ENV FSCRAWLER_VERSION 2.2
# fscrawler-2.2-20170124.163124-131.zip
ENV FSCRAWLER_ZIP="https://oss.sonatype.org/content/repositories/snapshots/fr/pilato/elasticsearch/crawler/fscrawler/2.2-SNAPSHOT/fscrawler-2.2-20170201.222335-154.zip"

RUN set -ex; \
	\
	wget -O fscrawler.zip "$FSCRAWLER_ZIP"; \
	\
	unzip fscrawler.zip; \
	rm fscrawler.zip; \
	\
	for path in \
		./data \
		./logs \
		./config \
	; do \
		mkdir -p "$path"; \
		chown -R fscrawler:fscrawler "$path"; \
	done;

RUN mv fscrawler-2.2-SNAPSHOT/* .; \
  rmdir fscrawler-2.2-SNAPSHOT;
#RUN chown -R fscrawler:fscrawler .
#USER fscrawler

COPY config ./config

VOLUME /usr/share/fscrawler/data

COPY entry.sh /

ENTRYPOINT ["/entry.sh"]
CMD ["fscrawler", "--trace", "--config_dir", "/usr/share/fscrawler/config", "myjob"]
