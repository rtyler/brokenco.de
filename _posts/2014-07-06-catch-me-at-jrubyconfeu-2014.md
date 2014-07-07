---
layout: post
title: "Catch me at JRubyConf EU 2014"
tags:
- ruby
- jruby
---

This has already been posted on the [Lookout hackers
blog](http://hackers.lookout.com/2014/07/join-us-at-jrubyconfeu) but I figured
I would repost on my personal blog in lieu of actual content.

My colleague [Ian Smith](https://github.com/ismith) and I will be presenting a
talk at [JRubyConf EU 2014](http://2014.jrubyconf.eu/) titled:

> **Building a scalable messaging fabric with JRuby and Storm**.


The abstract can be found below, but since this is my personal blog I'd like to
expand a bit more on why we're giving the talk.

Last year my team and I deployed [ActiveMQ](http://activemq.apache.org) in
order to provide an inter-service messaging bus between a new product we were
developing and some legacy infrastructure at [Lookout](http://www.lookout.com/about/careers/).
Alongside ActiveMQ we deployed a number of different worker daemons to consume
and dispatch messages. These were [JRuby](http://jruby.org)-based processes
that polled a [STOMP](http://stomp.github.io/) connection for new messages and
then performed some amount of "work."

In the process of building out all of this infrastructure we learned a couple
of important lessons:

 * ActiveMQ scales like MySQL. That is to say it kind of *doesn't* scale, the
   most effective way to scale out a number of ActiveMQ brokers is to perform
   some amount of application-layer "sharding" across message brokers. We did
   not do ActiveMQ any favors in attempting to scale it out effectively, so minus one
   point us.
 * Many of our problems became less of shoveling work from a single app server
   into a work-queue, where tools like [Sidekiq](http://sidekiq.com) excel, and
   more about complex message routing and processing, which
   [Storm](https://storm.incubator.apache.org/) was built specifically to solve for.
 * If you provide a good stream of events, everybody, **everybody** will want
   to take part in it. One of the unexpected results of deploying ActiveMQ and
   some messaging facilities was that nearly every team in the company then wanted
   to take part in the event streams. This wouldn't have been a problem if we
   had planned to become the "messaging team" or even had a roadmap to scale out
   the deployment and managing of messaging infrastructure with ActiveMQ+STOMP.
   Alas, we did not, and quickly ran into scaling challenges both technically and
   organizationally.


In our talk, Ian and I will discuss some of these lessons coming from our "old
messaging infrastructure" along with some of the important lessons that we've
learned moving to the newer system. Naturally, neither Storm nor
[Kafka](http://kafka.apache.org) are silver bullets for scalability, but
I believe that they're the right path to moving towards a broader Lookout-wide
messaging fabric.


As previously mentioned, this talk will be at [JRubyConf
EU](http://2014.jrubyconfeu.org) which will be held **August 1st** in Potsdam,
Germany. We hope to see you there!


#### Abstract

> As Lookout has grown the number of backend Ruby services the need for
> reliable, asynchronous service-to-service messaging has gone from "nice to
> have" to "absolute requirement."
>
> Our first attempts included some names you may be familiar with: [ActiveMQ](http://activemq.apache.org/),
> [Resque](https://github.com/resque/resque), [Redis](http://redis.io), and
> [Sidekiq](http://sidekiq.org/). As our infrastructure grew, we found we were
> reinventing many of the concepts "Storm," an open source real-time
> computation/stream-processing system, was specifically designed to handle such
> as message routing, durability, streaming from multiple inputs, delivering to
> multiple outputs, etc.
>
> In this talk we'll cover how we built a scalable service-to-service messaging
> fabric on top of Storm and Kafka, with [JRuby](http://jruby.org) playing a starring role.
