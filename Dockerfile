FROM openjdk:alpine
RUN apk add --update openssl
RUN mkdir ~/.fscrawler ~/files
COPY install.sh .
ARG FSCRAWLER_VER=2.1
RUN /bin/sh install.sh
WORKDIR /fscrawler
COPY entry.sh /
ENTRYPOINT /bin/sh /entry.sh
