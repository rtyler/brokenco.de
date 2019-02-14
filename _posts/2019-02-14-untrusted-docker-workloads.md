---
layout: post
title: "Securely running Docker workloads in your CI/CD environment"
tags:
- cicd
- jenkins
- docker
- opinion
- security
---

Over the past few years, the topic of architecture and security for CI/CD
environments has become among my favorite things to discuss with Jenkins users
and administrators. While security is an important consideration to include in
the design of _any_ application architecture, with an automation server like Jenkins,
security is crucial in a much more fundamental way than a traditional
[CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) app.
Walking that fine line between enabling arbitrary use-cases from developers and
preserving the integrity of the system is a particularly acute problem for
CI/CD servers like Jenkins.

In one of my previous "[old man yells at cloud](/2017/08/07/jenkins-pipeline-shell.html)"
posts I concluded with:

> People sometimes joke that Jenkins is "cron with a web UI", but I will
> typically refer to it as "remote code execution as a service." A statement
> which garners some uncomfortable laughs. If you're not thinking of CI/CD
> systems like Jenkins, GoCD, Bamboo, GitLab, or buildbot as such, you might be
> sticking your head in the proverbial sand, and not adequately addressing some
> important security ramifications of the tool.

In this post I would like to outline some of the architectural and
security-oriented decisions I made for Docker-based workloads when rebuilding
[ci.jenkins.io](https://ci.jenkins.io/blue/), the
[Jenkins](https://jenkins.io/) project's own Jenkins environment, in 2016.


### Requirements

For the vast majority of users, I think a Jenkins environment that doesn't
support Docker is a glaring omission. Supporting container-based workloads in a
CI/CD environment, even if a production environment does _not_ utilize Docker,
allows such a tremendous amount of flexibility for developers to _own_ their
build and test environment.

The Docker horse has been beaten to death at this point; I don't have much
interest in convincing people to adopt it, any more than I have a desire to
convince people to adopt writing tests, use source control, or any other
sensible development practices circa 2018.

Within the Jenkins project, our CI infrastructure requirements were/are
loosely:


* Must be able to support elastic workloads to handle the periodic "thundering
  herds" of re-testing Pull Requests. Some repositories, such as the [git plugin](https://github.com/jenkinsci/git-plugin)
  have a number of outstanding Pull Requests which must be re-tested when
  commits are merged to the master branch, in order to ensure the commit status
  (green checkmark) is still valid, and master is always passing tests. In
  practice this means that a single merged Pull Request could create upwards of
  50 Pipeline Runs at once.
* Should reduce, or eliminate, the potential for Pipeline Runs to contaminate
  each other's workspaces, or adversely affect the Docker environment for a
  subsequent Pipeline Run using that daemon.
* Must allow developers to specify their own execution environment, in effect,
  a developer must be able to "bring their own container" without prior
  approval by an administrator.
* Potential "container escapes" must not seriously impact the performance,
  security, or stability of other parts of the environment. While these are
  rare, they [do
  happen](https://www.openwall.com/lists/oss-security/2019/02/11/2) as was the
  case with this year's CVE-2019-5736


I don't believe these to be necessarily unique requirements to the Jenkins
project, but rather general purpose requirements for any sizable organization.
That is to say, once a team or organization grows past the phase of "everybody
is admin" trust, these requirements likely apply.

For purposes of discussion, imagine the following Pipeline is our typical
workload, one which specifies its Docker environment, and then runs scripts
inside of that environment.

```groovy
pipeline {
    agent { docker 'maven:3' }
    stages {
        stage('Build') {
            steps { sh 'mvn' }
        }
    }
}
```

### Options

The learning curve around the options in the container ecosystem can be quite
steep, there are a plethora of options and not all of them are safe, secure, or
reliable for "untrusted" workload requirements. The inventory in this post is
**not comprehensive** but rather a listing of options which I have personally
evaluated.

#### Docker: the easy, but not the smartest way

The most common pattern I have seen from Jenkins users in the wild has been to
use the Docker daemon on the Jenkins master instance to run their workloads.
For untrusted workloads this is a **bad idea**. Setting aside the potential
performance impacts of running workloads on the same machine as the Jenkins
master, let's focus on the security aspect.

Jenkins stores all of its configuration, logs, and secrets on disk, usually in
`/var/lib/jenkins`. While secrets are encrypted on disk, elsewhere on the
file system, the key for decrypting those secrets is stored. In essence, this
means that once an untrusted user has access to the Jenkins master's file
system, it's as good as compromised.

When the Docker daemon (`dockerd`) runs, it is effectively running as root. If
a user can launch a Docker container, that is functionally equivalent to
granting them root access to the machine. I do not consider this a bug in
Docker however, replicating the entire access control subsystem from Linux in
`dockerd` would be impractical.

Plainly put, it is not safe to allow untrusted workloads, Docker or otherwise,
to execute on the Jenkins master's instance. We regularly advise people to set
the number of executors for the master node to zero to help avoid this security
pothole.


It _is_ possible to configure Docker-based agents in Jenkins, which run on the
master, but are not user-defined in Jenkins Pipeline. These _can_ be safer, but
are still susceptible to container escape vulnerabilities, and _will_ result in
performance problems as workloads and the Jenkins master compete for memory and
compute time.

#### Docker Swarm

Another option considered was using a scalable [Docker Swarm](https://docs.docker.com/engine/swarm/)
cluster for running the untrusted workload containers. What is interesting
about Docker Swarm, is that it can be relatively easy to enable a cluster of
machine which have the Docker engine installed. At the time when our
environment was built out, it was however not mature enough for me to trust it.
In addition, it didn't quite match our infrastructure model. At no point have
we had latent capacity waiting  to be enabled, but rather we have had a
strongly managed environment between Puppet and Jenkins.


Docker Swarm, and Kubernetes for that matter both have a usability flaw in
Jenkins Pipeline. In order to use the `agent { docker 'maven:3' }` syntax,
Jenkins needs to be able to execute `docker run` _somewhere_. But that
somewhere must already be running a Jenkins agent. Unfortunately Jenkins is not
smart enough at the moment to see that the Pipeline wants to run an image and
use a configured orchestration engine, without the user needing to consider
what Docker-in-Docker, or JNLP agent hacks might be necessary. This problem
gets even more hairy if your workloads need to _build_ Docker containers at any
point. This topic is one I have devoted substantial effort to, and am happy to
discuss separately, but suffice it to say for this blog post: Jenkins and
orchestrators is suboptimal at best right now.


#### Kubernetes

Kubernetes is another option considered at the time. The Jenkins project
currently runs a non-trivial amount of infrastructure in Kubernetes in
production, and I am quite pleased with it. I still do not believe it is the
appropriate basis for a CI infrastructure like ours, wherein we must run
untrusted workloads.

First considering the performance: Kubernetes itself is relatively
low-overhead, but tends to operate with a fixed-size cluster. While there are
options in some public clouds to auto-scale Kubernetes, I don't frequently see
that enabled. From my experience, CI workloads are incredibly compute heavy. At
one point our cloud provider contacted us to let us know that they believed
some of our dynamically provisioned VMs were compromised by cryptominers. From
their perspective, the behavior of a high-intensity Jenkins build looked
similar to cryptomining! The manner in which Kubernetes schedules containers
works very well for different types of workloads, packing one compute heavy
container on a node with other containers which do not have the same
requirements allows for an ideal and efficient use of compute resources. When
everything will heavily utilize one dimension, such as the CPU of the
underlying computer, the benefits of Kubernetes' resource allocation dwindle. 

From the security standpoint, I believe Kubernetes can be used safely for CI
workloads. The mistake that I most frequently see is mixing the "management
plane" (Jenkins master) with user-defined workloads (agent pods). Running both
on the same Kubernetes infrastructure is a 
fundamental failure of isolation and **will** result in compromise. Any
eventual bypass may allow access to the underlying Kubernetes API, from there
it would be trivial to schedule new workloads, or attach the persistent volume
from the Jenkins master. I do not consider this to be a theoretical problem, as
my understanding of Kubernetes is that it was never designed to be a multi-tenant
orchestrator. [Jess Frazelle has an interesting design for one
however!](https://blog.jessfraz.com/post/secret-design-docs-multi-tenant-orchestrator/)

Another security wrinkle arises if the cluster needs to support _building_ of
Docker containers. To the best of my knowledge, this requires either
Docker-in-docker hacks, or more commonly, pass-through access to the Kubernetes node's
Docker socket. Once that socket has been passed through from the node to an
untrusted container, it's a relatively trivial exercise to use that socket to
access and peek at any other workload on that specific Kubernetes node. As
alluded to above in the case of using Docker on the Jenkins master: **never allow untrusted workloads access to a trusted Docker
socket**.


This is not to say that you should never use Kubernetes with Jenkins. For
internal deployments, with different threat models and trust characteristics,
Jenkins and Kubernetes can work quite successfully together. As is usually the
case with security and infrastructure design, the devil is in the details.


#### Actually Docker-in-Docker

Running Docker inside of Docker on top of the orchestrators described above was
something I considered as well. At the time of the design of ci.jenkins.io, the
stability of Docker-in-docker approaches was highly questionable. [This may be
different
nowadays](https://medium.com/hootsuite-engineering/building-docker-images-inside-kubernetes-42c6af855f25),
and might be worth reconsidering for newer system designs.


#### Docker: the hard, but perhaps the most reliable way


The design that I ultimately chose, which is still in place today, I think of
as "Docker the hard way." Jenkins dynamically provisions fresh VMs in the
cloud, installs Docker on them, and then launches its agent. This has numerous
benefits from a security, isolation, and performance standpoint. Workloads get
dedicated high-performance compute capacity, and if any of those workloads
tries to do something nefarious, the impact is isolated to that single machine
which is usually deprovisioned shortly after the workload has finished
executing.


This isolation does come at a cost however. The time-to-available can be
multiple minutes, meaning the cluster cannot rapidly grow when that "thundering
herd" problem occurs. The actual infrastructure cost is also non-trivial. Our
Jenkins infrastructure is the most costly part of our infrastructure right now.
While anything "big and beefy" is going to be expensive in the cloud, the
time-overhead to request, provision, and de-provision has a real financial
impact.

---


Running untrusted workloads in a CI environment is not a requirement isolated
to large environments like the Jenkins project. Most organizations really
should treat their CI environment as if it were "untrusted", not because there
are malicious actors internally, but the same design considerations to minimize
the impact of malice, also have the beneficial effect of preventing errors or
incompetence from destabilizing the CI system. If a new developer in the
organization, can accidentally brick the CI/CD environment, that will most
certainly be disruptive and costly for the org.

There are other concerns which are not accounted for in this post, which I
would like to make special mention of as they're worth considering:

* Runaway resource utilization: presently in Jenkins it is rather difficult to
  globally restrict how much time, or resource, a Jenkins Pipeline is able to
  allocate. We have strived to make it easy to developers to do the right thing,
  but must remain vigilant, keeping an eye out for Pipelines which have locked
  up or are stuck in infinite loops. While rare, these still can tie up
  resources, and time is money when operating in the public cloud!
* Secrets management with Pipelines: inevitably some Pipelines will need an API
  token, or credential in order to access or push to a given system. Jenkins
  has some support for separating credentials but the audit and access control
  functionality is currently lacking, making it difficult to delegate trust in a
  mixed trust environment. An easy workaround is to put trusted credentials in
  another Jenkins environment, which is exactly what we do in the Jenkins
  project, but is a worthy subject of another post entirely.


Future iterations on our environment will likely incorporate a mixture of VMs
and container services to balance speed and security more effectively. Not all
workloads need Docker, some just need Maven, Node, etc. More efficiently
balancing the disparate requirements of the hundreds of Jenkins project
repositories which rely on ci.jenkins.io is slated for "version 2" of this
infrastructure. :)


Overall, using containers in any CI/CD environment, at this point I would
consider an absolute must. The challenge for system administrators, as it
usually ends up, is balancing cost, security, and flexibility for users.

