#!/bin/sh -xe
export GH_ORG=feedhenry
export GH_REF=master


if [ -z "${BUILD}" ]; then 
   BUILD_TEMPLATES=false
else 
   BUILD_TEMPLATES=true
fi

oc new-project $PROJECT_NAME
for SLAVE in java-ubuntu nodejs-ubuntu ruby ruby-fhcap
do
    if [ "$BUILD_TEMPLATES" = true ] ; then
       oc new-app -p GITHUB_ORG=$GH_ORG -p GITHUB_REF=$GH_REF -p SLAVE_LABEL=$SLAVE -p CONTEXT_DIR=slave-$SLAVE -f slave-build-template.yml
    else
       oc new-app -p SLAVE_LABEL=$SLAVE -p IMAGE_NAME=jenkins-slave-$SLAVE -f slave-image-template.yml
    fi
done

if [ "$BUILD_TEMPLATES" = true ] ; then
    oc new-app -f jenkins-build-template.yaml
else
    oc new-app -f jenkins-image-template.yaml
fi
oc new-app -p MEMORY_LIMIT=2Gi -p NAMESPACE=$PROJECT_NAME -p JENKINS_IMAGE_STREAM_TAG=jenkins:latest -f jenkins-template.yml