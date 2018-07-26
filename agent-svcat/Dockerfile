FROM quay.io/feedhenry/jenkins-agent-base-centos7:latest

MAINTAINER Vitalii Chepeliuk <vchepeli@redhat.com>

USER root

ARG SVCAT_VER=0.1.21
ARG SVCAT_BIN=svcat
ARG SVCAT_URL=https://download.svcat.sh/cli/v${SVCAT_VER}/linux/amd64/${SVCAT_BIN}
ARG MBCLI_VER=1.0.0
ARG MBCLI_BIN=mobile
ARG MBCLI_GZIP=mobile-cli_${MBCLI_VER}_linux_amd64.tar.gz
ARG MBCLI_URL=https://github.com/aerogear/mobile-cli/releases/download/${MBCLI_VER}/${MBCLI_GZIP}

RUN yum -y update && \
    yum -y install \
        curl \
        unzip \
        wget \
        zip && \
    yum clean all

RUN cd /tmp && curl -s -O -J -L ${SVCAT_URL} && chmod +x ${SVCAT_BIN} && mv ${SVCAT_BIN} /usr/local/bin/${SVCAT_BIN}
RUN cd /tmp && curl -s -O -J -L ${MBCLI_URL} && tar -xf ${MBCLI_GZIP} && mv ${MBCLI_BIN} /usr/local/bin/${MBCLI_BIN}