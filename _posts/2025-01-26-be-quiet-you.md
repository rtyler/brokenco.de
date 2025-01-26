---
layout: post
title: "Quieting the server fans with ipmitool"
tags:
- freebsd
---


Some recent changes to the primary server in my office left the fans running
louder than previously. I do have some noise canceling headphones but I still
don't want to hear the sound of jet fans from the other room, with a little bit
of free time I was able to nail down and correct the behavior using
`ipmitool(1)` and _magic bytes_.

I don't have a very clear idea what caused the baseline increase in fan speed,
but the [updates I mentioned previously](/2025/01/18/pptdevs.html) did include
adding a PCI-e card to an otherwise PCI-e card-less machine. I would guess that
something in the
[IPMI/BMC](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface)
resulted in the power profiles changing when the riser cards in the chassis
started to utilize power, indicating new peripherals that would benefit from
increased airflow.

Another homelab operator [on
Reddit](https://www.reddit.com/r/homelab/comments/aa3xj7/ibm_systemx_3650_m2_fan_speed_control/?rdt=59542)
found the magic bytes to poke into the IPMI with `ipmitool` that would
manipulate the fan control for _similar_ systems, in essence:

```
# ipmitool raw 0x3a 0x07 {fan_id} {speed} {fan_override}
```

My first attempt on this FreeBSD machine kicked back an error:

```
Could not open device at /dev/ipmi0 or /dev/ipmi/0 or /dev/ipmidev/0: No such file or directory
```

Oops! I need the kernel module, which can be loaded at runtime with `kldload
ipmi`, or at boot time with `impi_load="YES"`.


In my system's case, the two fan IDs and settings that I ended up configuring were:

```
# ipmitool raw 0x3a 0x07 0x01 0x20 0x01
# ipmitool raw 0x3a 0x07 0x02 0x20 0x01
```

That was enough to knock the speed down to a nice quiet whirr rather than a
medium-loud whoosh! Should you find yourself in a similar position, I recommend
following [nixCraft's
article](https://www.cyberciti.biz/faq/freebsd-determine-processor-cpu-temperature-command/)
to monitor the CPU temperatures as you fiddle with the appropriate balance of
noise to cooling power!






