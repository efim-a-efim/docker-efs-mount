FROM alpine:latest
RUN apk update
RUN apk add nfs-utils
RUN rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash", "/entrypoint.sh" ]