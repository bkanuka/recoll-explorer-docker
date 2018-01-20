FROM ubuntu:xenial

ENV NODE_VERSION='8'
ENV DEBIAN_FRONTEND=noninteractive
ENV RECOLL_CONFDIR=/etc/recoll

RUN apt update && apt dist-upgrade -y
RUN apt install -y python-software-properties software-properties-common

# Inatall Recoll
RUN add-apt-repository ppa:recoll-backports/recoll-1.15-on
RUN apt update
RUN apt install -y recoll unzip xsltproc poppler-utils antiword sed curl wget

# Install nodejs LTS
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt -y install build-essential git \
    && apt -y install nodejs \
    && npm i -g npm gulp bower pm2

# Install explorer
RUN git clone https://github.com/bkanuka/explorer.git /opt/explorer \
    && cd /opt/explorer \
    && npm install \
    && bower install --allow-root \
    && gulp

# Explorer Config
RUN mkdir -p /root/.config/explorer \
    && mkdir -p /root/.config/explorer/certs \
    && mkdir -p /root/.config/explorer/data
COPY config.yml /root/.config/explorer
COPY users /root/.config/explorer/data
COPY cert.pem /root/.config/explorer/certs
COPY key.pem /root/.config/explorer/certs

# Recoll Config
RUN mkdir -p ${RECOLL_CONFDIR}
COPY recoll.conf ${RECOLL_CONFDIR}/recoll.conf

COPY run.sh /opt/explorer
COPY recollsearch /usr/bin
WORKDIR /opt/explorer
CMD ["/bin/bash", "/opt/explorer/run.sh"]
