---
layout: post
title: "The async stall"
tags:
- software
- rust
- python
---

I am loving the proliferation of async/await-style cooperative multitasking
across different language ecosystems. My first job in San Francisco was
building with greenthreads in Python (2.4!) in an era where Stackless,
Greenlets, and Twisted were all fringe communities inhabited by oddballs like
myself. Nowadays it's a little embarrassing to adopt a toolchain that doesn't
support some form of I/O-evented cooperative multitasking. Node.js, Rust, and
Python all have native support, Ruby's Fiber's seem to have missed the mark but
receive points for effort. All of these tools allow developers to write
simple code that appears procedural but _isn't actually_ at runtime.


The old do-it-mostly-yourself approaches forced the idea of an "event loop" in to our code in a way that the newer async/await semantics hide. 
Deep under the
covers there is a
[kqueue](https://man.freebsd.org/cgi/man.cgi?query=kevent&apropos=0&sektion=0&manpath=FreeBSD+15.1-RELEASE+and+Ports.quarterly&format=html)
or an
[epoll](https://man.freebsd.org/cgi/man.cgi?query=epoll&apropos=0&sektion=0&manpath=openSUSE+42.3&format=html)
which is doing a _lot_ of work for you, and the abstractions are hiding a for
loop that is iterating over file descriptors selecting whichever one is ready
to continue execution.


The naming of the package `asyncio` in Python helps convey that it's for I/O —
network calls, disk reads, waiting on things. That framing is mostly right, but
it invites a failure mode I keep seeing: someone discovers `asyncio` solves
their concurrency problems and but as time goes on they loose track of how it
works, and start CPU-heavy work inside coroutines. It does not end well. The
event loop stalls, tail latencies balloon, and suddenly your health check is
timing out in Kubernetes while your process is contentedly crunching data. 

Once `asyncio` bites, the knee-jerk reaction I have seen is to rip out the
`asyncio` code and go back to the comfortable domain of `multiprocessing` or
equivalent. Hiding from the problem rather than addressing it.


**We can have our cake** while still using `asyncio` for CPU-heavy applications.

Andrew Lamb [spoke about exactly this
problem](https://www.youtube.com/watch?v=FeqRdDG1Y7g) in the context of Tokio:
the fix isn't to avoid the async runtime for CPU work, it's to **stop mixing your
latency-sensitive and compute-heavy work on the same executor**.

The pattern that actually works
is a dedicated `ProcessPoolExecutor` for the heavy lifting, submitted via
`loop.run_in_executor()`, while your event loop stays unblocked and responsive.
Python still has a GIL so there may be some use-cases that still require multi-processing to achieve high levels of performance but a better segmentation of low-latency and compute heavy workload in the `asyncio` eventloop can go a long way.


Some tips to consider:

1. **Don't block the event loop — ever** Async code should never spend a long
   time without yielding. In Python, CPU-bound work in a coroutine starves the
   event loop. Use `await asyncio.sleep(0)` periodically, or offload entirely.

1. **Use a separate executor for CPU work** I have seen errors where an
   applications' health check got blocked by CPU heavy work, leading to
   seemingly interruptions of service as the container orchestrator killed
   unresponsive containers.  

   Run CPU tasks on a *separate* thread/process pool,
   not the same one handling I/O. In Python: `loop.run_in_executor(executor,
   fn)` with a dedicated `ProcessPoolExecutor`. Don't share it with your I/O
   event loop.

1. **GIL means processes, not threads** Unlike Tokio's work-stealing thread
   pool, Python threads don't get true parallelism for CPU work due to the GIL.
   Use `concurrent.futures.ProcessPoolExecutor` instead of `ThreadPoolExecutor`
   for CPU-bound tasks.

1. **Amortize overhead with chunked work** For CPU-heavy workloads in Python
   consider making larger batches when possible,. A method call with a single
   row in a runtime like Python is going to have higher wasted overhead when
   invoking that method 100k times in a tight loop compared to invoking a
   method which is able to handle a batch of 100k rows _outside_ of Python
   (e.g. in a Rust or C extension).

1. **Cancellation and shutdown are hard** Kind of niche advice, but 
   hard with custom schedulers are easy to get 99.9% right but corner cases
   (shutdown, cancellation, draining) waste a bunch of time. Just use the
   off-the-shelf schedulers. In Python, lean on `asyncio.Task.cancel()` and
   `executor.shutdown(wait=True)` rather than rolling your own.


I love to advocate the use of
[Rust](https://rust-lang.org) for lots of projects, but modern Python with
judicious use of `asyncio` and a lot of the more modern APIs available since
Python 3.10-ish make it a much better option for high-performance applications
with a low barrier to entry.
