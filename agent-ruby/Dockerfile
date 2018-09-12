FROM quay.io/feedhenry/jenkins-agent-base-centos7:latest

MAINTAINER Michael Nairn <mnairn@redhat.com>

USER root

ENV BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

# Install Ruby
RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-ruby23 rh-ruby23-ruby-devel rh-ruby23-rubygem-rake rh-ruby23-rubygem-bundler zlib-devel libxml2-devel libcurl-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum groupinstall -y --setopt=tsflags=nodocs "Development Tools" && \
    yum clean all -y && \

    scl enable rh-ruby23 "gem update --system" && \

    chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
