---
layout: post
title: "Jenkins with agents on a separate Kubernetes cluster"
tags:
- jenkins
- kubernetes
---

Running untrusted CI/CD workloads in Jenkins is perhaps my favorite security
discussion. Throwing [Docker into the
mix](/2019/02/14/untrusted-docker-workloads.html) makes things even
interesting, and in some cases less secure. Today I implemented a pattern which
I have discussed with colleagues but hadn't yet had the opportunity to try: a
multi-Kubernetes cluster for Jenkins. In short, running a Jenkins master in a
cluster which acts as the control pane for it and many other services, while
running all of its workloads in an entirely separate Kubernetes cluster. For
those who know the joy of managing Kubernetes this may seem like madness, but
it does offer a number of security benefits which I would like to outline.


The Jenkins master doesn't particularly benefit from running in Kubernetes.
Its [storage requirements and access
patterns](/2017/12/01/aks-storage-research.html) are orthogonal to the
preferred stateless applications which Kubernetes excels at supporting. The
Jenkins _agents_ however are an ideal application for Kubernetes: stateless,
ephemeral, and elastic workloads which can benefit from spinning up in seconds
and running within containers.

In fact, there's a reasonable argument to be made for _not_ running Jenkins
masters in Kubernetes at all! Nonetheless I prefer to run Jenkins in Kubernetes
because of its administration and delivery benefits. The problems arise when
the master is run with the agents in the _same_ cluster, which I discussed
previously [here](/2019/02/14/untrusted-docker-workloads.html), but in short:

* Noisy-neighbor problems are abound: a pipeline which saturates CPU or network
  I/O will adversely affect the master's performance as well.
* Lack of isolation: the Jenkins master has all sorts of tasty credentials and
  should any user workload take advantage of a hole in Kubernetes, or more
  commonly, a misconfiguration allowing access to the Kubernetes API or Docker
  socket, they will be able to trivially access the master's filesystem.

The model which I have now deployed is one where a control plane cluster, with
a different set of access grants for Vault, different monitoring, alerting, and
auditing, is configured to run the Jenkins master among a number of other
important internal tools. A second cluster, which is trusted with far less
responsibility than the control plane is made available to the Jenkins
[Kubernetes plugin](https://plugins.jenkins.io/kubernetes).


### Configuring Jenkins

In order for this arrangement to work a couple prerequisites need to be squared
away first:

* The master requires a fixed JNLP port, e.g. 50000, which can be exposed
  outside the control plane for agents to properly phone home.
* The [service account](https://github.com/jenkinsci/kubernetes-plugin/blob/master/src/main/kubernetes/service-account.yml)
  configuration recommended by the Kubernetes plugin needs to be applied to the
  untrusted Kubernetes cluster.
* Ensure the Jenkins master has HTTP and JNLP properly exposed.
* Network connectivity must allow the control plane to access the API
  controller on the untrusted Kubernetes cluster. The untrusted cluster must
  also be able to access the Jenkins master via HTTP.

With these in place, the actual configuration within Jenkins is quite simple!
Much of the documentation online assumes the master and agents are running in
the same cluster, so for this set up we must deviate a _bit_ from what's
commonly done in the "Configure System" view:

* Add the untrusted Kubernetes API URL to the "Kubernetes URL" field
* Insert the untrusted cluster's server certificate key under "Kubernetes
  server certificate key" (really complex stuff here).
* Add a **Secret Text** credential with the untrusted cluster's service
  account's access token. This you will then select from the dropdown in the
  configuration as "Credentials."
* Add the correct Jenkins URL to the Jenkins master on the control plane.


With this configuration in place, the specified pod templates will start
provisioning in the untrusted cluster as soon as the configuration is saved;
neat! Adding configuration to the untrusted cluster like the [Virtual Kubelet in
Azure](https://docs.microsoft.com/en-us/azure/aks/virtual-kubelet) can greatly
improve the performance and elasticity of the agent workloads too!

Having more than one Kubernetes cluster is something anybody running Kubernetes
should consider since it [wasn't really designed for
multi-tenancy](https://blog.jessfraz.com/post/secret-design-docs-multi-tenant-orchestrator/).
Chances are, if you think Kubernetes is a solution for problems you have,
your organization is also large enough to have wildly different requirements
from your compute environment, thereby justifying multiple clusters as I am
using here.

Structuring our Jenkins environments in this way also makes it _much_ easier to
run a single large untrusted compute cluster, while having multiple Jenkins
master instances in the control plane. Providing ourselves with better resource
utilization, isolation, and easier capacity planning.

I don't necessarily recommend this approach for everybody, but once you're
already invested in Kubernetes, what's one more cluster in the mix? :)

