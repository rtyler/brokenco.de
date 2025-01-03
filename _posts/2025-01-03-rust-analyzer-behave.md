---
layout: post
title: "rust-analyzer vs. the world"
tags:
- neovim
- rust
---

I have recently been on a quest to get _more speed_ from my Rust development
environment, and today's "why is this so fscking slow!" culprit is
**rust-analyzer**.A larger project like
[delta-rs](https://github.com/delta-io/delta-rs) benefits from IDE-like
machinery to help work across a sprawling codebase written in Python and Rust.
[rust-analyzer](https://rust-analyzer.github.io) helps greatly with that, but
it comes with a speed penalty.

The tool aims to:

>  Bringing a great IDE experience to the Rust programming language

When used with [rustacean.vim](https://github.com/mrcjkb/rustaceanvim) in my
Neovim configuration I get inline rustdocs, syntax validation as I type, and a
suite of other helpful tools, but it comes with a speed penalty.

Opening a single _large_ `lib.rs` file typically means a `rust-analyzer`
process is spun up in the background which is effectively parses the Rust
file(s) in scope and produces the necessary information to provide Language
Server Protocol (LSP) responses to Neovim. This compilation sits on top of the
existing project's compilation, which _could_ be good. It _could_ be good in
other projects, but not quite for delta-rs where we have a menagerie of
different crates and build patterns.

Switching to build the Python **always** resulted in a full recompile.
Building the Rust-only crates didn't cause that behavior, but something about
our Python package always caused a full recompile when switching between my
editor and the `make` invocations to build the package.

Savvy rust developers may have a hunch on the problem already: if RUSTFLAGS are
changed, the entire build is effectively tainted by `cargo` and must be
recompiled.

`make` has one set of flags. `rust-analyzer` has another set. Never the twain
shall meet.

Trying to find an way to rectify this situation I stumbled into the
[rust-analyzer
configuration](https://rust-analyzer.github.io/manual.html#configuration) where
I discovered the `cargo.targetDir` directory.

I also discovered this tidbit deep in the README for `rustacean.vim`:

. By default, this plugin will look for a `.vscode/settings.json` file and
> attempt to load it. If the file does not exist, or it can't be decoded, the
> server.default_settings will be used.


_It can't be that simple can it?_

I introduced a `.vscode/settings.json` into my local working directory with the
following snippet, which will cause `rust-analyzer` to use its own target
directory inside the existing `target/`:

```json
{"rust-analyzer.cargo.targetDir" : true }
```


The trade-off is that instead of a speed penalty, there is a disk storage
penalty as redundant copies of compiled objects are stored in `target/`. In my
situation the compile time seed switching between my editor and the
unit/integration tests is far more valuable than a few extra _gigabytes_ (oof)
on disk.


Even with this improvement, I still have a need.


A need for speed.
