---
layout: post
title: "Solving a FreeBSD Jails issue: interface already exists"
tags:
- freebsd
- jails
---

For a long time after I rebuilt my jails host, I could not restart a certain
number of jails due to an "interface already exists" error. For the life of me
I could not make sense of it, The services running in the jails were useful but
not _required_ so I put off tinkering with it. I thought that I would magically
stumble into the solution in my sleep or something equally silly.

```
watermelon# service jail start gitea
Starting jails: cannot start jail  "gitea":
ifconfig: interface epair14 already exists
jail: gitea: ifconfig epair14 create up: failed
.
watermelon# service jail stop gitea
Stopping jails:.
```

What perplexed me about this issue is that I would run `ifconfig epair14a`
after the failure to start the jail, and the interface would be there. "Surely
this must be a FreeBSD bug!"

The "eureka!" happened earlier today, not while I was sleeping, but rather
while I was solving other problems. "I bet there's something fishy in the
configuration, I should just rewrite it" I thought to myself. Most esoteric
bugs are not bugs with the compiler, libraries, or operating systems. Usually
they're the user doing something slightly stupid and not realizing it.


My jail configuration (`/etc/jail.conf`) resembled the following:

```conf
gitea {
        $id = "14";
        $ip_addr = "10.10.10.${id}";

        vnet.interface = "epair${id}b";

        exec.prestart = "ifconfig epair${id} create up";
        exec.prestart += "ifconfig epair${id}a up descr vnet-${name}";
        exec.prestart += "ifconfig $public_bridge addm epair${id}a up";

        exec.start = "/sbin/ifconfig epair${id}b ${ip_addr}";
        exec.start += "/sbin/route add default ${public_gw}";
        exec.start += "/bin/sh /etc/rc";

        exec.prestop = "ifconfig epair${id}b -vnet ${name}";
        exec.poststop = "ifconfig ${public_bridge} deletem epair${id}a";
        exec.poststop += "ifconfig epair${id}a destroy";
}
```

Looking at the block and comparing it to other _functional_ jails, I saw something missing: a `vnet;` declaration:

```diff
--- jail.conf   2023-11-12 20:09:03.028010000 -0800
+++ /etc/jail.conf      2023-11-12 19:59:02.867271000 -0800
@@ -230,6 +230,7 @@
        $id = "14";
        $ip_addr = "10.10.10.${id}";

+       vnet;
        vnet.interface = "epair${id}b";

        exec.prestart = "ifconfig epair${id} create up";
```


Sometimes you have to just walk away from a problem for a bit, but yeesh was that a silly one!


