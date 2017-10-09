FROM docker.io/fhwendy/jenkins-slave-base-centos7:latest

MAINTAINER Paul McCarthy <pamccart@redhat.com>

ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/workspace/

USER root

RUN curl -LO https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.7.linux-amd64.tar.gz && \
    rm go1.7.linux-amd64.tar.gz

USER 1001
