---
layout: post
title: Async sockets in Ada
tags:
- programming
- ada
- epoll
- async
---

Recently I've been experimenting with the concept of a high-performance (high
parallelism, high concurrency, low CPU/memory footprint) TCP server in Ada. Developing on
top of Linux, you cannot help avoid the
[epoll(7)](https://en.wikipedia.org/wiki/epoll) I/O event notification
system.


Unlike my previous post [on dynamic task creation in
Ada](/2013/03/09/dynamic-tasks-in-ada.html), this post won't have much in the
way of sample code and walk-through. Mostly because I didn't want to spend the
entire post explaining `epoll(7)` concepts.

If you're currently unfamiliar with
epoll, I found [this post from
banu.com](https://banu.com/blog/2/how-to-use-epoll-a-complete-example-in-c/)
interesting and useful. In general, I think that it is very useful to
understand how both `epoll(7)` and its BSD-friendly pal `kqueue(2)` work, and
how the two have influenced evented I/O systems that have become popular in the
past few years.


For my experiment, the primary challenge with using `epoll(7)` is wrapping the
C code with Ada, which on its face this isn't terribly difficult. That said,
mapping C arrays and other stupid pointer tricks that C libraries are prone to
using, can make writing an Ada binding much more difficult. I don't
intend to dive too deep into how one can create such a binding since I think
Felix Krause's post on [writing thin/thick C bindings in
Ada](http://flyx.org/2012/06/13/adabindings1/) is a pretty good introduction on
that subject. Personally I prefer "thicker" bindings for use in Ada, just as I
expect Ruby libraries to abstract away the more fickle aspects of the
underlying C API.



What I *did* want to share in this post was the actual **working** results of
my tinkering, which can be found [here, on GitHub](https://github.com/rtyler/ada-playground/tree/master/epollecho).


The basic flow of the program (found in `main.adb`) is similar to the example
found in the `epoll(7)` man page, in that it sets up the `epollfd`, binds the
listening to it and then waits for `Epoll.Wait` to return with an array of
socket descriptors which have activity on them.

My next step is to combine this [basic epoll
binding](https://github.com/rtyler/ada-playground/blob/master/epollecho/src/epoll.ads)
with my [previous task related
code](/2013/03/09/dynamic-tasks-in-ada.html) and create a TCP server which uses
a task pool to perform "work" on the incoming sockets given to it by an
epoll-listener task.
