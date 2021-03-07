---
layout: post
title: Software-defined networks with FreeBSD Jails
tags:
- freebsd
- security
---

As a comprehensive operating system FreeBSD never ceases to impress me, the
recent iterations of [FreeBSD
Jails](https://docs.freebsd.org/en/books/handbook/jails/) as an example have been an
absolute joy to use. The introduction of the
[vnet(9)](https://www.freebsd.org/cgi/man.cgi?query=vnet&apropos=0&sektion=0&manpath=FreeBSD+12.2-RELEASE+and+Ports&arch=default&format=html)
network subsystem has completely transformed what I had originally thought
about software-defined networking. My previous exposure to the concept of
[software-defined
networking](https://en.wikipedia.org/wiki/Software-defined_networking) was
through both [OpenStack](https://www.openstack.org/) and Docker, two very
different approaches to the broad domain of "SDN". FreeBSD's `vnet` system has
resonated most strongly with me and has allowed me some measure of success in
deploying real production-grade virtualized networks.

One of the first blog posts I read was [this post by klara
systems](https://klarasystems.com/articles/virtualize-your-network-on-freebsd-with-vnet/),
which despite being painfully devoid of diagrams, does a fairly good job of
introducing the vnet feature set. In short, vnet allows jails to each have their
own isolated networking stack _including_ the ability to assign virtual or
**hardware interfaces** to the jail. I cannot overstate how much of a super-power this is.

Consider an example where you want to do some testing of network security
tooling whether your firewall rules, intrusion detection, etc. You can set up a
bridge device to act as a "virtual switch" along with
[epair(4)](https://www.freebsd.org/cgi/man.cgi?query=epair&apropos=0&sektion=0&manpath=FreeBSD+12.2-RELEASE+and+Ports&arch=default&format=html)
devices to act as "virtual patch cables" to create a completely virtualized
network as diagrammed below:


```
+---------------------+
| Host                |
|                     |
| +-----------------+ |
| | ixl0 (ethernet) | |  +-------------+
| +-----------------+ |  | snort-jail  |
|                     |  |             |
| +---------+     +------> epair1b     |
| | bridge0 |     |   |  +-------------+
| |         |     |   |
| | epair1a +-----+   |  +-----------------+
| | epair2a +------+  |  | some other jail |
| |         |      |  |  |                 |
| +---------+      +-----> epair2b         |
+---------------------+  +-----------------+
```

In the setup described above, `epair1a` and `epair2a` would not have IP addresses:

* `bridge0`: could be set up with `10.0.100.1`
* `epair1b`: would then be assigned `10.0.100.2`
* `epair2b`: would also take `10.0.100.3`

If it was desired to have `snort-jail` be able to route out to the network
connected on the host's `ixl0` interface, then the host would need to be
configured as a
[gateway](https://docs.freebsd.org/en_US.ISO8859-1/books/handbook/network-routing.html)
and `snort-jail` would the treat `10.0.100.1` as its default router.

Contrary to my experiences with Docker-based networking this is natively part
of the FreeBSD network stack, rather than iptables-style smoke and mirrors. As
a result, I have found this set up not only to be incredibly reliable but also
_very_ nestable. It's totally feasible to nest these virtualized network setups
to create completely isolated test networks or all manners of different network
topologies for development or production workloads.

On top of that, because you can assign **hardware interfaces** to Jails, it is
also possible to take another NIC (e.g. `ixl1`) and assign it into a Jail such
that the Jail could manage its own network, `pf`, and gateway configuration,
completely separate from the jail host. Thereby allowing a fairly strong
segmentation of _physical_ networks by way of the FreeBSD vnet jails
infrastructure.


**So cool!**


For my own purposes I have been using an approach which is much better
documented in [this page](https://alpha.pkgbase.live/howto/jails.html) for
isolating network services. For example, I run a [Tor](https://torproject.org) relay inside
of a Jail with an isolated network, and then use
[pf](https://www.freebsd.org/cgi/man.cgi?query=pf&apropos=0&sektion=0&manpath=FreeBSD+12.2-RELEASE+and+Ports&arch=default&format=html)
on the jail host to restrict that network from ever reaching out onto my LAN.
It can only talk to the public internet, no other virtual or physical networks.
From a security standpoint this _should_ mean even a compromise of the Tor
daemon would limit the blast-radius to that jail alone.

Since there are few practical limits on how many bridges and `epair` devices I
can create, I have taken the path of creating multiple independent networks for
Jails which don't need to talk to each other or the same set of shared
resources. This gives me some level of comfort when trying out new pieces of
software or sharing services with other users that have varying trust profiles.


Overall I am immensely pleased with what has been possible between FreeBSD,
Jails, and `pf` to create rich topologies of software-defined networks for my
production and development needs. If you are curious to learn more, [this blog
post](https://klarasystems.com/articles/virtualize-your-network-on-freebsd-with-vnet/)
and [this page](https://alpha.pkgbase.live/howto/jails.html) are definitely worth reading!
