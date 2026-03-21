---
layout: post
title: "Based Lake, a petabyte-scale low-latency data lake"
tags:
- arrow
- parquet
- deltalake
- databricks
- scribd
---


I had a chat today about building large scale low-latency data retrieval
systems around AWS S3. In doing so I got to share a bit of the talk proposal I
submitted to [Data and AI Summit](https://dataaisummit.com) this year about
real-live work that has made it into production.

For years the conventional wisdom around [Delta Lake](https://delta.io) has
been to **not** connect user-facing/online systems to Delta tables. Basically,
don't point your Django app at your Delta tables. This continues to be a decent
_guideline_ but definitely **not a rule** and I have the performance data to
back that up.

My talk abstract:

> Scribd hosts hundreds of millions of documents and has hundreds of billions of
> objects across our buckets. Combining large-language models with a massive
> amounts of text has required investment in our new Content Library
> architecture.  We selected Delta Lake as the underlying storage technology but
> have pushed it to an extreme. Using the same Delta Lake architecture we offer
> both direct data access for data scientists in Databricks Notebooks and online
> data retrieval in milliseconds for user-facing web services.
> 
> In this talk we will review principles of performance for each layer of the
> stack: web APIs, the Delta Lake tables, Apache Parquet, and AWS S3.

The work done by myself and my colleague Eugene in this area has been heavily
related to my previous research around [Low latency Parquet
reads](/2025/06/24/low-latency-parquet.html) which informed work named [Content
Crush](https://tech.scribd.com/blog/2026/content-crush.html), which I have
explored more on the Scribd tech blog and on the [Screaming in the
Cloud](/2026/02/13/screaming-in-the-cloud.html) podcast.

I really hope that I am able to share results at Data and AI Summit from this
incredibly challenging work that I am undertaking. But even if I don't, blog
posts like my musings on [Multimodal with Delta
Lake](/2026/01/19/multimodal-delta-lake.html), [scaling streaming Delta Lake
applications](https://www.buoyantdata.com/blog/2024-12-31-high-concurrency-logstore.html),
and a myriad of other articles I have published can be pieced together to form
the larger mosaic of insane large-scale data work I have been hammering on!
