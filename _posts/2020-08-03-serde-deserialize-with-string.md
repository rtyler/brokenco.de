---
layout: post
title: "Using serde's deserialize_with to handle custom strings"
tags:
- rust
---

I stumbled across a crate which implemented string parsing that I
wished to incorporate into some of my [serde.rs](https://serde.rs)
deserialization code. Unfortunately the crate in question,
[cron](https://github.com/zslayton/cron) does not implement the
`#[derive(Deserialize)]` macro on its `Schedule`, so I needed to fiddle with
one of serde's "field attributes" in order to move forward: `deserialize_with`.

Below is an example of my code, which was inspired by
[this comment](https://github.com/serde-rs/serde/issues/1174#issuecomment-372411280)
I stumbled across on GitHub:


```rust
use serde::de::{Deserialize, Deserializer};
use std::str::FromStr;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Trigger {
    #[serde(deserialize_with = "deserialize_cron_schedule")]
    cron: cron::Schedule,
}

fn deserialize_cron_schedule<'de, D>(deserializer: D) -> Result<cron::Schedule, D::Error>
where D: Deserializer<'de> {
    let buf = String::deserialize(deserializer)?;

    cron::Schedule::from_str(&buf).map_err(serde::de::Error::custom)
}
```

I won't bother to explain what's going on here, because I don't understand much
of it anyways. But the gist is that `String::deserialize` gets us a `String` to
work with, which can then be passed along to the "real" parsing code.

I hope this code snippet helps, I know it will sure make deserializing certain
types of strings in my serde types _much_ easier!

