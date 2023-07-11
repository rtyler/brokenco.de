---
layout: post
title: Dynamically forwarding SSH ports with "commandline disabled"
tags:
- ssh
- bsd
- linux
---


I frequently use SSH for accessing one of the many development workstations I
use for work, which includes developing network services among other things. A
couple of years ago I wrote about this hidden gem in `ssh` which allows
[dynamocaily forwarding ports](/2021/05/16/dynamically-forward-ssh-ports.html). 
This handy little feature allows dynamocailly adding local port forwards from within an already running SSH session. Recently however this feature has stopped working properly, emitting `commandline disabled`.

It turns out that this is due to a backwards incompatible change which [OpenSSH released in 9.2](https://www.openssh.com/txt/release-9.2) earlier this year:

> ssh(1): add a new EnableEscapeCommandline ssh_config(5) option that controls
> whether the client-side ~C escape sequence that provides a command-line is
> available. Among other things, the ~C command-line could be used to add
> additional port-forwards at runtime.

The reason for this change is to support some sandboxing use-case which I don't entirely understand but also don't need, so I needed to add the following option to my host entries in `~/.ssh/config`:

```
Host foobar
    Hostname 172.16.1.1
    EnableEscapeCommandLine yes
```


This can also be configured on the command line with `-o EnableEscapeCommandline=yes`. Happy port forwarding!
