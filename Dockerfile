# example: docker build -t vmq:1.4.1 .

FROM ubuntu:bionic

MAINTAINER "Michael Fung <hkuser2001@gmail.com>"

#
# exclude doc and man pages from packages
#
COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
COPY tmp/su-exec /usr/local/bin/

#
# url of the prebuilt binary
#
ARG VMQ_BIN_FILE_URL=http://192.168.0.1/usbhd/tmp/vmq-bin-1.4.1.tgz

#
# install required binary lib and tools
#
RUN apt-get update && apt-get install -y \
    libssl1.0.0 libssl1.1 libssl-dev \
    logrotate \
    sudo less \
    curl \
    jq \
    iproute2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*  # cleanup to save space

#
# install the vmq binary
#
RUN curl $VMQ_BIN_FILE_URL | tar zxvf - -C /opt \
    && chown -R nobody:nogroup /opt/vernemq

#
# expose ports ( 8885 and 8887 are for SIOT )
#
EXPOSE 1883
EXPOSE 1885
EXPOSE 1887
EXPOSE 8883
EXPOSE 8885
EXPOSE 8887
EXPOSE 8080
# VerneMQ Message Distribution
EXPOSE 44053
# EPMD - Erlang Port Mapper Daemon
EXPOSE 4369
# Specific Distributed Erlang Port Range
EXPOSE 9100 9101 9102 9103 9104 9105 9106 9107 9108 9109
# Prometheus Metrics
EXPOSE 8888

VOLUME ["/opt/vernemq/etc", "/opt/vernemq/data", "/opt/vernemq/log"]

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]
