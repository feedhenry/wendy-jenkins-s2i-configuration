FROM docker.io/fhwendy/jenkins-slave-base-centos7:latest

MAINTAINER Oleg Matskiv <omatskiv@redhat.com>

USER root

RUN yum clean all && \
    yum -y install wget && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip
RUN mkdir /etc/ansible/
RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts
RUN pip install ansible
