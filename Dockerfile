# example: docker build -t vmq:ubuntu-1.4.1 .

FROM ubuntu:bionic

MAINTAINER "Michael Fung <hkuser2001@gmail.com>"

WORKDIR /

#
# exclude doc and man pages from packages
#
COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

RUN apt-get update && apt-get install -y \
    libssl-dev \
    logrotate \
    sudo \
    curl \
    jq \
    && apt-get clean && rm -rf /var/lib/apt/lists/*  # cleanup to save space

#
# download the deb package and install
#
# ADD https://bintray.com/artifact/download/erlio/vernemq/deb/bionic/vernemq_1.4.1-1_amd64.deb /tmp/vernemq.deb
# use local copy to speed up rebuild
COPY tmp/ernemq_1.4.1-1_amd64.deb /tmp/vernemq.deb
RUN dpkg -i /tmp/vernemq.deb \
    && rm /tmp/vernemq.deb

#
# expose ports
#
EXPOSE 1883
EXPOSE 8883
EXPOSE 8080
# VerneMQ Message Distribution
EXPOSE 44053
# EPMD - Erlang Port Mapper Daemon
EXPOSE 4369
# Specific Distributed Erlang Port Range
EXPOSE 9100 9101 9102 9103 9104 9105 9106 9107 9108 9109
# Prometheus Metrics
EXPOSE 8888

#VOLUME ["/var/log/vernemq", "/var/lib/vernemq", "/etc/vernemq"]

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]
