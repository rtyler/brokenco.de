---
layout: post
title: "Updated Debian packages for MirrorBrain"
tags:
- mirrorbrain
- jenkins
---

The [Jenkins project](https://jenkins.io) has long used
[Mirrorbrain](http://mirrorbrain.org/), a great piece of software for running a
high-traffic download site using redirect mirrors. We use it to transparently
delegate traffic to a network of donated mirrosr, for downloading our Debian,
Red Hat, and other packages of Jenkins _and_ all of our plugins.

MirrorBrain was not originally packaged properly for our distribution of
Ubuntu, and so long long ago I utilized the [openSUSE Build
Service](https://build.opensuse.org) (OBS) to provide packaging and a download
repository for MirrorBrain on Ubuntu. With the recent distribution upgrade we
rolled out across our production infrastructure the packages broke, much to my
chagrin.

I dove back into using OBS and ended up re-packaging MirrorBrain for modern
Debian-based distributions. On a lark, I sent a request upstream to help
maintain [the official packages for MirrorBrain](https://build.opensuse.org/project/show/Apache:MirrorBrain) and it _was accepted_.

Somehow I am now a maintainer of the MirrorBrain packaging and now MirrorBrain
can be easily installed on newer Debian and Ubuntu distributions! You can find
the appropriate download repository for your distribution
[here](https://build.opensuse.org/repositories/Apache:MirrorBrain), and if you
find anything wrong with the packages, please let me know via email to
`rtyler@`!

