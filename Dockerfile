FROM alpine:3
RUN apk add --no-cache jq curl bash
COPY notify.sh /usr/local/bin/notify
ENTRYPOINT /usr/local/bin/notify