# Copied from https://github.com/dadoonet/fscrawler/issues/314#issuecomment-282823207
# with modifications

FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openjdk-8-jdk wget unzip maven
RUN apt-get install -y tesseract-ocr-fra tesseract-ocr
RUN update-ca-certificates -f

WORKDIR /runtime

RUN wget https://github.com/dadoonet/fscrawler/archive/master.zip
RUN unzip master.zip
RUN cd fscrawler-master && mvn compile

# Modified original from here on
# Copied from Dockerfile
WORKDIR /runtime/fscrawler-master
ENV FSCRAWLER_VERSION=2.5-SNAPSHOT
RUN mvn clean install -X -DskipTests
RUN mkdir /usr/share/fscrawler \
 && cp target/fscrawler-$FSCRAWLER_VERSION.zip /usr/share/fscrawler/fscrawler.zip

# continue
WORKDIR /usr/share/fscrawler
ENV PATH /usr/share/fscrawler/bin:$PATH

# ensure fscrawler user exists
RUN addgroup --system fscrawler && adduser --system --ingroup fscrawler fscrawler

# grab su-exec (alpine) or gosu (ubuntu) for easy step-down from root
# and bash for "bin/fscrawler" among others
RUN apt-get update && apt-get install -y gosu bash openssl

# Remove logs path from below as it was just copy-pasted from elasticsearch
# 		./logs \
RUN set -ex; \
	\
	unzip fscrawler.zip; \
	rm fscrawler.zip; \
	\
	for path in \
		./data \
		./config \
	; do \
		mkdir -p "$path"; \
		chown -R fscrawler:fscrawler "$path"; \
	done;

RUN mv fscrawler-$FSCRAWLER_VERSION/* .; \
  rmdir fscrawler-$FSCRAWLER_VERSION;
#RUN chown -R fscrawler:fscrawler .
#USER fscrawler

VOLUME /usr/share/fscrawler/data
RUN mkdir /usr/share/fscrawler/config-mount \
  && touch /usr/share/fscrawler/config-mount/empty

COPY entry.sh /

ENTRYPOINT ["/entry.sh"]
CMD ["fscrawler", "--trace", "--config_dir", "/usr/share/fscrawler/config", "myjob"]
