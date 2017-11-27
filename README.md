# wendy-jenkins-s2i-configuration
The repository itself holds configuration for building the jenkins container to host CI/CD for the FeedHenry platform,
as referenced from [openshift/jenkins Readme|https://github.com/openshift/jenkins#installing-using-s2i-build]

You should be able to build it by running:

```
$ s2i build https://github.com/feedhenry/wendy-jenkins-s2i-configuration.git openshift/jenkins-2-centos7 jenkins_wendy
```

# The Slave Configuration

## Image Stream

In the template there is an image-stream:

```
- apiVersion: v1
  kind: ImageStream
  metadata:
    name: ${JENKINS_SERVICE_NAME}-slave-ruby
    annotations:
        slave-label: ruby
    labels:
      role: jenkins-slave
```

The `label` and `annotation` serve to give information to the jenkins build,
that then populates the slave configuration to use this image-stream for all slaves with
label `ruby`, i.e. so that you can write pipeline scipts in jenkins:

```
node ("ruby") {
   sh 'ruby --version'
}
```

The image-stream itself doesn't define the slave image. If you wanted to add another,
with a specific docker image in mind, you can:

```
  kind: ImageStream
  metadata:
    name: ${JENKINS_SERVICE_NAME}-slave-node
    annotations:
        slave-label: node
    labels:
      role: jenkins-slave
  spec:
    tags:
    - from:
        kind: DockerImage
        name: openshift/jenkins-slave-nodejs-centos7
      name: latest
```

## Build config

Better idea though is, to leave the image stream as is, and have a separate build-config to fill it:

```
- apiVersion: v1
  kind: BuildConfig
  metadata:
    name: ${JENKINS_SERVICE_NAME}-slave-ruby
  spec:
    output:
      to:
        kind: ImageStreamTag
        name: ${JENKINS_SERVICE_NAME}-slave-ruby:latest
    runPolicy: Serial
    source:
      git:
        uri: https://github.com/feedhenry/wendy-jenkins-s2i-configuration
        ref: master
      contextDir: slave-ruby
      type: Git
    strategy:
      dockerStrategy:
          noCache: true
      type: Docker
    triggers:
    - type: ImageChange
    - type: ConfigChange
```

This way you can keep your up-to-date from within you openshift just by issuing rebuild on
this build config. The configuration takes master of feedhenry/wendy-jenkins-s2i-configuration
and builds the docker file in slave-ruby directory.
Then it pushes this new image to the defined image-stream.

## The Docker images

Our current template is more or less copied from https://github.com/openshift/jenkins/tree/master/slave-nodejs and edited.
This means we use centos7 and software collections. This might change in the future, but currently,
having the centos base that has solved the jenkins connection is a plus.

If you want to test the image locally, you can:

```
export IMAGE_NAME=test1
cd slave-ruby
docker build -t $IMAGE_NAME .
./test/run
```

# Deployment

To deploy the configuration to the openshift, it is prefferable to utilize the provided templates
We have created a shell-script that creates a project and deploys the templates in roder

```
PROJECT_NAME=wendy ./scripts/deploy_jenkins.sh
```

This should create a new project named 'wendy' on your openshift, and populate it with slave images,
the pre-built jenkins image based on this repo-config, and deploy it.

If you openshift supports it, the jenkins service will utilize OpenShift OAUTH provider for authorization,
otherwise you should be able to login with **admin**:**password**

If you plan to test changes to slaves or configuration, you can configure the
 deploy script with environment variables to build either the master or slaves
 or both, before deploying:

```
PROJECT_NAME=wendy BUILD_MASTER=true BUILD_SLAVES=true ./scripts/deploy_jenkins.sh
```

This will make openshift to rebuild all the images referenced in this repo,
and populate the images this way.

If you want to deploy the nexus service to speed up maven builds, you can:

```
PROJECT_NAME=wendy NEXUS=true ./scripts/deploy_jenkins.sh
```

# Standalone slave configuration

All of the slaves have option to connect directly to any jenkins instance that has the jenkins-swarm plugin installed.
I.e you can do:

```
docker run \
-e LABELS=test \
-e JENKINS_USER=admin-admin \
-e JENKINS_PASSWORD=186db226af8ce23ffe1a2b8c1b565a20  \
-e JENKINS_URL=https://jenkins-asaleh-try-auth.tooling3.skunkhenry.com/  \
-e JENKINS_SLAVE_SERVICE_HOST=tooling3.skunkhenry.com \
-e JENKINS_SLAVE_SERVICE_PORT=31036 \
-e JENKINS_SWARM=true \
--name=slaves \
docker.io/fhwendy/jenkins-slave-base-ubuntu:RHMAP15237
```

The swarm plugin will only be used if JENKINS_SWARM=true is passed to the environment. Otherwise it will use the default behaviour.
