---
layout: post
title: "The last data file format"
tags:
- rust
- parquet
- buoyantdata
- dataeng
---


The layers of abstraction in most technology stacks has gotten incredibly deep
over the last decade. At some point way down there in the depths of _most_ data
applications somebody _somewhere_ has to actually read or write bytes to
storage. The flexibility of [Apache Parquet](https://parquet.apache.org) has me
increasingly convinced that it just might be the **last data file format I will
need**.

In my [previous post](/2025/06/24/low-latency-parquet.html) on the subject I
wrote about the file format's novelty for semi-random data access _inside_ of a
`.aparquet` file. I'm certainly wondering off the beaten path with Apache
Parquet already. _Then_ this blog post kind of blew my mind: [Embedding
User-Defined Indexes in Apache Parquet
Files](https://datafusion.apache.org/blog/2025/07/14/user-defined-parquet-indexes/).

> However, Parquet is extensible with user-defined indexes: **Parquet tolerates
> unknown bytes within the file body** and permits arbitrary key/value pairs in
> its footer metadata. These two features enable embedding user-defined indexes
> directly in the file—no extra files, no format forks, and no compatibility
> breakage. 


Emphasis mine. 

This is news to me.

And this is _absolutely wild_. 

----

The authors' approach for embedding user-defined indexes in Apache Parquet
files is certainly novel and already worth a read. 

But the fact that you can shove arbitrary blocks of bytes in the middle of the
otherwise columnar data format is _incredible_.


Modifications of Apache Parquet files still requires a rewrite of the
object which means `.parquet` is not a file format to be used for heavy data
modification workloads.

Use-cases with large amounts of metadata and binary data however would fit nicely
within this parquet + unknown bytes design. Parquet readers which are ignorant
to the purpose for these unknown byte blocks will completely ignore them. 

Altogether this is a new super
power, and I am contemplating whether I can use it for good or evil..

