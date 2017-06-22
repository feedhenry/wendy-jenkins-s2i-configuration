FROM docker.io/fhwendy/jenkins-slave-base-centos7:latest

MAINTAINER Oleg Matskiv <omatskiv@redhat.com>

USER root

RUN yum clean all && \
    yum -y install wget && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip openssl
RUN mkdir /etc/ansible/
RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts
RUN pip install ansible
RUN curl https://password.corp.redhat.com/RH-IT-Root-CA.crt -o /home/jenkins/RH-IT-Root-CA.crt
RUN openssl x509 -in /home/jenkins/RH-IT-Root-CA.crt -text >> /etc/pki/tls/certs/ca-bundle.crt
RUN yes | $JAVA_HOME/bin/keytool --importcert -keystore /usr/lib/jvm/jre/lib/security/cacerts -storepass changeit -file /home/jenkins/RH-IT-Root-CA.crt -alias RH-IT-Root-CA
