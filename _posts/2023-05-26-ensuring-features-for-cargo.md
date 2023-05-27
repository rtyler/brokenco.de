---
layout: post
title: "Requiring non-default features to be set in Rust"
tags:
- rust
---

I found myself refactoring a Rust crate in which I had two non-default features
but _at least one_ would need to be set in order for `cargo build` to function.
Cargo allows a `default` feature set, or allows different targets to have
[required-features](https://doc.rust-lang.org/cargo/reference/cargo-targets.html#the-required-features-field)
defined. My use-case is different unfortunately, I wanted slightly different
semantics to support _either_ `s3` or `azure` features. I stopped by `##rust`
on [libera.chat](https://libera.chat) and as usually happens, got a nudge in
the right direction: `build.rs`:


By adding the following to `build.rs` I was able to forcefully halt the build
operation before it even really got started.


```rust
#[cfg(not(any(feature = "s3", feature = "azure")))]
compile_error!(
    "Either the \"s3\" or the \"azure\" feature must be enabled to compile"
);
fn main() {}
```



Using the `compile_error!` macro in `build.rs` ensures that users will _only_
see the following compilation error message, rather than a long list of other
errors which may come from missing feature definitions.

Quick and easy trick to get required non-default features enabled!
