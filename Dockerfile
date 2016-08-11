FROM alpine:latest
RUN apk update
RUN apk add nfs-utils bash
RUN rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash", "/entrypoint.sh" ]
