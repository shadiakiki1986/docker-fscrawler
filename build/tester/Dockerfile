FROM alpine:latest
RUN apk --update add curl openssl
RUN apk add jq
CMD syslogd && sleep 1 && tail -f /var/log/messages*
