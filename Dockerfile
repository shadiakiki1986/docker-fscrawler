FROM openjdk:alpine
# copied from https://github.com/docker-library/elasticsearch/blob/f2e19796b765e2e448d0e8c651d51be992b56d08/5/alpine/Dockerfile

# ensure fscrawler user exists
RUN addgroup -S fscrawler && adduser -S -G fscrawler fscrawler

# grab su-exec for easy step-down from root
# and bash for "bin/fscrawler" among others
RUN apk add --no-cache 'su-exec>=0.2' bash openssl

WORKDIR /usr/share/fscrawler
ENV PATH /usr/share/fscrawler/bin:$PATH

ENV FSCRAWLER_VERSION 2.2
ENV FSCRAWLER_ZIP="https://oss.sonatype.org/content/repositories/snapshots/fr/pilato/elasticsearch/crawler/fscrawler/2.2-SNAPSHOT/fscrawler-2.2-20170124.163124-131.zip"

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

EXPOSE 9200 9300
ENTRYPOINT ["/entry.sh"]
CMD ["fscrawler", "--trace", "--config_dir", "/usr/share/fscrawler/config", "myjob"]
