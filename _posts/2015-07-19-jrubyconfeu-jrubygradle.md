---
layout: post
title: "JRuby/Gradle at JRubyConf EU 2015"
tags:
- jrubygradle
- jruby
- jrubyconfeu
---


Mid-way through last year, [Lookout](http://hackers.lookout.com)'s investment
in [JRuby](http://jruby.org) started to really take off. Having struggled with
the harsh realities of [MRI](https://en.wikipedia.org/wiki/Ruby_MRI), we
finally had a platform that gave us a way to grow our technology without having
to throw out vast amounts of existing Ruby code. After an exciting weekend at
[JRubyConf EU 2014](http://2014.jrubyconf.eu) and
[Eurucamp](http://eurucamp.org) I started hacking on a brand new project, one
that I hoped would bring Ruby into harmony with the rest of the JVM ecosystem:
[JRuby/Gradle](http://jruby-gradle.org)

From [jruby-gradle.org](http://jruby-gradle.org):

> JRuby/Gradle is a collection of Gradle plugins which make it easy to build,
> test, manage and package Ruby applications. By combining the portability of
> JRuby with Gradle’s excellent task and dependency management, JRuby/Gradle
> provides high quality build tooling for Ruby and Java developers alike.


The past twelve months have seen some incredible developments in the
JRuby/Gradle toolchain. Much of which would not have been possible without
[Schalk W. Cronjé](https://github.com/ysb33r)'s massive contributions and help
getting the project off the ground. And more recently the help of [Christian
Meier](https://github.com/mkristian) whose contributions have been partially
funded by Lookout, Inc.

_Currently_, JRuby/Gradle is ready for prime-time. Lookout is using
it to unify dependency and task management across a number of different
projects, as well a few other notable
[use-cases](https://github.com/robfletcher/gradle-compass) here and there.


As such, I'm very excited to be [presenting
JRuby/Gradle](http://2015.jrubyconf.eu/speakers/agentdero.html) at this year's
[JRubyConf EU](http://2015.jrubyconf.eu) in Potsdam, Germany on **July 31st**. My
abstract is as follows:


> One of the most useful aspects of JRuby is the ease at which one can integrate
> tools from the Java ecosystem. For developers building hybrid applications
> though, using Ruby tools like Bundler and Rake can result in unpleasant hacks.
> If you stick to classic Java tools like Maven, it can feel like writing Ruby
> with a straight-jacket on. This lack of mature tooling to support Java/Ruby
> applications leaves developers in an uncanny valley between the two universes..
>
> With the recent rise of Gradle, which was designed to support a polyglot
> ecosystem through a rich plugin architecture, there is light at the end of the
> tunnel for JRuby developers!
>
> This talk will introduce the jruby-gradle project, an effort to combine the
> very best in Java tooling with the Ruby world, providing top-notch integration
> for JRuby devs. During the talk we will cover the motivations of the
> jruby-gradle project and describe how it helps bridge the gap between Java and
> Ruby. By combining the flexibility of JRuby with the power of Gradle, we can
> breathe new life into JRuby, opening it up to an even broader audience than
> before.


I'm *very* excited to give this talk at JRubyConf, less than a calendar year
since the project was inspired at the very same conference.

If you're in Europe and have the time/means to get to Potsdam, I cannot
recommend JRubyConf EU and [Eurucamp](http://eurucamp.org) highly enough, and I
hope to see you there!
