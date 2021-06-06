---
layout: post
title: "Increasing the density of the home lab with FreeBSD Jails"
tags:
- freebsd
- jails
---

Investing the time to learn FreeBSD jails has led to a dramatic increase in the
number of services I run in my "home lab."
[Jails](https://docs.freebsd.org/en/books/handbook/jails/), which I have
[written about before](/tag/freebsd.html), are effectively a lightweight
quasi-virtualization technique which I use to create multiple software-defined
networks to segment workloads. Jails have allowed me to change my "home lab"
dramatically, allowing me to _reduce_ the number of machines and increase
hardware utilization. For now, the days of stacking machines, dangling
Raspberry Pis, or hiding laptops on the shelf are all gone. Almost all my needs
have been consolidated into a single FreeBSD machine running on a 4 year old
used workstation.

I have attempted to consolidate the home lab before, but not with this
level of success. There was the time I tried deploying a single-node
Kubernetes cluster, which worked for a time until some upgrade caused the
software-defined networking to break in a way I wasn't interested in debugging
in my free time. Following that I tried to go "old school" and started spinning
up `libvirt`-based virtual machines which worked _well_ for a long time. The
major downside of that approach is that I simply wasn't able to get much
density because of the significant overhead for each virtual machine. At some
point you run out of memory to commit to each VM.

Converting virtual machines to FreeBSD Jails took a few hours over a weekend,
and since then the **quantity** of what is running has jumped dramatically. Originally I was running:

* [Nextcloud](https://nextcloud.com) (Apache)
* MySQl
* Gopher server
* [Tor](https://torproject.org/) relay
* [Gitea](https://gitea.io)

I now _also_ run:

* Elasticsearch
* Graylog
* Icinga
* Icecast
* MongoDB
* Nginx
* [Peertube](https://joinpeertube.org)
* PostgreSQL, which replaced MySQL for Nextcloud and is now running for multiple services.
* Redis
* Plus some personal web apps

To accomplish this, I use ZFS and Jails **heavily**. All the jails run on a
striped and mirrored ZFS disk array which allows for better performance and
redundancy than my previous incantation. These services are low-utilization
which allows them to cooperate effectively within this machine's 4 cores and
16GB of RAM.

## Benefits

The higher utilization of this single machine, which is always-on, has a better
power consumption profile than running multiple machines. More power efficiency wasn't my original motivation however, I was much more interested in some of the system administration benefits of bringing these services "under one roof."

**Backups** are _much_ easier than before. I'm using some ZFS scripts to
perform automatic snapshots on daily/weekly/monthly basis. Separately from
those, I regularly push backups off-site and that's trivial because at the
"host" machine level, not the jail level, I can access all the filesystems at
once.

**Security** is much easier as well since Jails are obviously providing a level
of isolation. On top of that, I am using the `vnet` functionality in FreeBSD to
provide additional network segmentation, something I never did with physical or
virtual machines.

**Management** is pretty straightforward with all these services running in
Jails. I typically do all my administration from the host rather than the jail
level. As such I can pretty easily shuffle configuration files around.
Unfortunately to date I haven't found a good configuration management tool,
including my own [tinkering](https://github.com/rtyler/zap) that provides a
Jails-aware set of tools for more automation.

## Downsides

The most notable downside to this approach is that a hardware failure _could_
take me offline for a bit. These services are all dependent on a single power
supply (PSU) and CPU. As such a failure of either would require me to keep all
these services offline until that part could be replaced. For a home lab setup,
I'm not expecting to support a specific SLA, so I'm quite comfortable with this
risk.

I can imagine some security arguments that could be made, but frankly I think
this Jails approach is _much_ better secured than my previous home lab setups.

---

At present this machine has just under 10GB of RAM in use and a load average
that floats between 1.0 and 2.0. Despite all the services that are running, it
still uses _less_ than my workstation with a few browsers open. To deploy your
own "home lab" set up in this way you absolutely _do not_ need a high powered
machine. I would argue that a ZFS-based disk array is likely more important,
after all most home lab tasks, that aren't video-encoding, tend to be more disk
I/O heavy rather than memory/CPU heavy.

This path isn't quite entry-level simple, but if you have some systems
administration experience, I think [FreeBSD](https://freebsd.org) with ZFS and
Jails is worth considering for your home or office lab.
