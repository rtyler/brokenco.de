---
layout: post
title: Your cargo workspace has a bug, no it's a feature!
tags:
- rust
---

Rust has a useful concept of "features" baked into its packaging tool `cargo`
which allows developers to optionally toggle functionality on and off. In a
simple project features are simple, as you would expect. In more complex
projects which use [cargo
workspaces](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html) the
behavior of features becomes much more complicated and in some
cases..surprising!


This morning I was cutting a new release of the [deltalake
crate](https://crates.io/crates/deltalake) and was surprised to find one of our
sub-crates wouldn't publish!


```
error[E0609]: no field `retry` on type `&StorageConfig`
  --> crates/gcp/src/lib.rs:46:45
   |
46 |         builder = builder.with_retry(config.retry.clone());
   |                                             ^^^^^ unknown field
   |
   = note: available fields are: `runtime`, `limit`, `unknown_properties`, `raw`
```

Much to my chagrin.

This was a build failure in our `main` branch and was only discovered when I
executed a `cargo publish -p deltalake-gcp --dry-run`.

We build on every pull request. Heck, we even build with a whole bunch of
variations of feature flags! How did this get through?


In a workspace project features on the same dependency will be smooshed together.


Our workspace has multiple sub-crates all pointing to the same dependency on [deltalake-core](https://crates.io/crates/deltalake-core) which is in the tree as:

```toml
deltalake-core = { path = "../core" }
```

_Some_ of our crates need features enabled on core such as `cloud`, some don't.
When a `cargo build` is executed in the root of the workspace the
`deltalake-core` dependency in the workspace's dependency tree is smooshed
down, carrying whatever features are defined in the workspace dependency
definitions along with it.


In this scenario the `gcp/Cargo.toml` included the `deltalake-core` dependency
_without_ the necessary `cloud` feature. When building as part of a workspace
wide `cargo build` invocation the features from _other_ crates smooshed
together on the common `deltalake-core` dependency.

When publishing the `deltalake-gcp` crate on its own, the build failure
appeared!


This is a "known issue" with cargo workspaces insofar that I knew of it before
this failure and recall seeing a GitHub issue once upon a time. It's a little
confusing for end-users, but kind of makes sense in the context of cargo
workspace builds.

Still, it's always surprising when it pops up!

