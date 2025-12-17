---
layout: post
title: Parallelism is a little tricky
tags:
- rust
- deltalake
---

In theory many developers understand concurrency and parallelism, in practice I
think almost none of us do. At least not all the time. Building a mental model
of highly parallel interdependent software is incredibly time-consuming,
difficult, and error-prone. I have recently been doing a _lot_ of performance
analysis with both [delta-rs](https://github.com/delta-io/delta-rs) and
[delta-kernel-rs](https://github.com/delta-io/delta-kernel-rs). In the process
I have had to check some of my own assumptions of how things _should_ work
compared to how they _do_ work.

---
Sidenote: to get an idea of how frequently we all "get it wrong", subscribe to Aphyr's [Jepsen blog](https://jepsen.io/blog) for distributed systems safety research.

---


The Delta Lake Rust binding has relied on [Tokio](https://tokio.rs/) since the
beginning, which as any `/r/rust` commenter knows is an easy turbo button to
solve all your performance and parallelism needs!

When we were designing kernel however, there was a strong motivation _not_ to
take a direct dependency on Tokio. Due to some early influences in the project,
there was a pretty strong push to support C/C++ based engines with
delta-kernel-rs. Those engines would need a Foreign-function Interface (FFI)
and pushing something like Tokio or even
[futures](https://docs.rs/futures/latest/futures/) over an FFI boundary was
unsavory to say the least.

What may be one of our original performance sins in kernel was designing APIs
around the [Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
trait. I am writing this partially to help form my thoughts, but consider this screenshot from
[Hotspot](https://github.com/KDAB/hotspot) showing Tokio tasks doing the work of "log replay" when opening a large complex Delta table:

![Context switching in tasks](/images/post-images/2025-12-delta-rs/tokio-thread-switching.png)

These two tasks are _concurrent_ but they are not parallel. In `Iterator`
terms, this is about what I would expect to see. The conceptual model for execution is:

1. `Iterator` created.
1. `next()` is invoked
1. "do work"
1. return result
1. `next()` is invoked

The fact that work is being done on different tasks is irrelevant. `Iterator`
is lazy, but is only going to "do work" when it is asked, thus a serial
invocation model.

When parallelism is designed, that means work **must** be done at the same
time, but it does not necessarily mean that it must be done "lazily" in the
style of the `Iterator` trait.

In delta-rs [Robert](https://github.com/roeap) pulled in some code from
[Datafusion](https://datafusion.apache.org) which relies on Tokio's
[JoinSet](https://docs.rs/tokio/latest/tokio/task/struct.JoinSet.html) API.  The `JoinSet` is effectively what we want if we want an Iterator-style parallel work executor:

1. `JoinSet` created, "do work" begins
1. `next()` is invoked
1. return result
1. `next()` is invoked
1. return result
1. "do work"
1. `next()` is invoked
1. return result

Currently the use of `JoinSet` happens much higher in the stack inside of
delta-rs, but does _not_ happen deeper down in the delta-kernel-rs code.

What the profiling _likely_ indicates is that there are serial `Iterator`
executions happening in the kernel layer which lead to a bottleneck for
callers, regardless of how parallel-capable those callers may be.

---

Tokio has received criticism in the past about its suitability for heavy
CPU-bound operations. Its async/await primitives work incredibly well for
anything which has I/O wait involved. The scheduler can switch between tasks
when a socket is awaiting data, making it highly concurrent for I/O-bound
applications. Tokio functions similarly to Goroutines in Golang, greenlets in
Python, etc. As I dug deeper into this problem I wanted to ensure that Tokio
was going to behave as I expected with CPU-bound operations.

I compared performance of a `JoinSet` based program which generates
RSA keys, and a [rayon](https://crates.io/crates/rayon) based program. Both are
close enough in performance and parallelism. Both effectively used all
available cores when the Tokio runtime was configured with a single worker
thread per core.

---

Coming back to the Delta Lake ecosystem and our beloved `Iterator`. I think
there are two paths ahead:

* The Easy Road: taking `JoinSet` into the default engine of delta-kernel-rs
  will at least alleviate some of the "concurrent but not parallel" problems
  that are lurking down there.
* The Hard Road: attempting to put a synchronous `Engine` interface in front of
  inherently I/O bound operations is going to lead to performance deficiencies
  compared to an evented system like Tokio or anything else with a kqueue/epoll
  reactor at its core. Putting async/await at the foundation of delta-kernel-rs
  would allow for driving more concurrent and parallel behavior depending on
  the use-case.


The performance of delta-rs is major focus for my work in the project. In 2026 I look
forward to sharing more analysis and more [pull
requests](https://github.com/delta-io/delta-kernel-rs/pull/1561)!


