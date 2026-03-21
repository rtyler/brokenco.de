---
layout: post
title: "2026 March: Recently Studied Stuff"
tags:
- rss
- arrow
- parquet
- rust
---

Over the past week I have made a more conscious effort to keep track of some
really interesting articles that came through my feed reader. I am a big fan of
the open web and the power of RSS for disseminating interesting information
from actual people. Below are some really interesting posts I have read recently!

**[Compressed Apache Arrow tables over HTTP](https://felipe.rs/2024/10/23/arrow-over-http/)**

When discussing transport protocols for sending data between services at work
recently, a colleague asked "why can't we just yeet Arrow over HTTP?" It turns out, you [absolutely can](https://github.com/apache/arrow-experiments/tree/main/http/get_simple/python) and Arrow IPC streams even have a registered MIME type:

```
Content-Type: application/vnd.apache.arrow.stream
```


**[Understanding Parquet format for beginners](https://blog.dataexpert.io/p/parquet-can-shrink-your-data-100x)**

A great introduction to the [Apache Parquet](https://parquet.apache.org) format
and why it makes so many things better with large data storage systems like
[Delta Lake](https://delta.io). I have written on this
[topic](/tag/parquet.html) before and encourage you to take another read
through [this blog
post](https://arrow.apache.org/blog/2022/12/26/querying-parquet-with-millisecond-latency/)
by some maintainers of the [parquet](https://crates.io/crates/parquet) crate.


**[Every layer of review makes you 10x slower](https://apenwarr.ca/log/20260316)**


> Every layer of approval makes a process 10x slower [..]
>
> Just to be clear, we're counting “wall clock time” here rather than effort. Almost all the extra time is spent sitting and waiting.
>
>  * Code a simple bug fix: 30 minutes
>  * Get it code reviewed by the peer next to you: 300 minutes → 5 hours → half a day
>  * Get a design doc approved by your architects team first: 50 hours → about a week
>  * Get it on some other team’s calendar to do all that (for example, if a customer requests a feature): 500 hours → 12 weeks → one fiscal quarter


This inspired these thoughts which I shared with the [delta-rs](https://github.com/delta-io/delta-rs) community:

"what if we didn't require code review for merging into main"

I'm exploring the thought more about what we might need to make that happen.
"Why would you do such a thing, code review is so valuable!"  I do find code
reviews valuable but we do seem to lose a lot of flow time due to timezones,
differing work schedules, and a number of other things. For something without a
lot of changes, especially bug fixes that come with tests I would be much more
comfortable with maintainers merging once CI goes green.

Some pieces of the puzzle that I think would be needed:

* Soft caps on pull requests. I saw this mentioned somewhere else, but implementing a soft cap of <500 lines per pull request can help people avoid massive unreviewable changes that are simpler to integrate.
* Incorporating some of the benchmarking work into CI that has already been explored. If performance of key operations is not affected and the build is green, go for it.
* Stronger semantic version checks: if our APIs have not changed and all tests pass, I'm generally comfortable with landing stuff by maintainers. 
* Implementing Apache Software Foundation style release candidates and voting: this is where we would put a mandatory bottleneck, rather than some jokey slack emojis like I tend to do, implementing a true release candidate process that requires review and vote before we push something to users.

All of this is to say that reviews can still be requested, but I would love to
see us land more improvements faster and I think we have a bunch of different
schedules that can make pushing each change through a review queue a lot slower
than necessary.


**[Conditional Impls in Rust](https://www.possiblerust.com/pattern/conditional-impls)**

> It’s possible in Rust to conditionally implement methods and traits based on
> the traits implemented by a type’s own type parameters. While this is used
> extensively in Rust’s standard library, it’s not necessarily obvious that
> this is possible.


I have been vaguely aware of this functionality but haven't really taken the
time to consider it, so I really appreciated this post walking through the
conditional impl functionality in Rust.


