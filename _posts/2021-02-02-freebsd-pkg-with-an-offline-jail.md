---
layout: post
title: "Using FreeBSD's pkg(1) with an 'offline' jail"
tags:
- freebsd
- jails
---

In the modern era of highly connected software, I have been trying to "offline"
as many of my personal services as I can. The ideal scenario being a service
running in an environment where it cannot reach other nodes on the network, or
in some cases even route back to the public internet. To accomplish this I have
been working with [FreeBSD
jails](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/jails.html) a
quite a bit, creating a service per-jail in hopes of achieving high levels of
isolation between them. This approach has a pretty notable problem at first
glance: if you need to install software from remote sources in the jail, how do
you keep it "offline"?

_Note: if you're already familiar with how great FreeBSD jails are, you can skip [ahead](#pkg)_

Without trying to start a flamewar, I think FreeBSD jails are basically what
Linux containers aspired to be when they grew up. In short:

> The jail mechanism is an implementation of FreeBSD's OS-level virtualisation
> that allows system administrators to partition a FreeBSD-derived computer
> system into several independent mini-systems called jails, all sharing the same
> kernel, with very little overhead

_From [Wikipedia](https://en.wikipedia.org/wiki/FreeBSD_jail)_

Since FreeBSD 12, FreeBSD jails can "natively" do something which I haven't
seen done seriously in other container or virtualization stacks: **provide full
network isolation**. VNET allows attaching an entire virtualized network stack
to a jail, which allows you to delegate an actual hardware interface to a jail,
after which the host no longer sees the interface at all!

> VNET is the name of a technique to virtualize the network stack.  The
> basic idea is to change global resources most notably variables into per
> network stack resources and have functions, sysctls, eventhandlers, etc.
> access and handle them in the context of the correct instance.  Each
> (virtual) network stack is attached to a prison, with vnet0 being the
> unrestricted default network stack of the base system.

_From `vnet(9)`_

Using this capability you can set up entirely software-defined virtualized networks inside of FreeBSD jails for everything from network software testing (e.g. VPNs), to pre-flighting firewall changes in a simulated environment. If this sounds compelling to you, I recommend bouncing over to [this blog post](https://klarasystems.com/articles/virtualize-your-network-on-freebsd-with-vnet/) to learn more.


FreeBSD has also supported 
[ZFS](https://www.freebsd.org/doc/handbook/zfs-zfs.html)
natively, including as the boot `/` partition for a number of major releases.
It should therefore be no surprise that jails integrate _very_ well with ZFS.
In my setup each jail is its own file system in the main ZFS pool (`zroot`),
which allows me to snapshot each jail independently for backup purposes.


"Excuse me, I believe I was promised some `pkg(1)` related content?"


Yes yes, getting to that. Since FreeBSD jails are not well appreciated by the
broader systems engineering world, I wanted to take a moment to highlight some
of what we've been missing out the past couple years while we've been screwing
around with container orchestration engines.

`pkg(1)` is a binary package management tool akin to `apt` or `yum`. On modern
FreeBSD installations compiling ports is no longer required, which is an
incredibly welcome change to FreeBSD in recent years.  Like it's Linux
relatives, `pkg` retrieves package metadata and tarballs from a remote
repository by default, from the "offline jail" perspective this is a problem.

Jails however, are just running off slices off my host filesystem, e.g. `/jails/postgresql` which allows me to commands from the host in that file tree, for example:

```
freebsd# ls /jails/postgressql
.cshrc          bin             entropy         libexec         net             root            tmp
.profile        boot            etc             media           proc            sbin            usr
COPYRIGHT       dev             lib             mnt             rescue          sys             var
freebsd# 
```

You should note that this looks surprisingly identical to what a default base
install of FreeBSD, and that's because it is!

<a name="pkg"></a>
## Installing packages

The `pkg(1)` utility has a _very useful_ flag `-c` which I can use for these jails:

```
-c <chroot path>, --chroot <chroot path>
    pkg will chroot in the <chroot path> environment.
```

From the jail host's perspective, I can poke around the jail's filesystem with ease, which makes installing packages _trivial_ from the host's perspective. For example:

```
freebsd# pkg -c /jails/postgresql install postgresql13-server
```

The above command will install the PostgreSQL v13 package and all its dependencies within the jail's filesystem path:

```
# postgres --version
postgres (PostgreSQL) 13.1
# 
```

"Try this one weird trick and your jails will never have to know anything about
packages ever again!"

**Caveats**:

* My host distribution is identical to the distribution installed in the jail,
  e.g. `12.2-RELEASE`. If there were drift I'm sure there would be problems
  with using `pkg(1)` in this way.
* This approach can feel goofy with configuration management, since the jail
  host is where all the configuration and package management happens.


Nonetheless, I was incredibly excited to discover this feature which made
setting up and managing my heavily isolated vnet-based jails *much* easier!

---

In the future I hope to write more about the home lab FreeBSD set up that I
have been working on over the past couple weeks. FreeBSD 12.x is by far the
most exciting FreeBSD release I have used since the transition to full SMP in
the 4.x -> 6.x timeframe. If you haven't looked at FreeBSD lately, I highly
recommend giving it a spin!
