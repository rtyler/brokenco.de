---
layout: post
title: "JRuby demos from the JavaOne Script Bowl 2014"
tags:
- ruby
- jruby
- javaone
---

This past October I was invited to represent [JRuby](http://jruby.org) in the
JavaOne 2014 "Script Bowl." A panel where community members from various
projects which implement scripting languages on top of the JVM pitch their
language to a live studio audience. This year's panel consisted of a members
from the Groovy, Clojure and Scala communities, and me representing JRuby of
course.

The session consists of two segments, historically with one focusing on
the capabilities of the language itself and the second segment focusing on the
community built around the scripting language.

Instead of choosing to create a presentation, I took the road less traveled and
created a series of live coding demos to demonstrate the utility of JRuby.

The collection of demos that I created can be found in this [demo
repository](https://github.com/rtyler/javaone-jruby-demo). For all of my demos
I used [Pry](http://pryrepl.org) as a live JRuby interpreter to load and
execute Java and Ruby code on the fly, which I hope made for a compelling
presentation.

The following are the demos worth mentioning here:

### ascii table from jar

In [this
demo](https://github.com/rtyler/javaone-jruby-demo/blob/master/ascii-table-from-jar.rb)
I had grabbed some random Java code from the internet to print ascii-only
formatted tables, and wrote some Ruby glue to make use of it. Copying and
pasting this code into a running Pry session and you'll get a nice table drawn
in your console.

~~~
[16] pry(main)> puts make_table(headers, mails)
+-----------------------------+--------------------------+
|           Subject           |           From           |
+-----------------------------+--------------------------+
|         NOT SPAM WE PROMISE | sirspamsalot@hotmail.com |
| Important work related info |     yourboss@example.com |
|       Don't forget the milk |         spouse@family.io |
+-----------------------------+--------------------------+
=> nil
[17] pry(main)>
~~~

### anonymous classes

[This
demo](https://github.com/rtyler/javaone-jruby-demo/blob/master/anonymous-classes.rb)
demonstrates how JRuby merges the use of [anonymous
classes](http://docs.oracle.com/javase/tutorial/java/javaOO/anonymousclasses.html)
in Java with Ruby's concept of blocks. Instead of creating an anonymous class
that implements the `Runnable` interface, we can just use pass a block of code
to be executed inside of a `java.lang.Thread`.


### "turtles"

This might be [my favorite
demo](https://github.com/rtyler/javaone-jruby-demo/tree/master/turtles) because
it demonstrates one of the more compelling (to me) features of JRuby, it's
embeddability. In the "turtles" demo, I've got an entirely embedded and
separate Ruby runtime environment, nested within an already existing Ruby
runtime.

The result is that I can create isolated Ruby environments within the same JVM,
which opens the door to all kinds of interesting sandboxing applications.

~~~
[44] pry(main)> require './turtles/first'
=> true
[45] pry(main)> puts "Our original JRuby has version: #{JavaOne::VERSION}".colorize(:magenta)
Our original JRuby has version: 1
=> nil
[46] pry(main)> puts

=> nil
[47] pry(main)> # Now let's load a the same module with a different version inside the runtime environment
[48] pry(main)> evaler.eval(runtime, "require './turtles/second'"); nil
=> nil
[49] pry(main)> evaler.eval(runtime, "puts \"Our embedded JRuby has version: \#{JavaOne::VERSION}\".colorize(:green)"); nil
Our embedded JRuby has version: 2
=> nil
[50] pry(main)>
~~~


### jruby-gradle

The final [demo that I
gave](https://github.com/rtyler/javaone-jruby-demo/tree/master/jruby-gradle-example)
is a little self-promiting, in that I demonstrated the capabilities of the
[jruby-gradle](https://github.com/jruby-gradle) project. A project which allows
you to use the [Gradle](http://gradle.org) tool for managing projects,
obviating the need for Bundler, JBundler, Warbler and RVM.

During the demo I showed the
[build.gradle](https://github.com/rtyler/javaone-jruby-demo/blob/master/jruby-gradle-example/build.gradle)
file which references a Ruby gem and demonstrated how to build a
self-contained, self-executing `.jar` file with the tool:

~~~
% ./gradlew shadowJar
~~~

Then executed it:

~~~
% java -jar build/libs/jruby-gradle-example-all.jar
REQUIRED RELATIVE
Hello from JRuby built with Gradle!
%
~~~

That is a jar file, running Java and Ruby code all from within the file, pretty
spiffy if you ask me!


----

Predictably, JRuby didn't win the Script Bowl, unpredictably Clojure did. The
event was enjoyable, but for me my favorite part was creating the demos and
honing my pitch for JRuby, which I'm sure I'll have the opportunity to reuse in
the future.


