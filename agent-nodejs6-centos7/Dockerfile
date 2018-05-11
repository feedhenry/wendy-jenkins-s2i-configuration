FROM quay.io/feedhenry/jenkins-agent-base-centos7

MAINTAINER Gerard Ryan <gryan@redhat.com>

ENV ENABLED_COLLECTIONS="${ENABLED_COLLECTIONS} rh-nodejs6" \
    PATH="/home/jenkins/bin:${PATH}"

USER root

RUN INSTALL_PKGS="rh-nodejs6 rh-nodejs6-npm memcached bzip2 jq fontconfig" && \
    yum install -y epel-release && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    chmod -R 770 ${HOME}

USER 1001

RUN echo "prefix=${HOME}" > ${HOME}/.npmrc && \
    scl enable rh-nodejs6 "npm i -g grunt jira-miner" && \
    curl -Lo ${HOME}/bin/openshift-template-tool https://github.com/feedhenry/openshift-template-tool/releases/download/0.0.2/openshift-template-tool-linux-amd64 && \
    chmod 755 ${HOME}/bin/openshift-template-tool && \
    chmod -R 775 ${HOME}/lib ${HOME}/etc ${HOME}/bin ${HOME}/.npm ${HOME}/.npmrc
