FROM openjdk:alpine
RUN apk add --update openssl
RUN mkdir ~/.fscrawler ~/files
COPY install.sh .
ARG FSCRAWLER_VER=2.1
RUN /bin/sh install.sh
WORKDIR /fscrawler
# sleep below to wait for elasticsearch to boot
ENTRYPOINT sleep 15 \
        && cp /data/fscrawler/home/* /root/.fscrawler -r \
        && cp /data/fscrawler/files/* /root/files -r \
        && bin/fscrawler --trace myjob
