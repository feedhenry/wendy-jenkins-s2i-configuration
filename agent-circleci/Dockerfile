FROM quay.io/feedhenry/jenkins-agent-base-centos7:latest

MAINTAINER Pavel Sturc <psturc@redhat.com>

USER root

RUN yum -y install \
        epel-release \
        wget && \
    yum clean all

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O /usr/local/bin/jq && chmod 755 /usr/local/bin/jq
RUN curl https://raw.githubusercontent.com/rockymadden/circleci-cli/master/src/circleci -o /usr/local/bin/circleci && chmod 755 /usr/local/bin/circleci
