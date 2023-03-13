---
layout: post
title: "Invalid signature in boot block on FreeBSD"
tags:
- freebsd
---

I don't have a lot of opinions about
[UEFI](https://en.wikipedia.org/wiki/Extensible_Firmware_Interface), but it
seems that building something as critical as booting around the FAT32
filesystem is not a great idea. FAT32 is a simple but archaic filesystem which
has the resiliency of a paper boat. While moving machines around in my homelab
this weekend I was bit by that resiliency as halfway through booting my FreeBSD
NAS it complained that it could not complete `fsck` operations: `Invalid
signature in boot block: 0000`.

This FreeBSD machine uses UEFI and boots directly to ZFS. Imagine my surprise
that the operating system had complaints about my boot partitions...after it
had already booted. This machine had recently been rebuilt with new disks after
I discovered that the previous disks I had been sold were "SNR" (Shingled
Magnetic Recording), which have such abhorrent performance that it's a wonder
they're even marketed at all. Suffice it to say, disk issues on this machine
_terrify me_. I doni't want to deal with another rebuild!

The boot process failed half-way through, which means that FreeBSD drops you
into a single-user mode in the console. With that I could poke around a little
bit:

* `zfs list` showed all data sets I expected
* `zpool status` showed  that each disk in the pool was healthy.
* `zpool scrub` for good measure to make sure the pool was legitimately healthy.
* `gpart` showed that the partitions on all the disks were in tact as well.
* `fsck` reported errors on the EFI partitions for *three* of the *four* disks.

For whatever reason, the `efi` partitions were all hosed in the same way on
3/4th of the disks: `Invalid signature in boot block`.

I am still not entirely sure how this corruption occurred but getting the
machine back online to do more disk diagnostics was a key step forward.
Fortunately with one valid `efi` partition, I was able to `dd` its contents
onto every other disk, since they're all supposed to be identical anyways:

```
dd if=/dev/ada0p1 of=/dev/ada1p1 bs=4M
```

After a round of copying bytes around, I was able to reboot and everything came
up perfectly fine!


Since there are no other indications of disk failure or problems, I may never
know what originally caused the corruption. The consensus on IRC however is
that building a foundational part of the boot process on an unreliable
filesystem was perhaps a bad idea.
