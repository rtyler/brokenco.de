---
layout: post
title: "Sailing towards frowntown with minikube --vm-driver=none"
tags:
- kubernetes
- minikube
- opinion
---

Kubernetes is so hot right now. So hot. Not to brag, but the
[Jenkins](https://jenkins.io) has been using Kubernetes for a couple years, in
production even! While Kubernetes is certainly worth the hype, so hot, I have
traditionally done all of my development with Kubernetes resources using a
[personal Azure Kubernetes Service
instance](/2018/01/08/personal-kubernetes.html) rather than running
[minikube](https://github.com/kubernetes/minikube) locally. Recently I took
some time to do some hobby-hacking, which included some Kubernetes work, and
ended up revisiting using minikube on my local machine. It went..._okay_.

By default, `minikube` tries to utilize a local hypervisor like xhyve (macOS),
VirtualBox, or KVM (Linux). There is also a promising option:
`--vm-driver=none` which utilizes the local `dockerd` already running on a
Linux system. For those like me, running Linux as their primary operating
system, the `none` option appears to be a nice compact way to run a
single-local-node of Kubernetes. Unfortunately, the theory of running minikube
with no VM is a bit nicer than the reality of it.

## Networking

When configuring minikube for the first time, a number of certificates are
generated and stored for accessing the Kubernetes cluster with `kubectl`. What
I did not notice right away was that these certificates embed my IP
(`wlan0`) address into the certificate and subsequently generated
`~/.kube/config`. 


```
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/tyler/.minikube/ca.crt
    server: https://192.168.1.59:8443
  name: minikube
```

The reason I didn't notice this right away was because it
only proved to be a problem once I joined a different network, with a wildly
different subnet, and all of a sudden `kubectl` was no longer able to access my
Kubernetes environment.

`minikube` does provide an `update-context` command which claims to "Verify the
IP address of the running cluster in kubeconfig." For me this updated the
`~/.kube/config` but didn't re-generate or update the certificates in the
cluster itself, so while I could re-connect, the certificates would no longer
authorize against the environment.

Oops!

Sadly, I still haven't figured out how to resolve this.


## Management

When minikube starts without a hypervisor, it installs a local `kubelet`
service on your host machine, which is important to know for later.

Right now it seems that `minikube start` is the only command aware of
`--vm-driver=none`. Running `minikube stop` keeps resulting in errors related
to `docker-machine`, and as luck would have it also results in none of the
Kubernetes containers terminating, nor the `kubelet` service stopping.

Of course, if you wish to actually terminate minikube, you will need to execute `service
kubelet stop` and then ensure the k8s containers are removed from the output in
`docker ps`.


## Side Effects

Aside from a bunch of other containers running, there are a few side effects
from running minikube. I found that the dashboard pod failed to load or connect
to some of the other pods in the cluster, and as a result infinitely spammed
`/var/log/syslog` with errors along those lines. Over a couple days, my
uncompressed syslog bumped up from a few hundred kilobytes to a hundred or so
megabytes.

The most notable side effect of having minikube running locally however, was
that my Docker images kept disappearing! It turned out to be due to one of the
`kubelet` service's features: garbage collecting Docker images which are not
being used after some time delay.  Let's say you ran `docker build` in your
application directory, but then before running a test you went to grab a cup of
coffee. By the time you would return, depending on your brew time, executing
`docker run` with that container would fail because the container no longer
exists!

Oops!

While this behavior is really useful when Kubernetes is the only thing talking
to the Docker daemon, it's pretty stinking annoying when you're using `dockerd`
for other work.

To stop this, at least temporarily, stop the `kubelet` service with:
`service kubelet stop` when you're not exclusively using `minikube`.  As noted by
those who maintain the minikube repo (https://github.com/kubernetes/minikube/blob/master/docs/vmdriver-none.md)


---

Kubernetes is a really wonderful technology, so hot right now. And I wish the
local development experience were a bit nicer, especially for those of us who
already have a nice Docker environment already up and running. Unfortunately, I
think `minikube` is a bit too untested, and perhaps a bit too cavalier, with a
"stock" Linux system. For now, it's probably best to keep in a virtual machine,
despite the networking and performance headaches that come along with that.

At least with a virtual machine, if something goes wrong, it's easy to delete.

Nuke it from orbit, the only way to be sure.
