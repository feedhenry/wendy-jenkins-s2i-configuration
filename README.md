# wendy-jenkins-s2i-configuration
The s2i configuration based on top of openshift/jenkins

While the repository might seem quite bare, it holds configuration for building the jenkins container to host CI/CD for the FeedHenry platform,
as referenced from [openshift/jenkins Readme|https://github.com/openshift/jenkins#installing-using-s2i-build]

You should be able to build it by running:

```
$ s2i build https://github.com/feedhenry/wendy-jenkins-s2i-configuration.git openshift/jenkins-1-centos7 jenkins_wendy
```

To deploy the configuration to the openshift, it is prefferable to utilize the template

```
oc create -f jenkins-template.yml
``` 

This should create a new template named 'jenkins-wendy' on your openshift, based on the jenkins persistent template,
but with added build-config that is capable of updating the image based on the contents of this repository.