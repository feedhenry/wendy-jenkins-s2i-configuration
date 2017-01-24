FROM openshift/jenkins-slave-base-centos7

MAINTAINER Michael Nairn <mnairn@redhat.com>

RUN INSTALL_PKGS="wget java-1.8.0-openjdk-devel ant" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum clean all -y

RUN yum groupinstall -y "Development Tools"

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
