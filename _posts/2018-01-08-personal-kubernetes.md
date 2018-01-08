---
layout: post
title: "Provision a personal Kubernetes in 3 minutes on Azure"
tags:
- kubernetes
- azure
---

At my previous company one frequent request made by developers was along the
lines of "I want to be able to run a development stack on my machine." Frankly,
I never understood this desire, and still don't. While I would agree that my
laptop is underpowered, running a stack of JVMs and other applications, in
addition to a web browser, would bring most machines to a crawl. An ideal
alternative, is to simply operate a personal Kubernetes environment in a public
cloud. Fortunately, that is now a genuinely __simple__ task.


Last year the team at Microsoft working on Azure introduced "AKS", a managed
[Kubernetes](https://kubernetes.io) environment. They also introduced [Cloud
Shell](https://azure.microsoft.com/en-us/features/cloud-shell/) which allows
for a quick shell in the Azure portal for running authenticated commands. What
they didn't talk too much about, was that Cloud Shell comes pre-baked with:

* `az` the Azure CLI tool, already authenticated.
* `kubectl` the Kubernetes command-line interface.
* `helm` a package manager for Kubernetes.

With both of these, it's **absurdly** easy to provision a Kubernetes
environment in under 3 minutes.

* Create a resource group: `az group create -n <name> -l <location>`
* Create a Kubernetes environment: `az aks create -n <name> -l <location> -g
  <group> -k <kubernetes-version> --node-count <count>`


Below is an example I just ran:

```
tyler@Azure:~$ az group create -n unethicalblogger -l eastus
Location    Name
----------  ----------------
eastus      unethicalblogger
tyler@Azure:~$ az aks create -n ub -g unethicalblogger --node-count 1 --generate-ssh-keys -k 1.8.2 -l eastus
SSH key files '/home/tyler/.ssh/id_rsa' and '/home/tyler/.ssh/id_rsa.pub' have been generated under ~/.ssh to allow SSH acces
s to the VM. If using machines without permanent storage like Azure Cloud Shell without an attached file share, back up your
keys to a safe location
AAD role propagation done[############################################]  100.0000%
DnsPrefix                   Fqdn                                                      KubernetesVersion    Location    Name
  ProvisioningState    ResourceGroup
--------------------------  --------------------------------------------------------  -------------------  ----------  ------  -------------------  ----------------
ub-unethicalblogger-be5308  ub-unethicalblogger-be5308-ccbb80df.hcp.eastus.azmk8s.io  1.8.2                eastus      ub  Succeeded            unethicalblogger
```

![Provisioning with Cloud Shell](/images/post-images/provision-kubernetes/cloud-shell.png)


---

In the above example I only deployed on "node" (Virtual Machine) which means
the Kubernetes environment is going to cost about $50/month. Of course, I can
scale that up with `az aks scale` if I need more capacity, but for small
personal projects, this is more t han enough.

With my own personal Kubernetes provisioned, I can start dropping Helm charts
into the environment without wasting any of laptops resources.

Quite fancy!
