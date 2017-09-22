FROM docker.io/fhwendy/jenkins-slave-nodejs-ubuntu:latest

MAINTAINER Adam Saleh <asaleh@redhat.com>

USER root

RUN wget -q -O /usr/local/bin/openshift-template-tool https://github.com/feedhenry/openshift-template-tool/releases/download/0.0.2/openshift-template-tool-linux-amd64 && \
    chmod 755 /usr/local/bin/openshift-template-tool

USER default

RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install v6.9.1 && \
    nvm use v6.9.1 && \
    npm i -g grunt && \
    npm i -g jira-miner && \
    nvm alias default v6.9.1 && \
    chmod -R 770 $HOME
