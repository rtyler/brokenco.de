---
layout: post
title: Running two practically identical daemons on FreeBSD
tags:
- freebsd
---

I stumbled into an annoying problem
[yesterday](/2020/08/29/now-with-more-onions.html) when setting up Onion
Services for the Gopher site(s) I operate on a FreeBSD machine: two different
`rc.d` scripts were conflicting. 

Since Gopher has no ability to consider "virtual hosts" the way an HTTP server
might, I resolved to just run two different invocation of the same daemon
with slightly different parameters. This blog post isn't about Gopher however,
but about getting FreeBSD to run two very similar daemons.

In my first attempt, somehow FreeBSD believed both scripts to be running the
same exact process, for example:

```bash
% service gopheronion status
gopheronion is running as pid 39023.
% service gopher status
gopher is running as pid 39023.
```

My `rc.d` scripts were basically a copy of the [Startup and shutdown of a
simple
daemon](https://www.freebsd.org/doc/en_US.ISO8859-1/articles/rc-scripting/article.html#rcng-daemon)
section of the handbook:

```bash
#!/bin/sh
. /etc/rc.subr

name="gopher
command="usr/sbin/daemon"
command_args="a bunch of args for the gopher server"

load_rc_config $name
run_rc_command "$1"
```

The two scripts were identical except for `command_args`, and somehow _both_
could not run at the same time! I tried changing the names, changing the ordering, and even rewrote the scripts over again just to be safe.

Nothing.

Then I finally broke down and started reading some documentation.

Deep in the `rc.subr(8)` manpage I noticed this note for the `run_rc_command` function:


    procname      Process name to check for.  Defaults to the
                  value of command.

Aha! Both scripts had the same `command` (`/usr/sbin/daemon`), so the machinery
inside of `run_rc_command` was considering them to basically be running the
same process! Adding a different `procname` declaration to each file solved the problem, and voila! Both services were up and running!

```bash
# ...

name="gopher
procname="gopher"
command="usr/sbin/daemon"
command_args="a bunch of args for the gopher server"

# ...
```

