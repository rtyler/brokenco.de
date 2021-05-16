---
layout: post
title: Dynamically forwarding SSH ports
tags:
- ssh
- bsd
- linux
---


Working over SSH on a big beefy remote machine is a great way to extend the
life of any laptop, but presents challenges when developing network-based
services. Fortunately OpenSSH has a "port forwarding" feature which has been around for a number of
years. Port forwarding allows the user to tunnel a port from the remote machine back to
their local machine, in essence allowing you to access a remote service bound to port 8000 on your own `localhost:8000`. When I first learned about this, I would fiddle around
with my `ssh ` invocations or hardcode a list of potential ports forwarded in
my `~/.ssh/config`.  If I was working on a new service that needed a port not yet forwarded, I would disconnect, add it to the list of ports in my `config` file, and then reconnect. That was until my pal [nibz
(nibalizer)](https://github.com/nibalizer) showed me how to _dynamically_ add
port forwards to an already existing session.


[OpenSSH](https://www.openssh.com/) provides a number of **escape characters**
that can be used on a running connection, one of these is `~C` which will open
up a little command line interface:

```
❯
ssh> ?
Commands:
      -L[bind_address:]port:host:hostport    Request local forward
      -R[bind_address:]port:host:hostport    Request remote forward
      -D[bind_address:]port                  Request dynamic forward
      -KL[bind_address:]port                 Cancel local forward
      -KR[bind_address:]port                 Cancel remote forward
      -KD[bind_address:]port                 Cancel dynamic forward
```

From this simple command line you can add or remove local, remote, and dynamic
port forwards! Pretty snazzy! When I was first learning how to use these escape
characters I had a difficult time getting the key-combination correct,
frequently I would somehow screw it up and just send `~C` to the shell:

```
❯ ~C
zsh: no such user or named directory: 
```

The approach that I have found most reliable is to hold my left shift key down
while I hit `~` and `C` in sequence. In essence, my left pinky finger keeps
shift depressed while my middle finger and then my pointer finger consecutively
hit the two keys. I share this because when I first started to use these escape
sequences I could never get the timing/cadence correct the first time and it
felt like I was wasting more time than it would take to just disconnect and
reconnect.

Another tip is to make sure you have detached from any active `tmux` sessions, as `tmux` has it's own escape sequences and key bindings that you likely want to avoid triggering.

Once you get the hang of it, you can dynamically allocate new ports for whatever service you're developing and then easily use your local browser/client to access the service under development. Much better!


For more escape characters, refer to the `ssh(1)` manpage via `man ssh` which has a section dedicated to these magic key combos.

```
ESCAPE CHARACTERS
     When a pseudo-terminal has been requested, ssh supports a number of functions through the use of an escape character.

     A single tilde character can be sent as ~~ or by following the tilde by a character other than those described below.  The escape
     character must always follow a newline to be interpreted as special.  The escape character can be changed in configuration files us-
     ing the EscapeChar configuration directive or on the command line by the -e option.

     The supported escapes (assuming the default ‘~’) are:

     ~.      Disconnect.

     ~^Z     Background ssh.

     ~#      List forwarded connections.

     ~&      Background ssh at logout when waiting for forwarded connection / X11 sessions to terminate.

     ~?      Display a list of escape characters.

     ~B      Send a BREAK to the remote system (only useful if the peer supports it).

     ~C      Open command line.  Currently this allows the addition of port forwardings using the -L, -R and -D options (see above).  It
             also allows the cancellation of existing port-forwardings with -KL[bind_address:]port for local, -KR[bind_address:]port for
             remote and -KD[bind_address:]port for dynamic port-forwardings.  !command allows the user to execute a local command if the
             PermitLocalCommand option is enabled in ssh_config(5).  Basic help is available, using the -h option.

     ~R      Request rekeying of the connection (only useful if the peer supports it).

     ~V      Decrease the verbosity (LogLevel) when errors are being written to stderr.

     ~v      Increase the verbosity (LogLevel) when errors are being written to stderr.
```

