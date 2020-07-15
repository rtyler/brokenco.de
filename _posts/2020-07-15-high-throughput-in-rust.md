---
layout: post
title: "Building and debugging a high-throughput daemon in Rust"
tags:
- async-std
- async
- rust
---

The `async`/`await` keywords in modern Rust make building high-throughput
daemons pretty straightforward, but as I learned that doesn't necessarily mean
"easy." Last month on the [Scribd tech blog](https://tech.scribd.com) wrote
about a daemon named [hotdog](https://github.com/reiseburo/hotdog) which we
deployed into production: [Ingesting production logs with
Rust](https://tech.scribd.com/blog/2020/shipping-rust-to-production.html). In
this post, I would like to write about some of the technical challenges I
encountered getting the performance tuned for this
[async-std](https://async.rs) based Rust application.


My
first Bay Area job used a set of libraries with Python that made it similar to
[Stackless Python](https://github.com/stackless-dev/stackless/wiki). Thanks to
that early initiation, I now have a habit of approaching services with "tasks and
channels" in mind. With that in mind, I picked up
[async-std](https://async.rs) and started work on hotdog:


> Hotdog is a syslog-to-Kafka forwarder which aims to get log entries into Apache
> Kafka as quickly as possible.
> 
> It listens for syslog messages over plaintext or TLS-encrupted TCP connection
> and depending on the defined Rules it will route and even modify messages on
> their way into a configured Kafka broker.

What this means as far as application design is fairly simple:

* Listener for syslog connections
* When those connections are accepted, spawn a connection specific handler task
* For each received log line which should be forwarded, pass that along to the task
  which will publish to Kafka.

Refer to the following _amazing_ diagram:

```
                     syslog clients
                      |  |  |  |
                      v  v  v  v
                   +---------------+
                   | Listener Task | (spawning connection tasks
                   +------+--------+  with stream descriptor)
                          |
           +--------------------------------+ 
           |              |                 |
+----------v--------+  +--v---+  +----------v--------+
| Connection Task A |  |  ..  |  | Connection Task N |
+---------------+---+  +---+--+  +----+--------------+
                |          |          |
                +----+     |     +----+ (sending prepared
                     |     |     |       messages over channel)
                +----v-----v-----v-----+
                | Kafka Publisher Task |
                +----------------------+
                   |  |  |  |  |  |
                   v  v  v  v  v  v
                  Apache Kafka Brokers
```

This basic formula is what I followed with the initial versions (released as
0.2.x) and that was _fast_. I used `perf` to profile with real-world traffic
from Scribd, all of which were JSON logs, and the vast majority of time spent
by the daemon was in parsing and serialization overhead. 
Since Rust does not have garbage collection or a "runtime" per se, there is
very little standing between the code and the work it has to do.  When using an
async runtime such as async-std, smol, or tokio, there _is_ however some other
code running around behind the scenes to be aware of.  My profiling against
async-std 1.5.0 did indicate some CPU time being burned while polling on
Futures, but I considered that more than likely to be "my bug" rather than
"async-std's bug."

**I was shocked at how _little_ there was to actually optimize!**

Since I was curious and had time to kill, I rapidly adopted async-std 1.6.0
when it was published. The 1.6.0 release removed the _entire_ async-std runtime
in favor of [smol](https://github.com/stjepang/smol) a new (small) async
runtime for Rust. Having followed the development of smol, I was giddy at the
potential of seeing an **even faster hotdog** after the upgrade was complete.
After my rudimentary local testing, I cut a release and deployed it to
production. 🤞

Performance dropped like a rock.

---

I was stumped. Stuck, I moved on to other projects and kept an eye on smol's
issue tracker to see if anybody else might replicate the issue.

Sometimes it is however more important to be lucky than smart.

I managed to catch the author of smol on Discord, and between them and the
author of async-std I was able to solicit some help in understanding how
performance had cratered so dramatically.
[@stjepang](https://github.com/stjepang) shared [this
gist](https://gist.github.com/stjepang/9bdf8d70d0745ce2a6a5e3d47b12569c) which
allowed for wrapping futures in `Inspect()`, printing out debug information
when futures take far too long to execute. With their help, we were able to
identify a couple of tightly bound CPU-only loops within `hotdog` that through
some fluke had not caused issues under async-std 1.5.0. The more efficient
`smol` under the hood exposed the performance problems, those very same ones
which I had observed before as seemingly excessive CPU time spent on polling
Futures.

The "trick" to resolving the issues is seemingly as old as the cooperative
multi-tasking world itself: throw some `yield`s on it. In async-std this means
`task::yield_now().await;`, which gives the async reactor a breather to let
another task run.

Once the fix ([0.3.3](https://github.com/reiseburo/hotdog/releases/tag/v0.3.3))
had been deployed to production, I finally got the giddy excitement I had
originally hoped for: the cluster scaled down to levels not previously seen.

---

In my opinion, Rust's async runtimes make building high performance
applications relatively straightforward. Unfortunately I don't think they're
easily debuggable at this point. When everything goes great, they're wonderful.
When you find yourself inexplicably blocking _somewhere_ it's tricky to
isolate. I'm sure there will be improvements in this area as time goes on, but
the sharp edges can be a little sharper than somebody coming from Node or Java
might expect.

hotdog is happily running along processing hundreds of thousands of
log lines per minute.

That said, the number of times in my career where a simple yield addressed pesky
performance issues is incalculable. 🙀
