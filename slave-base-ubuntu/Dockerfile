FROM ubuntu:12.04.5

MAINTAINER Adam Saleh <asaleh@redhat.com>

USER root
# Install headless Java

ENV HOME=/home/jenkins

RUN apt-get update && \
    apt-get -y install software-properties-common python-software-properties && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get -y install make ant bc curl wget gettext git openjdk-8-jdk lsof unzip zip && \
    wget http://ftp.us.debian.org/debian/pool/main/n/nss-wrapper/libnss-wrapper_1.1.3-1_amd64.deb && \
    dpkg -i libnss-wrapper_1.1.3-1_amd64.deb && \
    apt-get install -f && \
    mkdir -p /home/jenkins

RUN echo default:x:1001:0:root:/home/jenkins:/bin/bash >> /etc/passwd

ADD contrib/bin/* /usr/local/bin/

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

RUN curl -L https://github.com/openshift/origin/releases/download/v1.4.1/openshift-origin-client-tools-v1.4.1-3f9807a-linux-64bit.tar.gz | \
    tar -zx && \
    mv openshift*/oc /usr/local/bin && \
    rm -rf openshift-origin-client-tools-*

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/local/bin/run-jnlp-client"]