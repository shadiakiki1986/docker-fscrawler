FROM openjdk:alpine
RUN apk add --update openssl
RUN mkdir ~/.fscrawler ~/files
COPY install.sh .
RUN install.sh
WORKDIR /root/fscrawler
# sleep below to wait for elasticsearch to boot
ENTRYPOINT sleep 10 \
        && cp /data/fscrawler/home/* /root/.fscrawler -r \
        && cp /data/fscrawler/files/* /root/files -r \
        && bin/fscrawler --trace myjob
