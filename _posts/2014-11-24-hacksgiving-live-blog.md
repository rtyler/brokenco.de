---
layout: post
title: "Open Hacksgiving 2014 Live Blog"
tags:
- lookout
- hacksgiving
- lookouteng
- opensource
---

For the past three years at [Lookout](http://hackers.lookout.com) we've hosted
an event called "[Hacksgiving](http://hacksgiving.com)." Historically the event
has been focused on cool hacks typically oriented around projects or ideas that
are internal to Lookout. The first year, for example, a colleague and I
prototyped the messaging system that would power our [business
product](https://www.lookout.com/enterprise-mobile-security) the following
year. Another group of hackers created the precursor to our [signal
flare](http://techcrunch.com/2012/10/09/lookouts-signal-flare-helps-you-find-lost-android-phones-that-have-dying-batteries/)
feature that same year (hif I'm remembering correctly).

This year I figured I'd try something different: **Open Hacksgiving**. I'm going to
spend the hackathon hacking on open source projects and updating the status of
those projects here.

I'll also be lurking in [this gitter.im
chat](https://gitter.im/lookout/hacksgiving.com) if you're feeling bored or
want to suggest some issues from GitHub for me to hack on.


<a name="updates"></a>
## Updates

* (13:17 PDT) Concluding the live blogging, and am going to spend some time
  writing up docs and what not. Happy Hacksgiving!
* (12:09 PDT) Further testing on different machines exposed [this bug
  (#503)](https://github.com/ratpack/ratpack/issues/503) in Ratpack, forcing a
  requirement of JDK8 :(
* (11:22 PDT) Cut the
  [v0.1.0](https://github.com/rtyler/offtopic/releases/tag/v0.1.0) release of
  Offtopic!. Threw an installation of it on my workstation to display a big
  stream of events in the offics
* (10:29 PDT) Verified that Offtopic! and the multipass feature works for
  monitoring a number of topics in a Real Usecase&trade; at [Lookout](http://lookout.com).
* (09:12 PDT) Coffee made, mail read, picking up where I left off last night
  with some more interesting functionality in Offtopic.
* (08:30 PDT) Traveling back to the office with more ideas kicking around in my
  head on how to make [Offtopic](https://github.com/rtyler/offtopic) more
  gooder.. Turns out testing something that depends on Zookeeper and Kafka
  being available isn't that great on the bus
* **Day Two**
* (23:31 PDT) Not much more cogent thought going into my hacking tonight,
  heading home
* (23:23 PDT) Hacked some pretty start/stop buttons into the web UI for
  Offtopic to connect/disconnect the websocket.
* (23:01 PDT) Manage to implement grepping/filtering messages coming through to
  Offtopic
* (22:19 PDT) Implemented wildcards, hurrah!
* (21:46 PDT) Starting to figure out topic wildcards to Offtopic!
* (21:08 PDT) Finished watching The Fifth Element with some coworkers, managed
  to [combining Kafka topic
  streams](https://github.com/rtyler/offtopic/issues/7) implemented!
* (17:53 PDT) Finished up a few more
  [Offtopic!](https://github.com/rtyler/offtopic) tasks. Feeling confident in
  my ability to figure out problems with Groovy now
* (17:35 PDT) Recovering from a distraction of real work over another beer.
  Managed to stave off responsibility for another day or two.
* (16:34 PDT) Beer finished, still chugging away on "Offtopic!", refactoring a
  lot of the messy code that I wrote in anger yesterday
* (15:51 PDT) Planned a bit of work on
  [Offtopic](https://github.com/rtyler/offtopic) after discussing some useful
  features with coworkers who also want more visibility into Kafka streams
* (15:36 PDT) Moved downstairs to the kitchen area at Lookout, poured myself a
  beer to celebrate conquering some Gradle work.
* (15:01 PDT) Managed to get a
  [v0.1.3](https://bintray.com/jruby-gradle/plugins/jruby-gradle-war-plugin/0.1.3/view)
   release of the
   [jruby-gradle-war-plugin](https://github.com/jruby-gradle/jruby-gradle-war-plugin)
   with all my good fixes. Demo app published as
   [hellowarld](https://github.com/rtyler/hellowarld)
* (14:46 PDT) Finally figured out my issue, it turns out that using Vim to
  inspect the `.war` files was a stupid idea because Vim caches the buffers for
  files within the Zip file, deceiving me into thinking my changes weren't
  actually working! **smashes keyboard**
* (13:45 PDT) Had to abandon my previous approach of getting a bundled
  `web.xml` inserted into the war file. Somehow I'm now generating a `.war`
   file with a `web.xml` file that doesn't match anything in my current source
   tree. GHOST XMLS
* (12:23 PDT) Thanks to [this stackoverflow
  post](http://stackoverflow.com/questions/4317035/how-to-convert-inputstream-to-virtual-file#16028522)
  I've at least got a path forward to fixing the aforementioned issue of
  bundling resources inside my Gradle plugin. Somehow I broke my zips somewhere
  around here: `> java.util.zip.ZipException: too many length or distance
  symbols`
* (11:43 PDT) Slowing down on progress, trying to resolve [this
  issue](https://github.com/jruby-gradle/jruby-gradle-war-plugin/issues/1),
  which requires Gradle plugin hacking that I've not done before
* (11:16 PDT) Managed to get a Gradle-built version of
  [hellowarld](https://github.com/rtyler/hellowarld) loaded and executing
  properly inside of Jetty 8
* (10:54 PDT)
  [jruby-gradle-war-plugin](https://github.com/jruby-gradle/jruby-gradle-war-plugin)
  properly building executable `.war` files with embedded gems.
* (10:26 PDT) Unblocked coworker with some Gradle hacking, back to my own
  hackz0ring!
* (09:59 PDT) Context-switch to help another developer use
  [jruby-gradle](https://github.com/jruby-gradle) for their hackathon project.
* (09:25 PDT) Break-time over, back to baking `.war` files with
  [Gradle](http://gradle.org)
* (09:15 PDT) Found some breakfast burritos downstairs, burrito break!
* (08:30 PDT) Writing the live blog post. Coffee made,
  [jruby-gradle-war-plugin](https://github.com/jruby-gradle/jruby-gradle-war-plugin)
  selected as the first project to tinker with.
