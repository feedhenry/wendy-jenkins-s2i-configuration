FROM quay.io/feedhenry/jenkins-agent-base-ubuntu:latest

MAINTAINER Adam Saleh <asaleh@redhat.com>

USER root

ENV MAVEN_VERSION=3.1.1

RUN (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p /var/log/feedhenry/core/ && \
    chown -R 1001:0 /var/log/feedhenry/core/ && \
    chmod -R g+w /var/log/feedhenry/core/ && \
    echo 127.0.0.1 loghost >> /etc/hosts && \
    mkdir -p /home/jenkins/.m2 && \
    chown -R 1001:1001 /home/jenkins/.m2/ && \
    apt-get update && \
    apt-get -y install \
        ant \
        default-jre-headless \
        openjdk-8-jdk \
        memcached && \
    apt-get purge -y python-software-properties software-properties-common && \
    apt-get autoremove -y && apt-get clean -y && apt-get autoclean -y


USER default
ADD ./contrib/settings.xml $HOME/.m2/
