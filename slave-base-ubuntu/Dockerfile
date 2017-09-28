FROM ubuntu:12.04.5

MAINTAINER Adam Saleh <asaleh@redhat.com>

USER root

ENV HOME=/home/jenkins

RUN apt-get update && \
    apt-get -y install \
        # curl is used a few times here in the Dockerfile
        curl \

        # This is to be able to use add-apt-repository here
        python-software-properties && \

    # We use openjdk-8 for the java image, so let's use same jre for
    add-apt-repository -y ppa:openjdk-r/ppa && \

    # This is needed for GCC 4.8
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get -y install curl && \

    # This is needed to be able to install openssh-client (git dependency)
    curl -Lo libselinux1_2.2.2-1_amd64.deb \
        http://mirrors.kernel.org/ubuntu/pool/main/libs/libselinux/libselinux1_2.2.2-1_amd64.deb && \
    dpkg -i libselinux1_2.2.2-1_amd64.deb && \
    rm -f libselinux1_2.2.2-1_amd64.deb && \

    apt-get -y install \
        apache2-utils \
        bc \
        bzip2 \
        gcc-4.8 \
        gettext \
        g++-4.8 \
        # Git dependency
        libcurl4-gnutls-dev \
        liblog4cxx10-dev \
        libssl-dev \
        # Git dependency
        libz-dev \
        lsof \
        make \
        # memcached is needed for fh-aaa and fh-supercore tests
        memcached \
        openjdk-8-jre-headless \
        openssh-client \
        # Git dependency
        perl \
        rsync \
        # wget is used in fh-mobile-sdks makefile
        wget \
        zip && \

    # Manually configure because we're not installing primary gcc/g++ packages
    # (they'd pull in gcc/g++ 4.6 in addition to this 4.8)
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-4.8 50 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50 && \

    # TODO: do we actually use this?
    curl -Lo libnss-wrapper_1.1.3-1_amd64.deb \
        http://ftp.us.debian.org/debian/pool/main/n/nss-wrapper/libnss-wrapper_1.1.3-1_amd64.deb && \
    dpkg -i libnss-wrapper_1.1.3-1_amd64.deb && \
    rm -f libnss-wrapper_1.1.3-1_amd64.deb && \

    curl -Lo /usr/bin/jq \
        https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
    chmod +x /usr/bin/jq && \

    # Newer version of git for security fixes
    curl -Lo git-1.8.5.6.tar.gz \
        https://www.kernel.org/pub/software/scm/git/git-1.8.5.6.tar.gz  && \
    tar -zxf git-1.8.5.6.tar.gz  && \
    cd git-1.8.5.6  && \
        ./configure --with-expat=no --with-tcltk=no --with-openssl=no && \
        make NO_OPENSSL=Yes NO_EXPAT=Yes NOTCLTK=Yes NO_GETTEXT=Yes && \
        make NO_OPENSSL=Yes NO_EXPAT=Yes NOTCLTK=Yes NO_GETTEXT=Yes install && \
    cd ../ && rm -Rf git-* && \

    curl -L https://github.com/openshift/origin/releases/download/v3.6.0/openshift-origin-client-tools-v3.6.0-c4dd4cf-linux-64bit.tar.gz | \
    tar -zx && \
    mv openshift*/oc /usr/local/bin && \
    rm -rf openshift-origin-client-tools-* && \

    curl -Lo /usr/local/bin/swarm-client.jar \
        https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4.jar && \

    mkdir -p ${HOME} && \
    chown -R 1001:0 ${HOME} && \
    chmod -R g+rw ${HOME} && \
    echo default:x:1001:0:root:${HOME}:/bin/bash >> /etc/passwd && \

    mkdir /workspace && \
    chown -R 1001:0 /workspace && \
    chmod -R g+rw /workspace && \

    apt-get install -f && \
    apt-get purge -y python-software-properties software-properties-common && \
    apt-get autoremove -y && apt-get clean -y && apt-get autoclean -y

ADD contrib/bin/* /usr/local/bin/

USER default

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/local/bin/run-jnlp-client"]
