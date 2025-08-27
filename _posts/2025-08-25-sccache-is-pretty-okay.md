---
layout: post
title: sccache is pretty okay
tags:
- rust
---


I have been using `sccache` to improve feedback loops with large Rust projects
and it has been going _okay_ but it hasn't been the silver bullet I was hoping
for. [sccache](https://github.com/mozilla/sccache) can be easily dropped into
any [Rust](https://rust-lang.org) project as a wrapper around `rustc`, the Rust
compiler, and it will perform caching of intermediate build artifacts. As
dependencies are built, their object files are cached, locally or remotely, and
can be re-used on future compilations. `sccache` _also_ supports distributed
compilation which can compile those objects on different computers, pulling the
object files back for the final result. I had initially hoped that `sccache`
would solve all my compile performance problems, but surprising to nobody,
there are some caveats.

## Caching of built artifacts

Artifact caching works _fairly_ well. I think `sccache` is probably a good
default for _most_ people developing Rust projects. The only "downside" with local artifact caching is potential excessive use of disk space. I put that downside in quotes because we technically already have that problem when switching between multiple Rust projects on a single machine, as the `target/` directories can blossom into the _hundreds_ of gigabytes.

At least with `sccache` that disk usage can be centralized into a singular
place for re-use across projects that have common dependencies, like tokio,
serde, etc.

`sccache` can be used as a **distributed cache**, to S3 or other storage
backends. In my local network all the computers that perform Rust compilation
tasks, workstations, laptops, etc, share a LAN local S3-like bucket.

The benefits:

* Disk usage is pushed over to a machine with a _bunch_ of fast SSDs and many terabytes of storage.
* Builds occurring in background processes like continuous integration runs can
  seed the cache for my development workloads.
* Retrieving a built artifact over a 10GigE link is pretty fast, usually faster than compiling source code!

The trade-offs:

* Cache poisoning is _rare_ but can happen. I have had some corrupted objects
  get published that tainted all builds retrieving the cached artifact until I
  had to purge it. Even a 0.001% failure rate will crop up with enough objects and enough rebuilds.
* Server overload! For projects which have a lot of dependencies, a new clean
  build will issue a swarm of object retrievals which has a noticeable overhead
  on the object storage server.
* Related to the server overhead, I have experienced _slower_ builds when using
  `sccache` during times of excessive server load. This is somewhat in my
  control so manageable, but in situations where a developer is using remote
  object storage and their connectivity to the remote object store is slow or
  has errors, using `sccache` can slow down the build if it times out while retrieving objects
  and has to recompile locally.

Because of this I recommend most folks use `sccache` either locally or within
their network. If building inside of AWS, then S3 can be considered local, but
I would not use S3 as an artifact cache for local development.

## Distributed compilation

I was _most_ excited about distributed compilation with `sccache` but found practically zero real-world experiences with `sccache` for distributed compilation in the ecosystem..

It seems like Mozilla uses it heavily, maybe? But not too many other visible users have shared their experiences.

The [distributed
quickstart](https://github.com/mozilla/sccache/blob/main/docs/Distributed.md)
documentations was sufficient for me to get infrastructure up and running in my
home lab environment, but I would not call this a generally user-friendly thing
to set up.

(The fact that I have a "home lab" already puts me in a fairly small cohort of
developers silly enough try to run distributed compute services)

For cross-compilation, or any compilation of Rust projects where you have
different toolchains or architectures to target such as `arm64`, I am not
convinced distributed compilation is worth the trouble.

For distributing compilation of Linux/x86_64, it's worth considering with the following caveats:

* Most Rust projects do **not** have a heavily parallelizable compile phase. If
  your local machine has 16 cores and your distributed compute has 64 cores
  available, distributed compilation is only really going to be beneficial if
  `cargo` can parallelize the work across more than 16 cores! `cargo build
  --timings` will produce a pretty good visualization of how sequential or
  parallel your builds _actually_ are.
* Heterogeneous compilation capacity can cause trouble. If all the build
  machines are _equally capable_ then distributed compilation can be useful.
  **However** if some machines are _slower_ than others, build performance can
  suffer if unlucky builds are pushed to slower machines which then slow down the
  sequential compilation of the project.

## Linking

The **biggest** performance bottleneck that I have seen, which `sccache` can do
nothing to help you with is **linking** the project. If the project has 500
crates, there are at least 500 objects that need to be linked **on your
machine** when you run `cargo build`.

There is no way around the singular bottleneck at the end of the build
pipeline. Adopting the [mold](https://github.com/rui314/mold) linker can help
with linking performance, but it's still on _one machine_. Distributed compilation does nothing to help with the linker stage, and in fact some linkers are even _single-threaded_ because at the end of the day: you have to pull all these objects together!

When linking is the bottleneck, the only solution is faster disk I/O. SSDs,
arrays of SSDs, then NVMe, then arrays of NVMe! More IOps!


---

`sccache` is a fantastic tool, a default in all my build environments. I
recommend it highly to everybody doing Rust development but it cannot perform performance miracles :)
