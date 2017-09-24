---
layout: post
title: Replacing Coastguard
tags:
- miscellaneous
- freebsd
- pfsense
---

I have tremendous difficulty with decommissioning electronics. I only recently
stopped using my [Galaxy Nexus](https://en.wikipedia.org/wiki/Galaxy_nexus), an
almost five year old cell phone. Earlier this year I recycled a 32-bit
x86-based [Thinkpad T41](http://www.thinkwiki.org/wiki/Category:T41), only
because its overheating issues made it impractical to continue running
workloads. And up until today, the lowest powered device actively running a
Unix in my office, was a 266Mhz AMD Geode-based [Soekris](http://soekris.com/).

The little Soekris, `coastguard`, was given to me by my friend Dave who had
himself decommissioned it _years_ ago. I cannot exactly remember when I started
using `coastguard` to act as a FreeBSD-based
([pfSense](https://www.pfsense.org/)) router, but it was easily over five or
six years ago.

Unfortunately my traffic requirements have since exceeded the capabilities of
the little device. Between my inability to discard computers, and more
electronics sprouting network capabilities, a total of ten devices may be using
the network at any given time. If that wasn't troubling enough for the little
tin can, streaming video has become very important. In aggregate those
ten devices are more frequently maxing out the uplink connection, and fighting
for traffic priority.


In it's stead, I have installed `strawberry`, a **much** more powerful
[FreeBSD](https://freebsd.org) 11.1 machine which is running a very simple
gateway and [packet filter](https://www.freebsd.org/doc/handbook/firewalls-pf.html)
configuration. All said and done, it probably took me about 30 minutes to copy
and paste the right configurations into place. What makes the "replacement"
comical to me is that I mentally procrastinated on replacing `coastguard`
because "pfSense is so easy" and I didn't want to sink a bunch of time
fiddling with FreeBSD to make it work for my needs.

Either FreeBSD has made things much easier, or I have gotten smarter.
Regardless, I'm sad to see `coastguard` make it's way into the bin which
eventually will go to the e-waste recycler.

Based on my performance recently, it is probably going to be a few years before
I can part with my first generation Raspberry Pis, which now will occupy the
"slowest computer in use" slot in my home office.
