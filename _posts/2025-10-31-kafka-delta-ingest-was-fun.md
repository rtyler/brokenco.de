---
layout: post
title: "The end of the road for kafka-delta-ingest"
tags:
- s3
- deltalake
- kafka
- rust
---


After five years in production kafka-delta-ingest at Scribd has been shut off
and removed from our infrastructure.
[kafka-delta-ingest](http://github.com/delta-io/kafka-delta-ingest) was the
motivation behind my team creating
[delta-rs](https://github.com/delta-io/delta-rs), the most successful open
source project I have started to date. With kafka-delta-ingest we achieved our
original stated goals and reduced streaming data ingestion costs by **95%**. In
the time since however, we have _further_ reduced that cost with even more
efficient infrastructure.

The original kafka-delta-ingest/delta-rs implementations were created by the
joint efforts of the following talented developers across _three continents_ in
the middle of 2020, an otherwise totally chill time in world history.

* [QP Hou](https://github.com/houqp)
* [Christian Williams](https://github.com/xianwill)
* [Mykhailo Osypov](https://github.com/mosyp)
* [@nevi-me](https://github.com/nevi-me)


Prior to our creation of delta-rs, the only way to read and write [Delta
Lake](https://delta.io) tables was through [Apache
Spark](https://spark.apache.org). While it is an incredibly powerful tool for
reading and transforming data, it is completely slow and overweight for the
task of high-throughput data ingestion. QP and I found ourselves loving
[Rust](https://rust-lang.org) and I was able to corner the funding to get the
project started on the promise of lower operational costs.

Boy howdy has the investment in Rust delivered. The implementation of kafka-delta-ingest dramatically lowered our operation costs as Christian shares in this video:

<center><iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/do4jsxeKfd4?si=vAgTIsWWn4k7f5qi" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe></center>

Christian also shared some [architecture and discussion in this
video](https://www.youtube.com/watch?v=mLmsZ3qYfB0), which I think are useful
for anybody building streaming systems around Delta Lake.

Here's a [demo by Christian](https://www.youtube.com/watch?v=JvonUisY7vE&t=51s) too!

---

The reason kafka-delta-ingest was decommissioned ultimately was that I created an _even
cheaper_ ingestion process. My work on the
[oxbow](https://github.com/buoyant-data/oxbow) suite coupled with
[the medallion
architecture](https://www.databricks.com/glossary/medallion-architecture)
has made contemporary Delta Lake ingestion less than 10% of the total data
platform cost.

The big argument against kafka-delta-ingest was [Apache
Kafka](https://kafka.apache.org). If an organization has Kafka for other
reasons, then kafka-delta-ingest can be a useful "sidecar" process to persist
data flowing through Kafka. If however the organization is running Kafka _just_
for ingestion, there are cheaper options available. As the organization
evolved, the other consumers of Kafka drifted away, driving the value
proposition of kafka-delta-ingest lower and lower.

This doesn't mean kafka-delta-ingest is not _useful_, it's just no longer
useful at Scribd.

---

[Kyjah Keyes](https://github.com/mightyshazam) and I are the maintainers of
kafka-delta-ingest and we now are both in the position of _not actually using
it_ anymore.

I will continue to make delta-rs upgrades to it, since kafka-delta-ingest
continues to be a useful test bed for API changes and integration testing, but
I don't have big plans or ideas on how to grow the project further.



