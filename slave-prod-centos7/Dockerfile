FROM quay.io/feedhenry/jenkins-agent-base-centos7:latest

MAINTAINER Adam Saleh <asaleh@redhat.com>

USER root

RUN curl -Lk -o /etc/yum.repos.d/rcm-tools.repo http://download-ipv4.eng.brq.redhat.com/rel-eng/RCMTOOLS/rcm-tools-rhel-7-server.repo && \
    curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - && \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y \
        krb5-workstation \
        rhpkg \
        nodejs \
        rubygem-asciidoctor && \
    yum clean all && \
    curl -Lo /usr/local/bin/openshift-template-tool https://github.com/feedhenry/openshift-template-tool/releases/download/0.0.2/openshift-template-tool-linux-amd64 && \
    chmod 755 /usr/local/bin/openshift-template-tool && \
    curl -Lk https://password.corp.redhat.com/cacert.crt -o /etc/pki/ca-trust/source/anchors/Red_Hat_IS_CA.crt && \
    curl -Lk https://password.corp.redhat.com/RH-IT-Root-CA.crt -o /etc/pki/ca-trust/source/anchors/Red_Hat_IT_Root_CA.crt && \
    curl -Lk https://engineering.redhat.com/Eng-CA.crt -o /etc/pki/ca-trust/source/anchors/Eng_Ops_CA.crt && \
    curl -Lk https://password.corp.redhat.com/pki-ca-chain.crt -o /etc/pki/ca-trust/source/anchors/PKI_CA_Chain.crt && \
    ln -sf /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem /etc/pki/tls/certs/ca-bundle.crt && \
    update-ca-trust && update-ca-trust enable

ADD ./krb5.conf /etc/

COPY ./ssh_config /etc/ssh/ssh_config

USER 1001
