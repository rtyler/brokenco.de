---
layout: post
title: "Mr. Sas, here to save the day."
tags:
- freebsd
- hardware
- homelab
---

I have always been a technology scavenger, picking up cheap or disused
computers for parts or tinkering. Last year when I picked up a
_full-height_ server cabinet, a new world of rack-mountable junk finally became
possible! One lucky Craigslist find ended up being an older 2U IBM xSeries server with
8 drive sleds that was described as "sorta working" by the owner, who was
shedding some extra stuff for his move across the country. I accepted the
challenge, forked over a few
[Jacksons](https://en.wikipedia.org/wiki/United_States_twenty-dollar_bill), and
brought the machine home.


The thing about "server grade hardware" is that it never really is. The
consumer grade stuff is junk, the small-medium business grade stuff is junk.
It's all junk. Servers tend to have more redundancies to compensate, but at the
end of the day: junk.

Anyways, the seller had trouble getting the server to recognize more than one
stick of RAM. I carefully unseated and reseated the RAM... and it just worked!

Onto the next challenge, sometimes the machine wouldn't reboot. Somehow a cold boot, versus a "reboot" didn't work properly. I found [a critical problem in the IMM](https://www.ibm.com/support/pages/system-board-lighpath-led-warning-and-cpumem-vrd-fault-ibm-system-x) which could have resulted in me _bricking the board_ and upgraded the out-of-date firmware, dreading any potential triggering of the bug.

I then fought against the RAID card, which really means I fought against the
[Serial-Attached-SCSI](https://en.wikipedia.org/wiki/Serial_Attached_SCSI)
disks. Did you know that Serial-Attached-SCSI has a cable that's functionally
compatible with SATA? Did you also know that SAS disks are obscenely expensive,
while SATA SSDs are plentiful? The difference it turns out is largely in
software and many SAS supporting devices also support SATA! 

I wanted to boot directly into [FreeBSD](https://freebsd.org) via ZFS, with a
nice array of SATA SSDs , but try as I might I could not get FreeBSD to boot
consistently. Inevitiably
[mfi(4)](https://man.freebsd.org/cgi/man.cgi?query=mfi&sektion=4&apropos=0&manpath=FreeBSD+14.1-RELEASE+and+Ports)
errors would appear and the system would become unusable. There were so many goblins in this machine, I continued searching forums, StackOverflow, and random mailing list posts. Until I finally met **Mr. Sas.**

From the
[mrsas(4)](https://man.freebsd.org/cgi/man.cgi?query=mrsas&apropos=0&sektion=0&manpath=FreeBSD+14.1-RELEASE+and+Ports&arch=default&format=html)
man page:

> Using `/boot/device.hints` (as mentioned below), the user can provide a
> preference for the mrsas driver to detect a MR-Fusion card  instead  of the
> mfi(4) driver.

The `mfi(4)` driver and my hardware simply would _not_ cooperate, so I updated `/boot/loader.conf` with:

```
hw.mfi.mrsas_enable="1"
```

I crossed my fingers, blew the petals off a dandelion, clutched a lucky charm
and rebooted the machine..


...

...


As the machine POSTed and booted into FreeBSD I quietly waited for something _else_ to go wrong.


But it didn't. 

...


How about that? It just worked.


**Mr. Sas saved the day!**

I have probably spent $1000 on upgrades for the machine, which was retired from
some guy's garage for $100. In turn I've gotten _far more benefit_ from this
goofy steel slap resting at the bottom of the rack.

The machine has since had its disk capacity maxed out, it's been upgraded to
136GB of RAM. It has become the central workhorse of my homelab: storing
backups, hosting a dozen jails, and even a few VMs!

None of which would have been possible without the friendly help of `mrsas(4)`.
