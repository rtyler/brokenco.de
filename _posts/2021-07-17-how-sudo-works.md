---
layout: post
title: How sudo gets root
tags: 
- security
- linux
- unix
---

Today I fell into a rabbit hole around user and process
permissions and had to learn how `sudo` actually worked. For the program I was
working on I set out to figure out how to perform something akin to a "user
swap" when launching subprocesses. On its face it seems simple enough, my
program runs with user id `1000` and I wish to shunt child processes over to
run as another user id. `sudo` can do it, so why can't I? "For reasons" is the answer.

The alternative for this post could be "unix permissions are insane".

Regardless of whether spawning a child or doing something within the process
for modifying "who" is running a program is effectively the same. The program
runs with the user id (`uid`) of the caller, so in the case of your shell which
is running as you (often `uid` of `1000`) and spawned process will inherit the
same `uid` .

In a C program, I can however reassign my process' `uid` with
the `setuid(2)` system call:

> **`setuid()`** sets  the  effective  user  ID of the calling process.  If the
> calling process is privileged (more precisely: if the process has the
> **CAP_SETUID** capability in its user namespace), the real UID and saved
> set-user-ID are also set.

(In Rust this function is helpfully exposed via [the nix crate](https://docs.rs/nix/0.22.0/nix/unistd/fn.setuid.html).)

My normal shell user is _not_ the `root` user and therefore in just about every
program I execute, they cannot use `setuid(2)` to change to **any other user
id**.

If processes spawned by my user cannot assume other user ids, how the heck does
`sudo` do it?

Based on the man page excerpt above, it's easy to assume that perhaps the
process has the `CAP_SETUID` capability? Per-file capabilities are a Linux-ism which exposed to user-land via libcap:

> Libcap implements the user-space interfaces to the POSIX 1003.1e capabilities
> available in Linux kernels. These capabilities are a partitioning of the all
> powerful root privilege into a set of distinct privileges. 

These capabilities _can_ provide the desired `setuid` functionality, but they
can also be dangerous and lead to vulnerabilities.  [This blog
post](https://steflan-security.com/linux-privilege-escalation-exploiting-capabilities/)
has a simple demonstration of using `CAP_SETUID` to gain root on a machine.  We
can check whether the `sudo` binary has this capability with the `getcap`
program, which is not always in the distribution's default packages:

    ❯ sudo getcap `which sudo`
    
    ❯

Unfortunately it looks like `sudo` has no special file capabilities,
fortunately there is _one_ other way to for a program to run with `root`
privileges, but if you don't know where to look, good luck finding it!

The file system contains a little bit more information about an executable
referred to as the "setuid bit". Using `chmod` you take a binary that you own,
set the "setuid bit" and then whenever _any_ user runs the binary, it will run
as your user. Naturally if a binary is owned by root with the setuid bit set,
any caller of that binary will run the binary **as root**.

This is exactly what sudo does, which you can check just by exampling the file mode:

    ❯ ls -lah `which sudo`
    -rwsr-xr-x 1 root root 181K May 27 07:49 /usr/bin/sudo
    ❯
    
Note the `rws` at the beginning of the mode string, this means read (`r`),
write (`w`), and setuid (`s`) are all set at the user level on the file.
Additionally the executable (`x`) bits allow all users within the `root` group,
and _everybody else_ to execute the file.

Sudo basically starts out as `root` and then will read its configuration file
and validate/drop permissions as necessary. Since the program is running with
the `root` level privileges, it can easily call `setuid(2)` type functions and
change to _any_ user on the system.

Should you wish to explore _exactly_ how sudo works, the [source code is on GitHub](https://github.com/sudo-project/sudo).

---

There is effectively no user hierarchy in Unix-inspired systems, there is
_root_ and then there is everybody else. Unfortunately for my hacking this
means I cannot have a user (`1000`) launch a process with a "lateral" user
permission such as uid `1001`. I would first need to escalate privileges in
some manner from `1000` to `root` and then drop back down again to `1001`.

If you ever see a program that "drops privileges" such as Docker, Nginx, or Systemd, just
remember that in there is no dropping privileges without first escalating to
`root` in a Unix-inspired system!

