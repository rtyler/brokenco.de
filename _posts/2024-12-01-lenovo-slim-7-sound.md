---
layout: post
title: "Listening to things on my Lenovo Slim 7"
tags:
- linux
- opensuse
---

Purchasing new hardware to run Linux on used to be so perilous that I would
only buy hardware which was at least 6 months out of date. The ecosystem has
changed so dramatically that when my Dell XPS experienced a chassis failure, I
went out to a big box store and came home with a Lenovo Slim 7. I immediately
installed a Linux distribution on it and started setting up my new portable
workstation without even considering hardware support.

Only after a couple weeks of usage did I notice how peaceful everything was. No
notifications, no alerts, no sound of any form!

As desirable as some peace and quiet might be, I do need to hear things from my
computer every now and again, so I scurried off to diagnose the problem.

I use a simple terminal-based UI for managing sound on my machines:
[pulsemixer](https://github.com/GeorgeFilipkin/pulsemixer) which was not
showing any sound cards attached to the machine. Searching for similar issues with this hardware, a search engine brought me to a Fedora-related thread where a particular package was referenced as having solved the problem: `sof-firmware`.

For well over a decade I have used [openSUSE](https://opensuse.org), the
reasons are not relevant for this post, but Fedora-alikes and openSUSE are
_usually_ close enough in packages, naming, and ethos, that forum threads and
discussions for one can apply to the other:

```bash
zypper in sof-firmware
```

Suddenly Slack was knocking down my door again, and I had sound! Tada! Of
course, I closed Slack, muted the sound, and went back to work.


Generally speaking Linux hardware support has gotten so good in the last decade
that I forget the olden days when we had to walk uphill both ways in the snow
to get a working set of desktop drivers.

Maybe next year will finally be the year..
