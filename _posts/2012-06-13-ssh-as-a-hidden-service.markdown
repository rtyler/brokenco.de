---
layout: post
title: SSH as a Hidden Service with Tor
tags:
- tor
- ssh
- security
---


For quite some time I've been using [Tor](https://www.torproject.org) for a
number of things, but my most recent use revolves around a lesser-known feature
Tor provides: [Hidden Services](https://www.torproject.org/docs/hidden-services.html.en).


With fewer and fewer IPv4 addresses running around, especially among
residential consumer lines, it has become increasingly difficult to "play a
part" in the internet without gnarly port forwarding hacks combined with
dynamic DNS.


Hidden Services offer a way to bypass a lot of those hacks altogether, but it
comes at a cost of some latency. Basically you need to connect both ends of the
connection, the SSH server and SSH client, to the Tor network and let it handle
discovery and routing for you.

<center><img alt="Fancy diagram!"
src="http://agentdero.cachefly.net/unethicalblogger.com/images/tor-hidden-service.png"/></center>


1. Set up a Hidden Service [by following these instructions](https://www.torproject.org/docs/tor-hidden-service)
1. Store your `.onion` hostname on your "client" computer
1. Run Tor on your "client" computer
1. Add the following entry to you `~/.ssh/config`:

        Host *.onion
          ProxyCommand /usr/bin/nc -xlocalhost:9050 -X5 %h %p

1. Run SSH to your `.onion` hostname: `ssh username@shallots.onion`
1. Profit? Probably not, but who cares, you can now access all of your machines on
   *any* network from *anywhere* around the globe!

---

It's worth noting again that latency will be sticking point, so I probably
wouldn't use this for developing in a remote `tmux` session, but I would use it
for using SFTP to transfer files to and from the server (for example).


Addtionally, [with the instructions
above](https://www.torproject.org/docs/tor-hidden-service) it's trivial to set
up hidden web servers, hidden jabber servers, etc.

Use responsibly!
