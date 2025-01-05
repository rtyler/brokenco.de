---
layout: post
title: "Distributed compilation with sccache"
tags:
- sccache
- rust
---

A colleague once told me about their boss whose office door decorated by a
single 8x11 piece of paper with "**speed wins**" scrawled upon it. I didn't
even work for them and I find that motivating. I think about it a lot,
particularly when I'm waiting for [Rust](https://rust-lang.org) builds to
complete. Speed wins, every second counts, and "why is this so fscking slow!"
all run through my mind as units are compiled and linked.

I have the privilege of being paid to do some of my Rust development work, so
not only does speed win, it also enables me to accomplish more in less billable
time; the less I wait the happier everybody will be.

In my home lab environment I probably have over 100 cores of compute at my
disposal, many of them sit around waiting for work from
[Jenkins](https://jenkins.io) and a few of them are busy shuffling bits for
[Mastodon](https://hacky.town/@rtyler), but in my 2025 quest for **more speed**
I decided to put them _all_ to good use with **distributed compilation**.

The primary tool of choice for improving Rust builds is [sccache](https://github.com/mozilla/sccache/), developed by Mozilla. `sccache` provides two different performance enhancement capabilities:

* **Caching of built objects**
* **Distributed compilation of objects**


## Caching

`sccache` is a novel addition to my development alone as a distributed cache.
I switch between projects like
[delta-rs](https://github.com/delta-io/delta-rs) and
[kafka-delta-ingest](https://github.com/delta-io/kafka-delta-ingest) in my
regular course of development, and those two projects have tremendous overlap
in dependency trees. Caching the built transitive dependencies allows a
recompilation of application-specific code to happen _much_ faster.

I use S3-based caching by pushing built objects to a network local
[Minio](https://minio.io) bucket which further enriches the cache as Jenkins
agents can also populate the cache with objects that might be useful for my
interactive development work.

The `sccache`
[configuration](https://github.com/mozilla/sccache/blob/main/docs/Configuration.md)
documentation may be a little out of date, so below is my
`~/.config/sccache/config` file:


```toml`
[cache.s3]
bucket = "cache"
endpoint = "https://my.minio.lan/"
region = "auto"
use_ssl = true
key_prefix = "sccache"
no_credentials = false
```

In addition to the above, I had to slap an AWS profile into `~/.aws/config` and
credentials into `~/.aws/credentials` so that `sccache` would be able to
properly authenticate against the Minio bucket for reading and writing cached
objects.

Distributed caching makes a pretty substantial difference when working on the `deltalake-core` crate:

* `cargo clean && cargo build`, without a cache: `53s`
* `cargo clean && cargo build`, with a populated cache: `17.4s`
* The same build with some local `.rs` file changes: `28.3s`


## Distributed Compilation

Distributed compilation with `sccache` is
[documented](https://github.com/mozilla/sccache/blob/main/docs/DistributedQuickstart.md)
but I found the documentation to be a big confusing. There's a number of moving
pieces and much of the discussion around distributed `sccache` compilation around
the internet focuses on cross-compilation and Windows support, neither of which
are particularly compelling for me.

The key distributed compilation components are:

* Scheduler: just some daemon sitting somewhere that receives requests from clients, and gives work to servers. This functionality is part of the `sccache-dist` binary.
* Server: in Jenkins this would be an "agent", but a server is what does the actual distributed compilation work. This functionality is part of the `sccache-dist` binary.
* Client: you, you are here. A client requests distributed compilation. This is provided by the `sccache` binary.

As best as I can tell, the request flow starts with the client asking the
schedule for some compute. The scheduler then says "hey `serverA` can do some
work for you!", so then the client has to talk directly to `serverA`. This ran
counter to my expectation of the client talking to the scheduler and the
scheduler talking to servers, acting as a broker/proxy to the compilation
infrastructure. This misunderstanding originally led to some incorrect network
layout and problems with firewalls as I was trying to validate distributed
compilation.

The direct network relationship between the client and the server in `sccache` also makes configuration of the servers a little more annoying, since they must known about their routable IP address at a configuration level:

```toml
cache_dir = "/tmp/toolchains"
public_addr = "${IP_ADDR}:10501"
scheduler_url = "REDACTED"

[builder]
type = "overlay"
build_dir = "/tmp/build"
bwrap_path = "/usr/bin/bwrap"

[scheduler_auth]
type = "token"
token = "REDACTED"
```

The configuration management code which provides the above configuration must
be able to identify the correct `public_addr` value, because `sccache-dist`
will bind directly to it!

In my environment, all the build infrastructure is Linux/amd64 based so I have
not spent any time customizing toolchains. I was pleased to find that I didn't
have to for the "basic" set up I have here.


On my workstation, I can run `sccache --dist-status` and observe the performance of the environment as machines come and go, or as jobs get pushed from my local compilations or Jenkins-based ones:

```
{"SchedulerStatus":["REDACTED",{"num_servers":4,"num_cpus":28,"in_progress":0}]}
```

The design of the scheduler allows for compilation infrastructure to be
ephemeral, so as machines come online or go offline, the available capacity
shifts throughout the day. That also means that if I have a lot of work to do,
I can always reach into the rack and turn on another machine or two and let
them join the fleet!

---

Setting up distributed compilation with `sccache` has been on my todo list for probably 2-3 years at this point, so I am thrilled to have it finally configured for a number of reasons. It was worth the effort but my needs and environment may be a little unusual in that I have a _lot_ of Rust code that I need to compile.

I think for most Rust developers, having `sccache` configured on a local
workstation, or on a network local object store, will provide ample performance
improvement for the effort required!

Speed wins.



