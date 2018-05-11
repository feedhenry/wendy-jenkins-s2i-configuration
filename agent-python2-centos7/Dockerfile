FROM quay.io/feedhenry/jenkins-agent-base-centos7:latest

USER root

RUN yum -y --setopt=tsflags=nodocs install epel-release && \
    yum -y --setopt=tsflags=nodocs install python2-pip && \
    yum clean all && \
    pip install boto==2.46.1

USER 1001
