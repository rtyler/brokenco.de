---
layout: post
title: Improving performance with the log crate
tags:
- rust
---

On a small crate I maintain a friendly stranger made a suggestion to improve
performance, by making logging optional.

It is rare that somebody will not only make a pull request to such a niche
crate but they also shared some performance numbers with their change, which I
_always_ appreciate. Bringing receipts to a performance discussion is a
**must**.

The main concern they were addressing was logging statements with the
[log](https://crates.io/crates/log) crate in a tight loop of invocations within
the crate. I was _certain_ this was a common issue and went digging through the documentation again and found **[Compile time filters](https://docs.rs/log/latest/log/#compile-time-filters)**.

With the `log` crate, these `Cargo.toml` features allow you to statically disable the `trace!`, `debug!`, etc macros at compile time, for example:

```toml
xmltojson = "*"
log = { version = "0.4", features = "release_max_level_info"}
```

This would disable any log level more granular than `info!`, effectively disabling `trace!` and `debug!` in the resulting release builds.

Pretty neat!
