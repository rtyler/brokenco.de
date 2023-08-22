---
layout: post
title: "Why we re-export symbols from other libraries in Rust"
tags:
- rust
- opinion
---

Dependency management in the Rust ecosystem is _fairly_ mature from my perspective, with [crates.io](https://crates.io), Cargo, and some cultural norms around semantic versions, I feel safer with dependencies in Rust than I have in previous toolchains. It's far from perfect however, and [this question](https://mastodon.social/@davidpdrsn/110780897434598935) helps highlight one of the quirks of how Rust dependency management does or does not work, depending on your perspective:

> What is it that makes Rust users want libraries to re-export stuff from other
libraries?
>
> I often get requests for axum to re-export stuff from hyper, time, or other
common crates. Why? Just “cargo add hyper” and you’re good to go. Hyper is in
your crate graph regardless.
>
> I also often get feature requests for the few types axum does re-export so it
does confuse some. That’s why I’m reluctant to just re-export everything.

I started writing up a reply in Mastodon but then I noticed that my words were
approaching the 500 character limit and perhaps this topic wasn't
microbloggable! I help maintain the [deltalake](https://crates.io/deltalake)
package for Rust and we **do** re-export a number of libraries, such as
[arrow](https://crates.io/arrow) of which I am a strong supporter.

The biggest motivation for re-exporting is to preserve ABI compatibility in our
interfaces. For some crates your transitive dependencies may be masked entirely
from the end-user, for example if I pull in the `regex` crate I'm typically
just using it for regular expressions inside my crate and not exposing an
interface which takes a `regex::Regex`. The ABI is safe from transitive version
changes of that crate. If however my crate exposes an API which is dependent on
a transitive dependency then I can have problems with version mismatches. Such
is the case with `arrow` in [delta-rs](https://github.com/delta-io/delta-rs),
which exposes `arrow_array::RecordBatch`. There is a much larger chance of ABI
incompatibilties between a transitive version of arrow needed by the
`deltalake` crate and what the consuming project may specify. This is
exacerbated in our case because _another_ transitive dependency of `deltalake`
specifies a dependency on `arrow`: [datafusion](https://crates.io/datafusion).

That means that the user, `deltalake`, and `datafusion` all have to agree on
the same version of `arrow` for types to properly interoperate between API
calls.

But it gets worse!

The Rust community generally seems to follow semantic versioning, but that
doesn't mean anything about the releases, just the version numbers used for
them. I can make major breaking API changes every one of my 0.x.x releases, or
in the case of `arrow` and `datafusion` I can just increment the major version
every release.

By re-exporting symbols from those two crates, downstream users of the
`deltalake` package will have a stable `RecordBatch` type ABI to work with for
every release, and can _largely_ ignore non-API breaking changes such as
struct layout changes, etc.

I am still mixed on whether _all_ types from other crates exposed in my APIs
should be exported. I think there is benefit to doing so for faster moving
dependencies. In essence:

* `arrow`, moving fast, better user experience to re-export
* `url`, moves slow, very mature, not really needed to re-export.


The judgement call I am typically making is whether this would make my life
easier as a downstream consumer of the crate. It's not that much effort of
maintenance burden to `pub use` something in a crate if that's convenient.



