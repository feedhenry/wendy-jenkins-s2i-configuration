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

if [ -z "${BUILD_SLAVES}" ]; then
    BUILD_SLAVES=false
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
for SLAVE in java-ubuntu jenkins-tools nodejs-ubuntu nodejs6-ubuntu ruby ruby-fhcap ansible
do
    SLAVE_LABELS="$SLAVE ${SLAVE/-/ } openshift"

    if [ "$RHNETWORK" = true ] ; then
    SLAVE_LABELS="$SLAVE_LABELS rhnetwork"
    fi
    if [ "$BUILD_SLAVES" = true ] ; then
       oc new-app -p GITHUB_ORG=$GH_ORG -p GITHUB_REF=$GH_REF -p SLAVE_LABEL="$SLAVE_LABELS" -p CONTEXT_DIR=slave-$SLAVE -f $TEMPLATES_DIR/slave-build-template.yml
    else
       oc new-app -p SLAVE_LABEL="$SLAVE_LABELS" -p IMAGE_NAME=jenkins-slave-$SLAVE -f  $TEMPLATES_DIR/slave-image-template.yml
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

oc new-app -p ENABLE_OAUTH=$ENABLE_OAUTH -p MEMORY_LIMIT=2Gi -p NAMESPACE=$PROJECT_NAME -p JENKINS_IMAGE_STREAM_TAG=jenkins:latest -f  $TEMPLATES_DIR/jenkins-template.yml
