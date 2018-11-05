---
layout: post
title: "Switching transparently between Tor or the LAN with SSH"
tags:
- ssh
- tor
---

Whenever possible, I typically send much of my traffic through the
[Tor](https://tor-project.org) network, including traffic to some services
which I operate for myself, such as a secure shell server. When I am traveling
or otherwise not on my home network, I use one of Tor's more fun features:
[Onion Services](https://www.torproject.org/docs/onion-services) (formerly
known as Hidden Services). Onion Services can be identified by the `*.onion`
top-level domain and allow the server's location to be anonymous/concealed
just like the client.


SSHing into an Onion Service is easily accomplished by adding the following
line to `~/.ssh/config`.

```
Host *.onion
    ProxyCommand /bin/nc -X 5 -T lowdelay -x 127.0.0.1:9050 %h %p
```

Assuming the machine is running a Tor client, configured to run its local
SOCKS5 proxy on port `9050`, this `ProxyCommand` runs SSH through `nc` (netcat)
without the user even needing to think about any additional Tor-specific
configuration.

Some applications such as Git save a hostname in their own configuration files
for SSH-based connections. With my usage, saving hostnames presents a problem
since I do not _always_ want to run my traffic over Tor, especially when I'm on
the local network with a gigabit of throughput between my laptop and the target
machine.


To solve this, I've written the following tiny script which bounces traffic
through Tor, or just routes it over the local network using netcat.

Since I'm using NetworkManager on Linux, the script relies on finding an active
connection which _appears_ to be on my local network. While not fool-proof,
since other networks might share the same address space, it's good enough for
now:

```bash
#!/bin/bash
#
# Positional parameters are:
#  * hostname
#  * port
#  * hidden service name if we must fall back to tor

CONNECTED_DEVICES=$(nmcli --fields=device --terse connection show --active)

for device in ${CONNECTED_DEVICES}; do
    ip addr show dev ${device} | grep "inet 192.168.42." 2>&1 > /dev/null
    if [ $? -eq 0 ]; then
        echo ">> Using the local network.."
        exec /bin/nc $1 $2
    fi;
done;

echo ">> Using Tor"
set -xe

exec /bin/nc -X 5 -T lowdelay -x 127.0.0.1:9050 ${3} ${2}
```

With this script, my `~/.ssh/config` is slightly modified to define the local
hostname and also pass the Onion Service name through to the `ProxyCommand`:

```
Host myserver
    Hostname 192.168.42.42
    ProxyCommand $HOME/bin/local-or-tor %h %p 0xdeadbeef.onion
```

----

Now all my Git remotes work the same whether I'm on the local network, or off
floating around the internet via Tor.
