FROM openjdk:alpine
RUN apk add --update openssl
RUN  wget https://repo1.maven.org/maven2/fr/pilato/elasticsearch/crawler/fscrawler/2.1/fscrawler-2.1.zip \
  && unzip fscrawler-2.1.zip
RUN mkdir ~/.fscrawler ~/files
WORKDIR ./fscrawler-2.1
ENTRYPOINT cp /data/fscrawler/home/* /root/.fscrawler -r \
        && cp /data/fscrawler/files/* /root/files -r \
        && bin/fscrawler --trace myjob
