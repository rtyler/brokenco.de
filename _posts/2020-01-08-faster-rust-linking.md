---
layout: post
title: "Slightly faster linking for Rust"
tags:
- otto
- rust
---

Build performance has always been important to me, but my pain tolerance has
always varied widely depending on the project. The projects I have worked on
which require the JVM, such as [Jenkins](https://jenkins.io) or
[JRuby/Gradle](http://jruby-gradle.org), anything under 30 seconds seems
amazing. For small Node and Ruby projects, anything over a few seconds feels
atrocious. Since I've been hacking with [Rust](/tag/rust.html) lately, I
haven't been able to figure out what constitutes "acceptable."  For my
relatively small project, incremental compilation was very quick, but for some
reason *linking* the project would talk almost **10 seconds**. That seemed
pretty unacceptable.


My first course of action for things I don't understand hasn't really changed
much in the last 15 years: I go complain and look pitiful on IRC. Fed up with
this link time adversely affecting my test-driven development workflow in Rust,
I visited `##rust` on the [Freenode](https://freenode.net) network and asked
for some tips on how to improve link time.

Unfortunately nobody had any good suggestions for measuring or understanding
link time, but since [Otto](https://github.com/rtyler/otto) is open source, I
shared the repository and a couple lurkers in the channel were able to
reproduce the link time, and we all decided: _yes, this is way too slow_. One
suggestion was to try the CLANG linker, rather than use the default GNU `ld`
linker.

We were all independently able to verify that using `lld` brought the link time
from **10s** down to just around **3s**, which is a great improvement! This
change can be codified for Cargo for the snippet below:


**.cargo/config**
```toml
# Dramatically increases the link performance for the eventbus
[build]
rustflags = ["-C", "link-arg=-fuse-ld=lld"]
```

Cargo can [be configured at multiple
levels](https://doc.rust-lang.org/cargo/reference/config.html#hierarchical-structure),
but for my project I opted for `$GITROOT/.cargo/config` rather than adding a
user-global Cargo configuration. I don't believe there is any downside to
making it a user-global, but in my case I wanted to check the configuration
into the project to make sure that other contributors would benefit from the
change as well.


Three seconds for linking my relatively small sample project still _feels_ a
bit long, but then I remind myself that I'm pulling in approximately 255 crates
(!) as dependencies, and that's a _lot_ of linking that needs to be done by the
compiler, even for incremental builds!

If you're looking for faster link-time with Rust, try `lld`, and if that
doesn't work, remove some of the fatter dependencies! :)
