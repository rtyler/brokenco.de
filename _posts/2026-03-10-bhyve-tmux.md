---
layout: post
title: Using tmux with bhyve
tags:
- freebsd
---


Many aspects of FreeBSD follow the user-friendly unix philosophy, it's just choosy about who its friends are. [1]
I have always found [bhyve](https://bhyve.org/) virtualization to be really
interesting but really unfriendly. The
[vm-bhyve](https://github.com/freebsd/vm-bhyve) management system was what
finally cracked `bhyve` open and made it usable for me. The `vm` command has
paper cuts but generally speaking it does what I want on my primary FreeBSD
machine.


For the longest time I used the built-in VNC support to connect to machines
because the `vm console` command would use `/usr/bin/cu` which would
_inevitably_ trap my console and no amount of `~>~>~><~D~>D<S~>D<~><D~<L` would
help me exit.

Somewhere along the line [tmux](https://github.com/tmux/tmux/wiki) support was
[added to `vm-bhyve`](https://github.com/freebsd/vm-bhyve/wiki/Using-tmux) and now `vm console <name>` simply opens up a new tmux
window! 

I host everything under `/vm` on the machine, so in `/vm/.config/system.conf`: 

```
console="tmux"
```


This seems like a simple thing to be excited about, and it is, but it makes
VMs _wildly_ more accessible and useful for me.


[1]: https://en.wikiquote.org/wiki/Unix
