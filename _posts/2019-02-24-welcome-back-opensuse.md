---
layout: post
title: "Once again running openSUSE"
tags:
- opinion
- linux
- opensuse
---

Linux has now been my primary desktop operating system for the better part of
the last decade. Originally I had used [openSUSE](https://www.opensuse.org) but
found myself migrating to Debian for a number of reasons. I recently jumped
back over to openSUSE, and have been impressed once again with the overall
quality of the entire distribution.

I was originally attrached to openSUSE due to their truly innovative work in
packaging Linux. They championed reiserfs, xfs, and later btrfs. From my
understanding, they shipped the first production "delta RPMs" to users. Most of
all openSUSE packaged numerous desktop environments _well_ and emphasized user
choice and flexibility, at a time when Ubuntu was chasing the One True User
Experience, attempting to emulate the Mac OS X playbook.

When I left for Debian, openSUSE was at a bit of a cross-roads. The
openSUSE Tumbleweed project had just started to get focus, but overall the
entire distribution felt trapped between two extremes: old packages and high
quality, or new packages and low quality.  Over time, I also became rather
frustrated that newer tools were never packaged for openSUSE, but almost always
provided for Red Hat and Debian users.

I started to feel the itch again after successive upgrades of Debian on my
primary laptop. That old problem of new packages with low quality or old
packages with high quality was creeping into my day-to-day more and more.
Reflecting upon much of the software I was using, I realized that much of it
wasn't actually packaged for Debian, but relied on the comedy trio of `curl`,
pipe, and `bash`.

The catalyst for my return was an infrastructure issue in the Jenkisn project,
wherein I needed to re-familiarize myself with the [openSUSE Build
Service](https://build.opensuse.org). An installation of [Open Build
Service](https://openbuildservice.org/) (OBS), yet another openSUSE innovation, OBS
allows for users and developers to easily create packages for a myriad of
operating systems. I have long [had an
account](https://build.opensuse.org/project/show/home:agentdero) in OBS, but
had not really taken advantage of it. Looking at a smattering of unpackaged
garbage strewn across the file system, and then considering this excellent tool
for packaging applications for Linux, I had found a solution to (some) of my
woes. One afternoon of playing around with packaging
[sway](https://github.com/swaywm/sway) ([packages
here](https://build.opensuse.org/project/show/home:agentdero:sway)), I was
sold: back to openSUSE.


OBS is what drew me back in, but I have noticed that openSUSE Tumbleweed is
far more stable and mature than it once was, providing much newer packages with
good quality. I am not sure what other tunables openSUSE ships with, but I have
noticed a dramatic reduction in resident memory usage, running similar
workloads to what I had previously under Debian. Finally, everything I was
using previously is _packaged_ now, which makes me feel much better about the
state of the system. Signal, Sway, Docker, and everything else already provided
by most systems is coming through easily managed and upgraded _packages_. The
only things I've curl-bashed have been [RVM](https://rvm.io) and Rust, but I
have no expectations that RVM or Rust nightly would fit into any sane packaging
scheme.

I recommend trying out openSUSE, for me it strikes the balance between
stability of a curated system and providing power users flexibility, with
minimal sacrifices in either direction.

What can I say, a tidy system brings me joy.
