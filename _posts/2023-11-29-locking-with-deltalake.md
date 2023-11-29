---
layout: post
title: "Improving lock performance for delta-rs"
tags:
- buoyantdata
- deltalake
- rust
---

I have had the good fortune this year to help a number of organizations develop
and deploy native data applications in Python and Rust using a project I helped
found: [delta-rs](https://github.com/delta-io/delta-rs). At a high level
delta-rs is a Rust implementation of the [Delta Lake
protocol](https://github.com/delta-io/delta/blob/master/PROTOCOL.md) which
offers ACID-like transactions for data lake use-cases. One of the big areas of
my focus has been in evaluating and improving performance in highly concurrent
runtime environments on AWS.

To help others understand the problem domain I spent some time earlier in the
week documenting the challenges in AWS on the Buoyant Data blog: [Concurrency
limitations for Delta Lake on
AWS](https://www.buoyantdata.com/blog/2023-11-27-concurrency-limitations-with-deltalake-on-aws.html)

> In the case of AWS S3's consistency model many operations are strongly
> consistent, but concurrent operations on the same key are not. AWS encourages
> application-level object locking, which the delta-rs implements using AWS
> DynamoDB.

AWS S3 is an incredible piece of technology that washes away a myriad of common
storage problems, and has been jokingly referred to as "the 8th wonder of the
world" by [Corey Quinn](https://www.lastweekinaws.com/). THe lack of a
"putIfAbsent" like semantic is however _very_ annoying for the Delta Lake
protocol, adding the need for an application-wide *lock* for Delta users:

> The dynamodb-lock approach allows for some sensible cooperation between
> concurrent writers but the key limitation is that all concurrent operations
> must synchronize on the table itself. There is no smaller division of
> concurrency than a table operation

In the blog post I offer some potential approaches to mitigate the weakness of
needing a table-level lock for concurrent Delta Lake writers on AWS, but the
problem will unfortunately remain until in some form or fashion until S3
introduces a "putIfAbsent" semantic which allows writers to "put" a file only
if it doesn't exist in an atomic way.

For concurrent Delta writers I can offer some advice, but unfortunately
effective cooperative distributed concucrrency at scale remains a challenging
problem! :)



