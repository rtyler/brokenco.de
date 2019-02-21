---
layout: post
title: "Jenkins Pipeline ♥ Docker"
tags:
- jenkins
- pipeline
- docker
---

As the number of different ways to configure Jenkins approaches infinity, I
have come to appreciate one pattern in particular as generally _good_. When I
first started the draft of this blog post, _three years ago_ (!), I wanted to
share that by coupling Jenkins and Docker together I finally had the CI/CD
server I had been waiting for. In the past few years, Docker has
increasingly become the default environment for Jenkins, and rightfully so. In my [previous
post](/2019/02/14/untrusted-docker-workloads.html) I mentioned some of the
security pitfalls of using Docker in an untrusted CI/CD context, like that
which we have in the Jenkins project. Regardless of trusted or untrusted
workloads, I still think Docker is a key piece of our CI/CD story, and here I
would like to outline why we need Docker in the first place.

To understand Docker's popularity, it's important to consider the problems
which Docker solves.  Some of the things I have historically found difficult
around designing and implementing CI/CD processes have been:

* **Managing environmental dependencies**: for various Ruby, Python and other
  non-JVM-based workloads there have *always* been system dependencies that
  build machines have needed. One build needs `libxml2-dev` while another
  needs `zlib-dev` while another requires a specific Linux and OpenSSL version
  combination. Some dependencies like
  [nokogiri](https://github.com/sparklemotion/nokogiri) try to hand-wave these
  dependencies away by embedding the compilation of these system libraries into
  their installation process. For CI, this not only introduces another set of
  build-time variables to concern yourself with, but a myriad of security
  concerns. At a previous employer who will remain nameless, we ended up
  having to split our entire Jenkins agent pool because we had one subset of
  projects which depended on MySQL 5.1 and another which needed MySQL 5.5. Since
  we did not have the tooling to move the dependencies closer to the
  applications, we had to manage these system dependencies in the release
  engineering team. Suffice it to say, this was an unpleasant state of affairs.
  A problem which is virtually nonexistent with Docker-based environments.
* **Managing service dependencies**: many of the workloads I have worked with
  in the past have been web applications. These services invariably need a
  Redis, a Memcached or a MySQL running around in the background to execute tests
  of any non-trivial scope. As time wears on, services (for better or worse) end
  up relying on version-specific installations of these background processes. To
  complicate matters more, each build *must* have a pristine state in these
  background processes. In some cases this might mean no state whatsoever, in
  others it might mean some "fixtures" pre-loaded into the database(s).
  This is also one area where `docker-compose` is absolutely stellar, and should
  be used gratuitously to incorporate external service dependencies into the
  build process directly.
* **Managing performance**: ideally, as an application grows, more test cases
  get added. More test cases mean longer build times which can lead to
  developer frustration, or worse, developers attempting to circumvent or reduce
  reliance on the CI/CD server. With automation servers like Jenkins, one
  might have a large pool of machines waiting idle for workloads, but the
  challenge is mapping a project's test execution to that pool of machines. By
  utilizing Docker for the execution environment, I have found it much easier to
  build out a large homogenous pool of agents which can be ready for highly
  parallelizable workloads, without running into too much trouble from an
  administration standpoint. Quickly getting back to a pristine state typically
  involves simply stopping and restarting a container. With container
  orchestrators like Kubernetes, Docker Swarm, AWS Elastic Container Service, or
  Azure Container Instances, it's possible (and really cool!) to enable huge
  amounts of auto-scaled compute for CI/CD workloads. Which, by their very nature
  are very elastic, especially just before lunch time and the end of the day!


This tutorial has a quick [Node-based Jenkins
Pipeline](https://jenkins.io/doc/tutorials/build-a-node-js-and-react-app-with-npm)
example, but below I've included a very simple example of how _easy_
incorporating Docker into a Pipeline can be:

```groovy
pipeline {
    agent {
        docker {
            image 'node:9-alpine' 
            args '-p 3000:3000' 
        }
    }
    stages {
        stage('Build') { 
            steps {
                sh 'npm install' 
            }
        }
        stage('Test') { 
            steps {
                sh 'npm run test' 
            }
        }
    }
}
```

While there are a number of CI/CD workloads where Docker containers might not be
helpful: mobile build/test, embedded, or for non-Linux based applications. But
should your workload be Docker-compatible, I cannot highly recommend using
Docker with Jenkins Pipeline!
