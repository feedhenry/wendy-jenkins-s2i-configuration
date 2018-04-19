FROM quay.io/feedhenry/jenkins-agent-base-centos7:latest

MAINTAINER Michael Nairn <mnairn@redhat.com>

#Maven slave setup from here https://github.com/openshift/jenkins/tree/master/slave-maven/

USER root

ENV MAVEN_VERSION=3.1.1

RUN INSTALL_PKGS="wget java-1.8.0-openjdk-devel ant" && \
    yum install -y --enablerepo=centosplus --setopt=tsflags=nodocs $INSTALL_PKGS && \

    # TODO: for size, we should install specific stuff rather than groups
    yum groupinstall -y "Development Tools" && \
    yum clean all -y && \

    (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \

    mkdir -p $HOME/.m2 && \
    chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

ADD ./contrib/settings.xml $HOME/.m2/

USER 1001
