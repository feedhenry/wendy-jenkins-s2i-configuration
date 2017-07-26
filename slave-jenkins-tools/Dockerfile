FROM docker.io/fhwendy/jenkins-slave-java:latest

USER root

# Jenkins Job Builder

ENV BRANCH master

WORKDIR /
RUN git clone -b allow_self_signed_certs https://github.com/mikenairn/python-jenkins.git && \
    pushd python-jenkins && \
    yum -y --enablerepo=extras install epel-release && \
    yum -y install python-pip && \
    pip install -U -r requirements.txt && python setup.py install && \
    popd && \

    git clone -b ${BRANCH} https://git.openstack.org/openstack-infra/jenkins-job-builder && \
    pushd jenkins-job-builder && \
    git checkout baca7d15504a93c9d92f15e034470cbdc86f2615 && \
    /usr/bin/pip install -U pytest && \
    pip install -U -r requirements.txt && \
    python setup.py install && \
    popd && \

    git clone https://github.com/rusty-dev/jenkins-job-builder-pipeline.git && \
    pushd jenkins-job-builder-pipeline && \
    python setup.py install && \
    popd  && \

# Jenkins Plugins Installer

    git clone https://github.com/feedhenry/jenkins-plugin-install.git && \
    pushd jenkins-plugin-install && \
    pip install -r requirements.txt && python setup.py install && \
    popd

# Jenkins CLI

ADD https://raw.githubusercontent.com/feedhenry/docker-jenkins-cli/rhmap/jenkins-cli-wrapper.sh /usr/bin/jenkins-cli

ENV JENKINS_URL ""

RUN chown 1001 /usr/bin/jenkins-cli && \
    chmod g+rx /usr/bin/jenkins-cli

USER 1001
