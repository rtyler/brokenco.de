--- 
layout: post
title: Ada? Surely you jest Mr. Pythonman
tags: 
- opinion
- software development
- ada
nodeid: 304
created: 1291647600
---
<a href="http://www.amazon.com/gp/product/0070116075?ie=UTF8&tag=unethicalblog-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0070116075"><img hspace="10" align="right" border="0" src="http://ecx.images-amazon.com/images/I/41HUUCwx7%2BL._SL160_.jpg"></a><img src="http://www.assoc-amazon.com/e/ir?t=unethicalblog-20&l=as2&o=1&a=0070116075" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
The past couple weeks I've been spending my [BART](http://bart.gov) commutes
learning the [Ada programming
language](https://secure.wikimedia.org/wikipedia/en/wiki/Ada_(programming_language)).
Prior to starting to research Ada, I sat in my office frustrated with Python
for my free time hackery. Don't get me wrong,  I **love** the Python language,
I have enjoyed the ease of use, dynamic model, rapid prototyping and expressiveness of the
Python language, I just fall into slumps occasionally where some of Python's
"quirks" utterly infuriating. Quirks such as its loosey-goosey type system
(which I admittedly take advantage of often), lack of **good** concurrency in
the language, import subsystem which has driven lesser men mad and its
difficulty in scaling organically for larger projects (I've not yet seen a large
Python codebase that hasn't been borderline "clusterfuck".)


Before you whip out the COBOL and Fortran jokes, I'd like to let it known up
front that Ada is a *modern* language (as I [mentioned on reddit](http://www.reddit.com/r/programming/comments/eh462/ada_surely_you_jest_mr_pythonman/c181zqy), the first Ada specification was in 1983, 11 years after C debuted, and almost 30 years after COBOL and Fortran were designed). It was most recently updated with the
"Ada 2005" revision and supports a lot of the concepts one expects from modern
programming languages. For me, Ada has two strong-points that I find
attractive: extra-strong typing and built-in concurrency.

### Incredibly strong typing

The typing in Ada is unlike anything I've ever worked with before, coming from
a C-inspired languages background. Whereas one might use the plus sign operator
in Python to add an `int` and a `float` together without an issue, in Ada
there's literally **zero** auto-casting (as far as I've learned) between types.
To the inexperienced user (read: me) this might seem annoying at first, but
it's fundamental to Ada's underlying philosophy of "no assumptions." If you're
passing an `Integer` into a procedure that expects a `Float`, there will be no
casting, the statement will error at compile time.


### Concurrency built-in

Unlike C, Java, Objective-C and Python (languages I've used before), Ada has
concurrency defined as part of the language, as opposed to an abstraction on
<a href="http://www.amazon.com/gp/product/0521866979?ie=UTF8&tag=unethicalblog-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0521866979"><img border="0" hspace="10" align="right" src="http://ecx.images-amazon.com/images/I/41FMkfK74-L._SL160_.jpg"></a><img src="http://www.assoc-amazon.com/e/ir?t=unethicalblog-20&l=as2&o=1&a=0521866979" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
top of an OS level library (pthreads). In Ada this concept is called
"[tasking](https://secure.wikimedia.org/wikibooks/en/wiki/Ada_Programming/Tasking)"
which allows for building easily concurrent applications. Unlike OS level
bindings built on top of pthreads (for example) Ada provides built in
mechanisms for communicating between "tasks" called "rendezvous" along with
scheduling primitives.


Being able to define a "task" as this concurrent execution unit that uses this
rendezvous feature to provide "entries" to communicate with it is something I
still haven't wrapped my head around to be honest. The idea of a language where
concurrency is a core component is so new to me I'm not sure how much I can do
with it.


For my first "big" project with Ada, I've been tinkering with a [memcached
client in Ada](https://github.com/rtyler/memcache-ada) which will give me the
opportunity to learn some Ada fundamentals before I step on to bigger projects.
Disregarding the condescending jeers from other programmers who one could
classify as "leet Django haxxorz", I've been enjoying the experience of
learning a new ***vastly*** different language than one that I've tried before.

So stop picking on me you big meanies :(
<!--break-->
