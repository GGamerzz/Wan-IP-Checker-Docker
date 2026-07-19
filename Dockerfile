FROM python:alpine
COPY update_wan_ip.py /wan_ip_checker/update_wan_ip.py
WORKDIR /wan_ip_checker
RUN mkdir -p /wan_ip_checker/textfiles
ENV CHECK_INTERVAL_SECONDS=3600
CMD ["/bin/sh", "-c", "while true; do python3 update_wan_ip.py; sleep ${CHECK_INTERVAL_SECONDS}; done"]
