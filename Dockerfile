FROM alpine:3
LABEL org.opencontainers.image.source="https://github.com/DHandspikerWade/woodpecker-plugin-ha-notify"
LABEL org.opencontainers.image.title="Home Assistant Notify"
LABEL org.opencontainers.image.description="Plugin to send notifications of pipeline status via Home Assistant"

RUN apk add --no-cache jq curl bash
COPY notify.sh /usr/local/bin/notify
ENTRYPOINT /usr/local/bin/notify