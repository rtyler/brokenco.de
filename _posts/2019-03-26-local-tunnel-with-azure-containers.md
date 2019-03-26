---
layout: post
title: "Making a local service public, with Azure Container Instances"
tags:
- opensource
- azure
---

Whether I'm sharing a locally developed service with a member of our globally
distributed team, or I need to integrate some cloud-based service with local
development, I frequently find the need to expose a local TCP service to the
public internet. In the past I have tried to use tools such as
[localtunnel](https://localtunnel.github.io/www/) or
[smee.io](https://smee.io), and in both cases I found them lacking; I simply
want _this_ TCP port open to the world! Yesterday afternoon I spent some time
hacking on the first version of my own little solution:
[aci-tunnel](https://github.com/rtyler/aci-tunnel).


aci-tunnel relies on the [Azure
CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
and will provision an ephemeral [Azure Container
Instance](https://docs.microsoft.com/en-us/azure/container-instances/), to
which an SSH reverse port forwarding tunnel is opened. The screencast below
shows an example of using `aci-tunnel` to expose a locally running Jenkins
environment:

<center>
<script id="asciicast-236487" src="https://asciinema.org/a/236487.js"
async></script>
</center>


## The Details

There are two components to `aci-tunnel`, the first is the [custom
container](https://hub.docker.com/r/rtyler/aci-tunnel) which is deployed into
Azure. The container is a fairly simple derivative of [Alpine
Linux](https://alpinelinux.org/) with the `openssh-server` package installed.
The daemon is also configured with `GatewayPorts yes` to enable binding a
reverse port forward onto `0.0.0.0` in the container. For added security
whenever `aci-tunnel` launches, it passes along the user's `~/.ssh/id_rsa.pub`
along to the instance which is dropped into the container as an
`authorized_keys` file. This ensures that only the user that launches
`aci-tunnel` can access the container.

The container is launched with the ports 22, and whatever the user specifies,
open to the public into Azure Container Instances.

On the local side, the `aci-tunnel` script creates the SSH tunnel with the
right arguments to construct the reverse port forwarding enabled.

Once the highly sophisticated tunnel keep-alive command has been interrupted,
terminating the SSH tunnel, `aci-tunnel` then destroys the container in Azure.

---

Wholly controlling my own tunnel infrastructure works quite well. In my early
experimentation I was able to share a local service while sitting on public
transit wifi, which was a bit slow but still allowed the HTTP and other TCP
requests to transit the link properly.

