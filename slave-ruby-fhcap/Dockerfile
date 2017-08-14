FROM docker.io/fhwendy/jenkins-slave-base-centos7:latest

MAINTAINER Michael Nairn <mnairn@redhat.com>

USER root

ENV BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm

RUN yum -y update
RUN yum -y install python-pip

# Install Ruby
RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-ruby23 rh-ruby23-ruby-devel rh-ruby23-rubygem-rake rh-ruby23-rubygem-bundler zlib-devel openssl python-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

RUN yum groupinstall -y "Development Tools"

RUN pip install python-novaclient==7.1.0

RUN pip install awscli==1.11.80

RUN scl enable rh-ruby23 "gem update --system"
RUN scl enable rh-ruby23 "gem uninstall minitar"
RUN scl enable rh-ruby23 "gem install minitar -v 0.5.4 -f"
RUN scl enable rh-ruby23 "gem install archive-tar-minitar -v 0.5.2 -f"
RUN scl enable rh-ruby23 "gem install fhcap-cli --no-ri --no-doc"

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
