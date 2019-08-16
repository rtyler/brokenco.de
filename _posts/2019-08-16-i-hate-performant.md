---
layout: post
title: "I hate the made up word 'performant'"
tags:
- opinion
---

The tech industry is filled with all sorts of silly jargon and acronyms. Our
overuse of jargon not only makes us very easy to identify in a crowded
restaurant but also helps make things confusing for new-comers and veterans
alike. In my current role, I find myself spending a *lot* of time with vendors
who also seem to delight in barraging prospects with unpleasant jargon. My
least favorite word among it all is **performant**.

Our new version is more performant! A performant library for X. A new
architecture for performant web apps. Etc, etc.

It is absolutely useless and doesn't convey anything meaningful to the reader
or listener.

I **loathe** this word. 


The word itself is a corruption of the word "performance." Most people try to
use "performant" to convey peak or better performance, and that's where the
word fails to do any meaningful work.

Consider a web application framework like Rails. For most applications which
use Rails, there is a web server running the application, a caching layer, a
database, and potentially a front-end web server.

Now consider the phrase "a performant Ruby on Rails application"

I haven't the slightest clue what this could mean because _performance_ is an
incredibly complex and layered topic. Peak or optimal performance of a Rails
application could mean many different things:

* The application has been made smaller or structured in such a way that it
  loads from disk faster.
* Template rendering is heavily optimized, perhaps by native extensions
* Interpreter improvements or options have made execution much faster than
  previously
* Data or object structure changes reduced the amount of objects generated,
  reducing memory pressure and time spent in garbage collection.
* The use of threads or fibers has allowed the application to serve multiple
  concurrent requests more efficiently.
* Effective use of in-memory or network-based caches has made slower queries to
  data storage less frequent or unnecessary
* Database queries have been tuned or important columns have been indexed to
  match the common access patterns needed by the application.


"Performant" doesn't convey any of that nuance or detail. It evokes only an
intangible feeling of "oh this is better" but with no real explanation of how.

I would love for the word to join ranks of jargon like "synergy" and
"value-proposition" as a target of derision. There are so many great words in
the English language which we can use to concisely describe the complexity of our
technology. We don't need to invent newer ones that do a worse job of it.

