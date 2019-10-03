---
layout: post
title: "Building containers in Jenkins with Kaniko"
tags:
- jenkins
- kubernetes
- kaniko
- scribd
---

I have a love/hate relationship with containers. We have used containers for
production services in the Jenkins project's
[infrastructure](https://github.com/jenkins-infra) for six or seven years,
where they have been very useful. I run some desktop applications [in
containers](https://gist.github.com/rtyler/767cfab0e50d7d79100b52cf0a13427a).
There are even a few Kubernetes clusters which show the tell-tale signs of my
usage. Containers are great. Not a week goes by however when some oddity in
containers, or the tools around them, throws a wrench into the gears and causes
me great frustration. This week was one of those weeks: we suddenly had
problems building our Docker containers in one of our Kubernetes environments.

I'm a strong supporter of running Jenkins workloads in Kubernetes for a myriad
of reasons, which I won't go into here. Like most organizations however, we
don't just need containers for the testing of our applications, we need to
package them into containers as well. As such, we need to build Docker
containers atop Kubernetes, which isn't as straight-forward as you might hope.

For years I have followed the same approach that [Hoot Suite describes in this
post](https://medium.com/hootsuite-engineering/building-docker-images-inside-kubernetes-42c6af855f25),
utilizing Docker's own "Docker in Docker" container (`docker:dind`). By [using
a pod with Docker-in-Docker and a Docker client
container](https://gist.github.com/rtyler/14a43e3c2c21d876d3f6315b1e82bc25),
the `Jenkinsfile` can be _fairly_ simple for building a container but certainly
not as simple as a plain `sh 'docker build rofl:copter'. With the linked
configuration above, our pipelines would typically have an explicit stage which
would build Docker containers:

```groovy
pipeline {
    stages {
        stage('Buildo Roboto') {
            agent { 
                kubernetes {
                    label 'docker'
                    defaultContainer 'docker'
                }
            }
            steps {
                sh 'docker build -t roboto:latest'
            }
        }
    }
}
```

In one of our environments, this recently **stopped working**. What's worse, is
that we still aren't entirely sure why. We migrated the Jenkins workloads from
an older Kubernetes cluster to a newer one, and afterwards this "dind" approach
to building containers started throwing incredibly confusing network and
filesystem errors. Smart money is on some host kernel or filesystem
configuration issue which is causing the "dind" container, which must run
"privileged", to function incorrectly. After an hour or two of debugging, I
said "forget this" (I may have used slightly different words) and started
looking at other options.

## Kaniko

[Kaniko](https://github.com/GoogleContainerTools/kaniko) is a curious tool from
Google which allows the building of containers on top of Kubernetes. By curious
I mean that it works fairly different from a "stock" `docker build` invocation
and required some tweaking on our end to get things working comfortably. That
said, our initial work is promising and we think we're going to be switching
fully over to it.

The biggest oddity is the need for intermediate layers in the container build,
and the resultant image to be published to repository. My colleague
hypothesized that this was likely a pattern from Google Cloud Platform, where
local VM disks might not be as fast as the container registry affiliated with a
cluster. While there are local filesystem caching options we found them too
unreliable to be useful.

For our configuration of Kaniko, we riffed on the _Scripted_ Pipeline examples
shared by my former colleagues [at
CloudBees](https://go.cloudbees.com/docs/cloudbees-core/cloud-install-guide/kubernetes-using-kaniko/),
but made some fairly significant modifications along the way. Most notably, we
decided to stand up an ephemeral Docker registry inside the Kaniko pod rather
than rely on an external registry for intermediate layers. The end product is
pushed to a well supported network-based registry, but the intermediate layers
are perfectly fine to run locally, as we have very fast disk I/O on our
Kubernetes nodes.

Kaniko's invocation is much different, and the way it treats its build context
is also a little odd. In our testing we found that the `--cleanup` flag was not
enabled _by default_ and successive calls to Kaniko would **all** mash files on
top of one another in some temp directory used by Kaniko for builds, thereby
leading to frustrating build failures. It should also be noted that the Kaniko
containers use Busybox for their shell, but it's on a fun non-standard path
(`/busybox/sh`), so shell scripts expecting `/bin/sh` or `/bin/bash` will
definitely fail!

We use Declarative Pipeline very heavily and also utilize own custom JNLP agent
image in Jenkins (custom root certificates!), so the snippet below is should be
largely portable to your environment but may need some tweaks:


```groovy
pipeline {
    stages {
        stage('Buildo Roboto') {
            agent { 
                kubernetes {
                    defaultContainer 'kaniko'
                    yamlFile 'kaniko.yaml'
                }
            }
            steps {
                /*
                 * Since we're in a different pod than the rest of the
                 * stages, we'll need to grab our source tree since we don't
                 * have a shared workspace with the other pod(s)..
                 */
                checkout scm
                sh 'sh -c ./scripts/build-kaniko.sh'
            }
        }
    }
}
```

**kaniko.yaml**
```yaml
# This pod specification is intended to be used within the Jenkinsfile for
# building the Docker containers
#
# E.g. /kaniko/executor --context `pwd` --destination localhost:5000/roboto:latest --insecure-registry localhost:5000 --cleanup
---
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: jnlp
    # Overwriting the jnlp container's default "image" parameter, this will be
    # merged automatically with the Kubernetes plugin's built-in jnlp container
    # configuration, ensuring that the pod comes up and is accessible
    image: 'our-awesome-registry/rtyler/jenkins-agent:latest'
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    # Command and args are important to set in this manner such that the
    # Jenkins Pipeline can send commands to be executed from the Jenkinsfile via
    # stdin (that's how it really works!)
    command:
    - /busybox/sh
    - "-c"
    args:
    - /busybox/cat
    tty: true
  #  Kaniko requires a registry, so we're just bringing one online in the pod
  #  for the intermediate caching of layers
  - name: registry
    image: 'registry'
    command:
    - /bin/registry
    - serve
    - /etc/docker/registry/config.yml
```


Our experience with Kaniko thus far is that it has been slower, and less
verbose in some of its output than `docker build`. Fortunately though it's been
quite reliable, and that's the key factor here!

Hopefully with the snippets of code above you won't need to spend nearly as
much time tinkering as my colleague and I did. But in the process of switching
over to Kaniko we needed to do a _lot_ of interactive debugging in Jenkins, so
I was glad to have something like an [interactive
shell](/2017/08/07/jenkins-pipeline-shell.html) in my bag of Jenkins Pipeline
tricks.


While I liked the "dind" solution, the Kaniko-based solution is just as
well. The future development for us is to hide some of this complexity with
[shared libraries](https://jenkins.io/doc/book/pipeline/shared-libraries), but
that's a project for another day!

