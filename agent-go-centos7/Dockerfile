FROM quay.io/feedhenry/jenkins-agent-base-centos7:latest

MAINTAINER Paul McCarthy <pamccart@redhat.com>

ENV PATH=$PATH:/usr/local/go/bin:/workspace/bin
ENV GOPATH=/workspace/

USER root

RUN yum -y install make && \
    curl -LO https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.9.linux-amd64.tar.gz && \
    rm go1.9.linux-amd64.tar.gz

USER 1001
