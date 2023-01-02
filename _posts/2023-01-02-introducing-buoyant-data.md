---
layout: post
title: "Meet Buoyant Data, and let me reduce your data platform costs"
tags:
- databricks
- software
- deltalake
- aws
---

One of the many things I learned in 2022 is that I have a particular knack for
understanding, analyzing, and optimizing the costs of data platform
infrastructure. These skills were born out of both curiosity and necessity in
the current economic climate, and have led me to start a small consuhltancy on
the side: [Buoyant Data](https://www.buoyantdata.com/). Big data infrastructure
can be hugely valuable to lots of businesses, but unfortunately it's also an
area of the cloud bills that is frequently misunderstood, that's something that
I can help with!

[Mike Julian](https://www.duckbillgroup.com/about/) from [The Duckbill
Group](https://www.duckbillgroup.com/) once made the proclamation that the way
to _actually_ save money in AWS is to design your infrastructure to be
cost-effective. "Optimization" techniques can only take you so far, and once
you've burned through all the optimizations, you may find yourself needing to
further reduce the cost of your infrastructure and have no more "fat" to trim! In the [first blog post](https://www.buoyantdata.com/blog/2022-12-18-initial-commit.html) I outline a "reference architecture" for a data platform which I **know** is cost-effective, easy to manage, and lends itself well to growth.

Planning for sensible, cost-concious growth is _very_ important. With most data
platforms as they start to prove their value, the organization will bring even
_more_ workloads to them. [If you give a data scientist a good
platform](https://en.wikipedia.org/wiki/If_You_Give_a_Mouse_a_Cookie), they
will find themselves wanting ever more from that data platform, and Buoyant
Data can help make sure that growth is sustainable **and** the value to the
business is easy to identify as well.


Please add the Buoyant Data [RSS feed](https://www.buoyantdata.com/rss.xml) to your reader, as I have a number of blog posts queued up already with some gratis tips and tricks for understanding the cost of your data platform! 😄

---

The technology stack for Buoyant Data is something I cannot wait to write more
about. After funding the creation of
[delta-rs](https://github.com/delta-io/delta-rs) as part of my day job, I am
utilizing the library in a **big** way to build extremely lightweight and
cost-efficient data ingestion pipelines with Rust and AWS Lambda. There's still
plenty of space for [Apache Spark](https://spark.apache.org) on the querying
and processing side, but as
[DataFusion](https://github.com/apache/arrow-datafusion) matures, I'm looking
forward to exploring where that can fit into the picture.


There's a lot of evolution happening right now in the data and ML platform
space, I'm really looking forward to growing [Buoyant
Data](https://buoyantdata.com) in my spare time!
