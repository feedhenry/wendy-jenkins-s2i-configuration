FROM quay.io/feedhenry/jenkins-agent-java:latest

USER root

# Jenkins Job Builder
ENV BRANCH master

WORKDIR /
RUN yum -y --enablerepo=extras install epel-release && \
    yum -y install python-pip skopeo && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    \
    git clone -b ${BRANCH} https://git.openstack.org/openstack-infra/jenkins-job-builder && \
    pushd jenkins-job-builder && \
        git checkout ${BRANCH} && \
        /usr/bin/pip install -U pytest && \
        pip install -U -r requirements.txt && \
        python setup.py install && \
    popd && \
    \
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
