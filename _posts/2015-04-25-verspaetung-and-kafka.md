---
layout: post
title: "Measuring slow Kafka consumers with Verspätung"
tags:
- kafka
- opensource
- verspaetung
---

Late last year I changed roles at [Lookout](http://lookout.com/about/careers)
from the 'Engineering Lead' of the Enterprise team, to the
'Engineering Manager' for the "Core Systems" team. I've not been keeping track
of whether this means I'm writing more, or writing less code on a week-to-week
basis. But the charter of Core Systems does mean much more of the software and
tools we write can be open sourced, or even started as open source projects.

One such project "[Verspätung](https://github.com/lookout/verspaetung)," a tool
which aims to help identify delay of Kafka consumers, was started from the
beginning as an open source project. From [our hackers blog post about
it](http://hackers.lookout.com/2015/04/measuring-kafka-verspaetung/):

> Verspätung is a Groovy based daemon which implements a few key behaviors:
>
>  * Subscribes to Zookeeper subtrees for updates
>  * Periodically polls Kafka brokers using the Kafka meta-data protocol
>  * Exposes offset deltas to be consumed by metrics systems (e.g. Datadog)


I started hacking around a bit in early January of this year, but Verspätung
was not my focus for quite a while. When we first rolled out
[Kafka](http://kafka.apache.org) we hummed along with subpar consumer health
metrics. As more internal consumers came online, developers would see behaviors
that could be described as "my consumer has stopped processing messages."

Without good monitoring in place, and a little bit of emotional baggage coming
from less stable messaging systems, developers would more often than not bounce
the alert to Core Systems.


> "Clearly Kafka isn't delivering messages!"


Each alert bounced to my team would lead us to do some digging into Kafka, only
to discover that everything was functioning properly, and in fact, the consumer
encountered a bug that caused it to stop processing messages.


After a few rounds of this, I decided to stop being dumb and write a tool.

## Writing it

In between my management and leadership responsibilities, there's not a lot of
time these days for hours of sustained development time. As a result, Verspätung was written
in small stretches over the course of a couple months.

Unlike most of my work in the past, written in Python or Ruby, I decided to
build [Verspätung](https://github.com/lookout/verspaetung) in
[Groovy](http://groovy-lang.org), a dynamic language on top of the JVM.

Having spent more time recently in Groovy while writing some
[JRuby plugins for Gradle](https://github.com/jruby-gradle), I've grown fond of
the language and the ease by which I can incorporate more native Java code.
It's not
replacing [JRuby](http://jruby.org) in my mind, but where I find myself wishing
for a stricter type-checking system and more robust debugging support, Groovy
is fast becoming my language of choice.

I could have accomplished this task with pure Java, but until JDK8 becomes more
standardized, I cannot live without closures (lambdas in JDK8). Some of the
syntax sugar that languages like Groovy and Ruby have had for ages, have only
recently made their way into the Java world.


As outlined in the [hackers blog post on
Verspätung](http://hackers.lookout.com/2015/04/measuring-kafka-verspaetung/),
the tool itself isn't that big, but rather glue to tie together some fantastic
open source Java libraries together. Namely: [Apache
Curator](http://curator.apache.org/), [dropwizard
metrics](https://dropwizard.github.io/metrics/3.1.0/) and the Kafka client
library.

Thus continuing a habit that I started to form when writing JRuby. First dig
around as much as possible for existing code or libraries which already
implement parts of what I want to do, then glue them into my application.
Nobody would be impressed if I were to have implemented Curator's
[TreeCache](http://curator.apache.org/curator-recipes/tree-cache.html) code in
Groovy or Ruby, but show them pretty graphs without a lot of development time,
that's more impressive!

----

Verspätung is MIT licensed, was developed from the start as a Lookout open
source project and will help you ensure Kafka consumers aren't delayed. If
you're using Kafka, I hope you find it useful!


(p.s. [Lookout is hiring](https://www.lookout.com/about/careers) for my team
and others too!)
