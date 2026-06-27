FROM python:alpine

RUN apk add --no-cache git && \
    git clone https://github.com/GGamerzz/Wan-IP-Changes-Script.git /wan_ip_checker && \
    apk del git

WORKDIR /wan_ip_checker

RUN mkdir -p /wan_ip_checker/textfiles

ENV CHECK_INTERVAL_SECONDS=3600

CMD ["/bin/sh", "-c", "while true; do python3 update_wan_ip.py; sleep ${CHECK_INTERVAL_SECONDS}; done"]