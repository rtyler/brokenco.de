---
layout: post
title: Honeycomb LX2 Resources
tags:
- linux
- hardware
---

An ARM64 (aarch64) machine which sat idle on the workbench amidst other inert items
has _finally_ returned to service. Many years ago I purchased a [HoneyComb
LX2](https://www.solid-run.com/arm-servers-networking-platforms/honeycomb-servers-workstation/honeycomb-lx2/)
ARM workstation with the hopes that it would become the desktop counterpart to
the [Pinebook Pro](https://pine64.org/devices/pinebook_pro/) which also graced
my junk heap. The earlier days of Linux/aarch64 were quite unpleasant with a
hodgepodge of driver support and other problems. A lot of hardware support
improvements have landed upstream in the Linux kernel since I first purchased
this machine and I was able to install a stock Debian image without too much
difficulty.

_Not too much_.


It still was not terribly simple but at least I now have something functioning in the rack servicing aarch64 builds!

```
Linux honeycomb 6.12.101+deb13-arm64 #1 SMP Debian 6.12.101-1 (2026-08-05) aarch64 GNU/Linux
```

---

There are a number of useful hobbyist resources I relied on, which I wanted to
link for posterity here:


[LX2K\_Guide from @Wooty-B](https://github.com/Wooty-B/LX2K_Guide#bios)

I found this repository to be incredibly helpful as a confirmation of some
install procedures and hardware support. [This
Honeycomb](https://github.com/evilrobot-01/HoneyComb) repository popped in my
searching as well, while not as thorough as Wooty's it has some useful UEFI
shell invocations that helped me muddle through using the shell.

[SolidRun has this quickstart
guide](https://dev.solid-run.com/nxp/lx2160a/sbc-platform/honeycomb-lx2-clearfog-cx-lx2-quick-start-guide)
which didn't exist when I bought this board originally. It was a handy
reference for some basics.

[Installing Ubuntu on SolidRun HoneyComb LX2](https://www.hekster.org/Professional/SolidRun%20HoneyComb/)

This was a very helpful blog post to refer back to because the original author
included screenshots of some of the UEFI bios settings! This was really helpful
to confirm what was correct versus incorrect as I got started.


[openSUSE wiki page on HoneyComb LX2K](https://en.opensuse.org/HCL:HoneyComb_LX2K)

I found this useful mostly to confirm that the system should be _generally_
well supported these days. When it was originally released there were all kinds
of kernel and driver hacks that were needed to bring the machine online.


[First experiences with Honeycomb LX2k](https://dev.to/lizthegrey/first-experiences-with-honeycomb-lx2k-26be)

Not terribly useful or detailed, but another confirmation "from the field" of
some things I had in mind. This reminded me about the jumpers for the boot
sequencing:

> Make sure the firmware source jumpers are set off-ON-ON-ON-ON-off (or
> otherwise as indicated by silkscreen on board).
