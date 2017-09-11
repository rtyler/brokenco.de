---
layout: post
title: "Why bother with Docker (on FreeBSD)?"
tags:
- freebsd
- docker
---


Yesterday I participated in a very fun and productive [Docker Hack
Day](https://wiki.freebsd.org/DockerHackDay2017), wherein a few folks (myself
included) spent the day hacking on porting [Docker to
FreeBSD](https://github.com/freebsd-docker). After which, I had a nice relaxing
beer (or two) on my boat/train rides home and enjoyed one of my favorite
past-times: shit-posting on Twitter.

As it usually happens when I get sassy on Twitter, somehow real productive discussions
started to occur; much to my chagrin.

In one round of discussion, Kamil asked the following:

> I'm trying to get my head around the value prop here. What am I getting that
> jails don't already get me on FreeBSD?
>
> [@kchoudhu](https://twitter.com/kchoudhu/status/905304696411348992)


A very good question! One thing that Docker, as a technology, has done very
well at is becoming more valuable than the collection of its parts. Namely, one can
accomplish much of what Docker does with iptables, LXC, chroots, and some of
the clever union filesystem patterns Docker utilizes underneath the hood.

Similarly, to support Docker on FreeBSD, we will need ZFS, Pf, and some clever
use of Jails. But would FreeBSD/Docker really be more valuable than the sum of
its parts?

**Most definitely**.

To explain the benefits of Docker for the FreeBSD environment, I'm going to
muddy the waters between what Docker can do today, and what FreeBSD/Docker
_could_ do tomorrow. Underneath the covers, the overarching theme for me is
**portability**. FreeBSD/Docker would be able to take advantage of FreeBSD's
"Linuxulator" support and run Linux binaries, alongside FreeBSD binaries,
meaning every container already in existence would be usable.

That said, there are some other benefits!

### Packaging

The packaging format for an image alone is a really useful feature. The
"container" metaphor (shipping container) as it's typically understood refers
to the **image** which could be published to, and downloaded from, [Docker
Hub](https://hub.docker.com). This standard format for schlepping an application
around is really helpful. Packaging an application into a container means it
can be immediately deployed into Kubernetes, or one of a half dozen other
container runtimes, without modification.

From a service delivery standpoint, infrastructure I am responsible for must
fit into a container, or I'm not going to waste my time on it.

(Unfortunately Docker suffers from nomenclature overload and stupidity here, the
"image" and "container" terms seem like they're reversed, but that's another
ranty blog post.)


### Networking

One of the things I find most useful with Docker is the support for
container-based networks. I will typically make use of this with
`docker-compose`, adding a `docker-compose.yml` to a project which describes a
series of services necessary to run a specific application. For example, if my
web application requires LDAP and Redis to be running, `docker-compose up` will
stand up a container for: my webapp, ldap, and redis, placing them all on the
same network, allowing me to link them together.

Rather than running these all locally, I can have `docker-compose`
automatically create a specific network for those services to talk to each
other. Meaning I could simultaneously have multiple Redis containers running on
my machine, for all kinds of different web application projects, without any
problems.

Whilst I *could* do this myself with iptables or pf, it would be such a huge
pain, that nobody would ever do it.

Additionally, since I have this topology defined in `docker-compose.yml`, other
developers working on the project from their Mac OS X, Linux, or FreeBSD
workstations would be able to stand up the exact same stack of containers.


### Isolation

For me the "isolation" of the processes running in a container is interesting
but not actually a requirement for my work. I have never really trusted Docker
"isolation" for anything security related.

The isolation does become interesting from a filesystem perspective however.
For example, while I technically can create chroots and jails myself, having
those "enabled by default" for a Docker container, with optional volume mounts
for specific directories is *immensely* useful for local development.

For example, sometimes I need a quick Jenkins instance to test/verify something,
typically reproducing a bug:

    docker run --rm -ti -p 8080:8080 jenkins/jenkins:lts-alpine

When that container executes, it receives its own little isolated file system,
which disappears entirely when I stop the container (`--rm`). There are other
times however, when I need to inspect the contents of the `JENKINS_HOME` for
bad data, in which case, I would volume mount a specific directory through:

    docker run --rm -ti -p 8080:8080 -v $PWD/jenkins_home:/var/jenkins_home jenkins/jenkins:lts-alpine

From the perspective of the running process (`java`), the file system looks
completely normal, as it would expect. From my perspective as the user however,
anything the process writes to `/var/jenkins_home` is available on my host
machine under `$PWD/jenkins_home`, ready for inspection.

For development, or testing, this is immensely useful!


---


Many of these patterns are already very useful to me via Docker on Linux.
However, I fundamentally believe that FreeBSD is a superior development OS.
Between DTrace, ZFS, Ports (via pkgng), and numerous other helpful features
that come from a wholistically packaged and distributed operating system.

Personally, the lack of Docker on FreeBSD has been **the** major impediment for
my own usage of FreeBSD as daily development system. By my own choice, I
**must** have Docker to do my work, and will not work without it.

Bringing Docker to FreeBSD is, to that end, a selfish endeavour; wish me luck!
