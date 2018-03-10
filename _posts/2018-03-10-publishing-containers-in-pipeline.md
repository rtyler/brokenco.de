---
layout: post
title: "Publishing containers with Jenkins Pipeline"
tags:
- docker
- jenkins
- pipeline
---

Pulling Docker containers from [Docker Hub](https://hub.docker.com) doesn't
require any special handling or credentials, making it quite simple to
_consume_ Docker containers in a [Jenkins Pipeline](https://jenkins.io/doc/book/pipeline).
In this blog post however, I'll describe a simple pattern which I have been
using to programmatically _publish_ Docker containers to Docker Hub from a
Jenkins Pipeline.

To the best of my current understanding, there are no environment variables or
command line arguments available for specifying an authentication credential
with Docker Hub. This has caused a number of the Pipelines I have seen to
include a `docker login` invocation directly inside of a `Jenkinsfile`. I
dislike this for a number of reasons, but generally it seems unnecessarily
hackish. Fortunately, the Docker command line supports a handy environment
variable `DOCKER_CONFIG` which allows a user to override the default path of
`~/.docker/config.json` to some place else on the filesystem. This combined
with the credentials support Jenkins has out of the box, allows this problem to
be easily solved without any additional plugins or hacks.

### Prepare credentials file

On a systems administrators workstation, the credentials file can be prepared
by running the following commands:

```
mkdir dot-docker
DOCKER_CONFIG=$PWD/dot-docker docker login
(cd dot-docker && zip -r docker-config.json.zip config.json)
```

This takes advantage of the `DOCKER_CONFIG` environment variable to create a
brand new `config.json` with my desired authentication token. Once I have this
`zip` file I can add the credential to Jenkins.

### Add credentials to Jenkins

As an administrator, one can add credentials to a global scope in Jenkins,
which the following screenshots demonstrate. Users may be allowed to add
credentials on a per-Folder level as well, but in this example I'm simply
adding credentials which are visible to all Pipelines in my Jenkins
environment.


First I navigate from the home page to **Credentials**, then click on the
**(global)** item under "Stores scoped to Jenkins". From that page I click
**Add Credentials**.

![Adding credentials to Jenkins](/images/post-images/docker-config-pipeline/adding-credentials.png)

From the "Add Credentials" page, I can then upload the `config.json.zip` I
previously created. I will also give this credential a useful,
human-understandable ID, to make it easier to reference in the future.

![Configuring credentials to Jenkins](/images/post-images/docker-config-pipeline/configure-credentials.png)

Once the credential has been saved, I can use it in my Pipeline.


### Use credentials in Pipeline

This example uses Scripted Pipeline syntax, though it's relatively trivial to
use the Docker CLI from within Declarative Pipeline syntax to accomplish
something similar.

In my Jenkins environments, I typically label agents which have a `docker.sock`
available to Jenkins as "docker". Since the Pipeline needs to first build the
image, I'm assigning the Pipeline to a "docker" agent.

Once the Pipeline begins to execute, it will first build the container, then
test it (typically using bats or shellcheck), and then publish the container to
Docker Hub.

```
node('docker') {
    def container
    stage('Build') {
        container = docker.build('zerocool:latest')
    }
    stage('Test') {
        /* test the container */
    }
    stage('Publish') {
        withCredentials([zip(credentialsId: 'docker-config',
                                  variable: 'DOCKER_CONFIG')]) {
            echo 'Pushing to Docker Hub'
            container.push()
        }
    }
}
```

While Declarative Pipeline syntax doesn't yet support the use of Zip credentials in
the `environment {}` directive
([JENKINS-50021](https://issues.jenkins-ci.org/browse/JENKINS-50021)), but the
`withCredentials` step can be used with Declarative syntax.


Using the above steps, it's easy to start building more and more advanced
continuous delivery pipelines for Docker containers, preventing rogue
developers (like myself) from yolo-pushing containers straight from their
laptops to Docker Hub :)
