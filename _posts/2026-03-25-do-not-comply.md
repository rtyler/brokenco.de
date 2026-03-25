---
layout: post
title: "The problem is obeying in advance"
tags:
- software
- opinion
- linux
---

Linux power-users tend to have strong opinions about two things: distribution
and systemd. The bazaar of distributions means
competing implementations or different perspectives end up expressed
through the curation of the packaged software. `systemd` ended up so
contentious because it's a decent piece of technology which suffers from
persistent scope creep that became a foundational component in a _lot_ of
distributions. The drama du jour is that systemd is somehow implicated in "age
verification laws."

`systemd` as an init system is pretty good. Once upon a time I worked on
porting [launchd](https://en.wikipedia.org/wiki/Launchd) to
[FreeBSD](https://freebsd.org) and so I have _some_ familiarity with the
silliness of most init systems.

`systemd` as a [katamari](https://en.wikipedia.org/wiki/Katamari_Damacy) at the
root level of most Linux systems is _not_ "pretty good." There have been
_numerous_ tendrils of what is understood to be "systemd" which are of lesser
quality and have resulted in security issues.

Anyways, I hope you get the point. systemd as an init system: good. systemd as a operating system: bad.

The drama du jour is about the latter.

---

One should not [obey in advance](https://timothysnyder.org/on-tyranny).
Especially in the domain free and open source software which is _literally a
political project_.

I stumbled into [this blog post](https://blog.bofh.it/debian/id_473) through
[Planet Debian](https://planet.debian.org) by a debian maintainer which is
patently absurd.

> Recently, the free software Nazi bar crowd styling themselves as "concerned
> citizens" has tried to start a moral panic by saying that systemd is
> implementing age verification checks or that somehow it will require
> providing personally identifiable information.


The author is correct insofar that `systemd` did **not** add age verification.
**However** most of the folks upset with the change are upset that their Linux
systems are obeying in advance.

systemd
**did** make changes in order to obey. To take part in anti-free restrictions
under the guise of "age verification" From the [pull
request](https://github.com/systemd/systemd/pull/40954)

> Stores the user's birth date for age verification, as required by recent laws
> in California (AB-1043), Colorado (SB26-051), Brazil (Lei 15.211/2025), etc.

The whole motivation of the change was to _obey in advance_ to these unjust laws.

The author then goes on to make some equally absurd claims about how this
functionality is _important for porents_ to implement controls on computers, for
the children! Clearly this person must not know any actual children, or
even parents for that matter. Children are _excellent_ at finding ways
to circumvent restrictions. The idea that a user-modifiable piece of data on
a local machine should be trusted for "parental controls" is so detached from
reality that I originally thought they were making a sarcastic joke.


I think this [tongue-in-cheek systemd-censord](https://lists.debian.org/debian-legal/2026/03/msg00018.html) post does better than anybody to exclaim how absolutely ludicrous this obeying in advance is:

> Systemd units will be created for every desired censorship function, and will
> be started based on the user’s location. For example, a unit for Kazakhstan
> will implement the government-required backdoor, a unit for China will
> implement keyword scans and web access blocks (more on this later), a unit
> for Florida will ban all packages with “trans” in the name (201 packages in
> current stable distribution), a unit for Oklahoma will ensure all educational
> software is compliant with the Christian Holy Bible, a unit for the entire
> United States will prevent installation of any program capable of decoding
> DVD or BluRay media, and a unit for California will provide the user’s age to
> all applications and all web sites from which applications may be downloaded.
> As can be seen, multiple units may be started for a given location. 


Do not obey in advance.

