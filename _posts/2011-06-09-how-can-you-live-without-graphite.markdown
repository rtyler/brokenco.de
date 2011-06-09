---
layout: post
title: How can you live without Graphite?
tags:
- ganglia
- graphite
- lookout
- apture
---

An interesting part of the hiring process at
[Lookout](https://www.mylookout.com/about/jobs) is the candidate presentation.
The presentation is meant to introduce the individual to the entire company
while giving them an opportunity to wax poetic on a topic the person is passionate
about.

As part of my interview process, I decided to present my work with
[Graphite](http://graphite.wikidot.com), a real-time scalable "analytics" tool.

I place the word "analytics" in quotes because Graphite itself is really a tool
for storing an *enormous* number of data points in, whether it be "analytics"
in the product sense of the word, machine metrics, performance counters, or
any other data point that can be recorded and graphed over time.

While at [Apture](http://www.apture.com), I deployed and utilized Graphite
primarily for performance monitoring and profiling. Within days of it being
deployed, I remember [Steven](http://twitter.com/kansteven) turning to me as we
looked over some performance numbers saying "what were we doing *before*?!"

Flying blind, that's what.

I can't recommend Graphite highly enough, but at least one should have a
similar system in place to give the team some level of feedback about **how**
an application is actually performing in production.


My presentation alone isn't terribly informative by itself, but has some pretty
screenshots and graphs. There are no associated notes with the PDF as I felt
comfortable and confident enough discussing Graphite that I ad-libbed my
commentary.

**[Graphite is the new Ganglia.pdf](HTTP://strongspace.com/rtyler/public/Graphite%20is%20the%20new%20Ganglia.pdf)**

