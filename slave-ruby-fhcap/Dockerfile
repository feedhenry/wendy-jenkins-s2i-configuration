FROM docker.io/fhwendy/jenkins-slave-base-centos7:latest

MAINTAINER Michael Nairn <mnairn@redhat.com>

USER root

ENV BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

RUN yum install -y --setopt=tsflags=nodocs epel-release && \

    yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install python-pip && \

    # Install Ruby
    yum install -y --setopt=tsflags=nodocs centos-release-scl-rh && \
    INSTALL_PKGS="rh-ruby23 rh-ruby23-ruby-devel rh-ruby23-rubygem-rake rh-ruby23-rubygem-bundler zlib-devel openssl python-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum groupinstall -y --setopt=tsflags=nodocs "Development Tools" && \
    yum clean all -y && \

    pip install python-novaclient==7.1.0 && \
    pip install awscli==1.11.80 && \

    scl enable rh-ruby23 "gem update --system" && \
    scl enable rh-ruby23 "gem uninstall minitar" && \
    scl enable rh-ruby23 "gem install minitar -v 0.5.4 -f" && \
    scl enable rh-ruby23 "gem install archive-tar-minitar -v 0.5.2 -f" && \
    scl enable rh-ruby23 "gem install fhcap-cli --no-ri --no-doc" && \

    chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
