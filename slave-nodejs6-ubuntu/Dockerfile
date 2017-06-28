FROM docker.io/fhwendy/jenkins-slave-nodejs-ubuntu:latest

MAINTAINER Adam Saleh <asaleh@redhat.com>

USER default

RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install v6.9.5 && \
    nvm use v6.9.5 && npm i -g grunt && nvm alias default v6.9.5
    
RUN chmod -R 770 $HOME 
