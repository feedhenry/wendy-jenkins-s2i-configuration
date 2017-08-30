FROM docker.io/fhwendy/jenkins-slave-base-centos7:latest

MAINTAINER Oleg Matskiv <omatskiv@redhat.com>

USER root

RUN yum -y install \
        epel-release \
        wget && \
    yum -y install \
        PyYAML \
        python-jinja2 \
        python-httplib2 \
        python-keyczar \
        python-paramiko \
        python-setuptools \
        git \
        python-pip && \
    yum clean all && \

    mkdir /etc/ansible/ && \
    echo -e '[local]\nlocalhost' > /etc/ansible/hosts && \
    pip install ansible
