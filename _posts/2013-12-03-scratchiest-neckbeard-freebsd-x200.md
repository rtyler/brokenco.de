---
layout: post
title: "The scratchiest neckbeard, or FreeBSD on my Thinkpad X200"
tags:
- freebsd
- unix
---


Pulling my laptop out of my bag this past Friday, I was excited with the
prospect of a good relaxing day of hacking on whatever I pleased. Having
fulfilled the Thanksgiving family obligations, and negotiated an errand-free
day with my wife, I was pretty excited about a full day of tinkering.

I pop open my [Thinkpad](http://www.thinkwiki.org/wiki/Category:X200), it wakes
from sleep, and all input is frozen. The screen is rendering the image of my
last desktop, but other than that, everything seems frozen, and a little
indicator light is blinking at the base of the screen.

"What the shit?" I think and hard reset the machine.

The machine comes POSTs, displays a "disk error" on boot.

"What the shit?"

Experimenting a bit more, I determine that the SSD which I had purchased 3 1/2
years ago, has completely failed. A situation I didn't expect from an SSD, I
had only expected that writes might fail at some point.

To make a long story short, I ventured out into the Black Friday chaos, fetched
a new Intel 128GB SSD, brought it home and installed it.


### Starting from scratch

Over the past couple months I've been toying with the idea of installing
FreeBSD on my laptop, but had been dissuaded by `lme@`'s report on the FreeBSD
[Suspend/Resume](https://wiki.freebsd.org/SuspendResume) wiki page. Wherein he
described his experience as *mostly* positive except:

> *USB is dead after 2nd resume*

Not having USB is somewhat of a deal breaker. Either way, I had some time to
kill, a full OS to install *anyways*,  and it had been some time since `lme@`'s
report. Perhaps the issue was fixed by now? Maybe it was just _his_ X200, mine
might be different!

I forged ahead.

Installing FreeBSD is something I've probably done nearly 50 times in my, this
time around was a little different however. The new FreeBSD 10 installer allows you to
install ZFS as the "root" file system, not only that, you can enable encryption
at install too!

I went ahead and installed FreeBSD, giddy with the notion that I might
*finally* have ZFS running on my main machine. Truth be told, I was more
excited than any person probably should be about a file system.

Completing the installation, I verified that suspend/resume worked _at all_. Sure
enough, it did! Overjoyed I started setting up my environment to my liking.

After 30 minutes of installing packages and configuring various bits of
software, I remembered "*USB is dead after 2nd resume*"

### Fixing Suspend/Resume

As you might expect, the USB issue persisted. I started to experiment, and try
to think of ways to fix the issue, all said and done I tried:

 * Updated from BETA3 GENERIC to latest 10-stable (r258761) kernel
 * Removed unnecessary modules from the kernel and rebuilt my own custom config
 * Disabled "options VESA" in kernel, based on a reference made in a mailing
   list post I've long since lost track of
 * Set the sysctls `dev.[uoex]hci.*.wake` to `1`, based on [this post](http://lists.freebsd.org/pipermail/freebsd-usb/2013-July/012242.html)


The last item **actually** solved the issue! I was able to use USB devices
after multiple suspends!

**Note:** I should clarify that all these steps are not necessary for
functional USB devices after boot. As far as I'm aware, the last item is all
that's actually required.

With further experimentation I determined that I was
not able to leave USB peripherals connected if I wanted to suspend the machine.
Leaving those devices connected would result in the machine suspending, and
then immediately waking back up. A "quirk", but something I can cope with in
exchange for ZFS and the other goodies that FreeBSD 10 provides.

If you're unable to reproduce these results, you might want to compare your list of kernel modules with mine below. A buggy kernel module can affect suspend/resume in unpredictable ways, from my understanding.

> zfs.ko opensolaris.ko geom_eli.ko crypto.ko aesni.ko sem.ko iwn5000fw.ko
> ums.ko ng_ubt.ko netgraph.ko ng_hci.ko ng_bluetooth.ko ulpt.ko ng_l2cap.ko
> ng_btsocket.ko ng_socket.ko linux.ko i915.ko drm.ko

Based on another mailing list post, I also set the sysctl
`hw.acpi.lid_switch_state=S3` to make sure that the X200 would suspend when I
shut the lid automatically.

----

Despite my low expectations originally, I had a managed to arrive at a FreeBSD machine which:

 * Uses the entirety of the SSD as an entire "zpool" with various ZFS
   partitions. This is double-plus-good as ZFS support in FreeBSD 10 supports TRIM thanks to [work by pjd@](http://lists.freebsd.org/pipermail/freebsd-current/2012-September/036777.html)
 * Suspends on lid close/resumes on lid open correctly
 * Restores all functionality after multiple suspend/resume cycles
 * Utilizes the built in wireless connection properly
 * Changes power consumption profile automatically when the power is detached
   via `powerd`
 * Plays audio correctly via the onboard audio card (not actually a requirement)


All of this, in a 12 inch, 4lb laptop is pretty darn exciting.


### Quirks

As to be expected, there are some quirks, nothing serious, but quirky behaviors nonetheless:

 * Aforementioned USB suspend/resume wake behavior
 * After resume, if no USB devices are attached, it seems X.org doesn't
   "understand" that the built-in keyboard is a valid input device. This *goes
   away* by switching to another virtual terminal, and then *back* to X. In
   effect, `Ctrl+Alt+F1` then `Ctrl+Alt+F9` to return to X, and input returns
   normally.
 * The default mode for the wireless (`iwn(4)`) driver seems to be "scan your
   brains out", which if you're trying to save battery **or** you're out of
   range of any useful wireless networks, is a little silly. This is easy to fix
   just by "downing" the interface with `ifconfig wlan0 down`
 * The wireless driver suffers from degraded performance when the laptop is in
   areas of moderate to heavy channel congestion. I'm working with some
   developers to hunt this issue down, the work-around right now is really just to
   "be patient" :)


### Future

The main purpose of my laptop is to support my work as a developer, the
secondary purpose is to support my work as an open source hacker. Having any
*nix OS makes the first case feasible, but having FreeBSD unlocks some hacking
that I've wanted to do, such as:


 * Learning more about ZFS, including performing whole-disk back-ups via ZFS
   snapshots and/or mirroring.
 * Restarting my work with [launchd](https://wiki.freebsd.org/launchd) on top
   of FreeBSD as a viable alternative to `rc.d`. (aside: systemd which many
   Linux hackers are familiar with can be considered a poor impersonation of
   launchd, which is, in my opinion, a pretty stellar job management daemon)
 * Start to particpate more in FreeBSD development, whether via patches to the
   base system or various ports that I use.
 * Experimenting with [Bhyve](http://bhyve.org/), a new BSD hypervisor
   technology incorporated in FreeBSD 10.

----

The most unfortunate aspect of this development means that I'm probably stuck
on my X200 for another couple years, or at least until somebody else does the
foot work to make sure later generation Thinkpads are covered by FreeBSD's
sparse laptop support.


I'm plenty satisfied with my work/play environment, all I need is to
acquire a FreeBSD sticker for the X200 and I'm set!

