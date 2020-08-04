---
layout: post
title: "Reclaiming disk space from cargo's target/ directories"
tags:
- rust
---


You never really appreciate disk space until it's all gone. This morning I
noticed that my laptop had come perilously close to exhausting all its
available disk space. Oops! Normally I would prune some Docker images with
`docker system prune -f` but this time around I couldn't blame Docker, the
wasted space was due to [cargo](https://doc.rust-lang.org/cargo/index.html),
critical part of the Rust development toolchain.

When `cargo` does _anything_ within a project directory, it will store all it's
working state (dependencies, etc), inside of the `./target/` directory. The
more projects you work on, the more `target/` directories you will accrue, each
taking up tens or _hundreds_ of megabytes of disk.

I have adopted [cargo-sweep](https://github.com/holmgr/cargo-sweep) to help
grapple with the sprawling disk utilization of my local Rust projects. `cargo
sweep` can be run on a per-project basis or recursively for a file system
subtree with `-r`. In my case, `cron` is going to make sure that my future free
space problems will not be cargo's fault!

```
15 1 * * * ~/.cargo/bin/cargo sweep -r -t 30 ~/source
```


