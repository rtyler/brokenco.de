---
layout: post
title: Greetings from the year 2099
tags:
- aws
- scribd
- rust
---

"The difference between the request time and the current time is too large."

I have never seen this error from AWS S3 before. Wednesday afternoon a flurry
of production errors triggered an anomaly alert, each an "access denied" error with the message: "The difference between the request time and the current time is too large."


For a brief moment the unbelievable happened: Ohio was in _the future_.

Somewhere in `us-east-2  AWS had a clock skew incident and some containers
running a critical workload were sending requests to AWS S3 from March of the
year 2099.

The Sigv4 signing that every API call to AWS requires started to fail on
account of this temporal anomaly.

Eventually our stellar account team got back with the appropriately vague
"other customers are also impacted" which is the TAM version of "it's not you,
it's me." 

In my time at [Scribd](https://tech.scribd.com) I have tripped into a surprising number of esoteric AWS issues.

We started moving the entirety of our platform from on-premise infrastructure
to AWS in late 2019/early 2020. Within the first couple of months we
encountered and documented a race condition with AWS S3. At the time it was
like spotting a mythical creature. _I didn't know S3 had bugs._  We would see
and complain about that bug with some regularlity for over a year before it was
finally acknowledged and eventually fixed by the service team.

Since then we have seen more unbelievable creatures, with about one production
impacting bug per year identified in S3 services 


My colleagues and I have also reported multiple bugsin AWS Aurora. One of my
favorites was an export issue that resulted in snapshots suddenly producing
more than 1000x the number of files after a software release. 

At this point I have lost count of the number of "well, that's not supposed to
happen" conversations I have had with AWS support.

The nature of a heisenbug that only appears 0.0001% of the time  means that it
takes substantial campaigning by the customer, the account team, and effort by
the service team to identify and reproduce the problems in a non-production
environment.

The bugs do seem that much more incredible when you finally get a good clean
look at them too.

---

My role at Scribd has afforded me a deep backlog of difficult, interesting, and
valuable problems which require the clever application of infrastructure,
software, and data to solve. Many of the [Rust-based](https://rust-lang.org)
systems or designs that I have shared here are derived from working with
hundreds of billions of objects, trillions of requests, and other very large
numbers.

Very large numbers mean really interesting bugs and Scooby Doo mysteries with
internal customers, infrastructure teams, and cloud partners like AWS.

It's all good fun, and [we're
hiring](https://jobs.ashbyhq.com/ScribdInc/ab6eba49-d919-4fab-a20c-58d8e92adf61?departmentId=0dcadb6f-dafe-46c9-bc81-67f003f26c54)
more detectives!


