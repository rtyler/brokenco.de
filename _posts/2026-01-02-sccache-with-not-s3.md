---
layout: post
title: "Using sccache with not-S3"
tags:
- rust
- sccache
---

On a day-to-day basis I build a _lot_ of Rust code. To make my life easier I
use [sccache](https://github.com/mozilla/sccache) which I have written about
[previously](/2025/01/05/sccache-distributed-compilation.html). Periodically
the `sccache` daemon would exit and then no longer authenticate against my
local network's not-S3 service.

`sccache` would fail a `cargo build` command with an error like the following:

```
  sccache: error: Server startup failed: cache storage failed to read: Unexpected (temporary) at read => loading credential to sign http request

  Context:
     called: reqsign::LoadCredential
     service: s3
     path: .sccache_check
     range: 0-

  Source:
     error sending request for url (http://169.254.169.254/latest/api/token): operation timed out
```

Typically I would hit this error when I was busy, so I would disable `sccache`
by setting `RUSTC_WRAPPER=` in my environment. With a little more time on my
hands this winter holiday I went spelunking around in the `sccache` code and
found the issue!


That IP address is the AWS IMDSv2 service, which is actually being queried by
[Apache OpenDAL](https://github.com/apache/OpenDAL) for credentials. Were I on
an AWS EC2 instance, this would return a token brokered by AWS STS allowing me
to use the instance's role. Since I'm not on an EC2 machine and not even
remotely close to AWS, I needed make `sccache` avoid this check.

Somewhat paradoxically, when `sccache` is configured _not_ to use credentials
it won't enable the IMDSv2 feature in `opendal` _but_ the `opendal` subsystem
will still use the credentials defined in `~/.aws/credentials` associated with
my current `AWS_PROFILE`.

Quirky!


Updating my shell configuration with the following environment variable has made `sccache` easy breezy again!

```
export SCCACHE_S3_NO_CREDENTIALS=true
```
