#!/bin/sh -xe

if [ -z "${GHORG}" ]; then
   GHORG=feedhenry
fi

if [ -z "${GHREF}" ]; then
   GHREF=master
fi

export GH_ORG=$GHORG
export GH_REF=$GHREF

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPLATES_DIR="$( cd $SCRIPTS_DIR/../templates && pwd )"

if [ -z "${RHNETWORK}" ]; then
   RHNETWORK=false
fi

if [ -z "${BUILD_MASTER}" ]; then
   BUILD_MASTER=false
fi

if [ -z "${BUILD_AGENTS}" ]; then
    BUILD_AGENTS=false
fi

if [ -z "${NEXUS}" ]; then
   NEXUS=false
fi

if [ -z "${LIMITS}" ]; then
   LIMITS=true
fi

if [ -z "${ENABLE_OAUTH}" ]; then
   ENABLE_OAUTH=false
fi

oc new-project $PROJECT_NAME


if [ -z "${DOCKER_USERNAME}" -o -z "${DOCKER_PASSWORD}"  -o -z "${DOCKER_EMAIL}" ]; then
    echo 'DOCKER_USERNAME and DOCKER_PASSWORD and DOCKER_EMAIL ENV variables should be provided' && exit 1
fi
oc secrets new-dockercfg dockerhub --docker-server=docker.io --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --docker-email=$DOCKER_EMAIL
oc secrets link builder dockerhub

for AGENT in java-ubuntu jenkins-tools nodejs-ubuntu nodejs6-ubuntu ruby ruby-fhcap ansible go-centos7 python2-centos7 nodejs6-centos7 svcat circleci
do
    AGENT_LABELS="$AGENT ${AGENT/-/ } openshift"

    if [ "$AGENT" = "nodejs-ubuntu" ] ; then
        AGENT_LABELS="ubuntu nodejs4-ubuntu"
    fi

    if [ "$AGENT" = "nodejs6-ubuntu" ] ; then
        AGENT_LABELS="ubuntu nodejs6-ubuntu"
    fi

    if [ "$RHNETWORK" = true ] ; then
    AGENT_LABELS="$AGENT_LABELS rhnetwork"
    fi
    if [ "$BUILD_AGENTS" = true ] ; then
       oc new-app -p GITHUB_ORG=$GH_ORG -p GITHUB_REF=$GH_REF -p AGENT_LABEL="$AGENT_LABELS" -p CONTEXT_DIR=agent-$AGENT -f $TEMPLATES_DIR/agent-build-template.yml
    else
       oc new-app -p AGENT_LABEL="$AGENT_LABELS" -p IMAGE_NAME=jenkins-agent-$AGENT -f  $TEMPLATES_DIR/agent-image-template.yml
    fi
done

if [ "$LIMITS" = true ] ; then
    oc new-app -f  $TEMPLATES_DIR/resource-limits.yaml
fi

if [ "$BUILD_MASTER" = true ] ; then
    oc new-app -p GITHUB_ORG=$GH_ORG -p GITHUB_REF=$GH_REF -f  $TEMPLATES_DIR/jenkins-build-template.yaml
else
    oc new-app -f  $TEMPLATES_DIR/jenkins-image-template.yaml
fi

if [ "${NEXUS}" = true ]; then
   oc new-app -f  $TEMPLATES_DIR/nexus3-template.yaml
fi

if [ "${ENABLE_OAUTH}" = true ]; then
  oc adm policy add-role-to-group view system:authenticated -n $PROJECT_NAME || echo "Adding view access for all users to this project failed. Users need this if they are to log-in."
fi

# Adding create project access to system:serviceaccount:$PROJECT_NAME:jenkins
oc adm policy add-cluster-role-to-user self-provisioner system:serviceaccount:$PROJECT_NAME:jenkins
oc new-app -p ENABLE_OAUTH=$ENABLE_OAUTH -p MEMORY_LIMIT=2Gi -p NAMESPACE=$PROJECT_NAME -p JENKINS_IMAGE_STREAM_TAG=jenkins:latest -f  $TEMPLATES_DIR/jenkins-template.yml
