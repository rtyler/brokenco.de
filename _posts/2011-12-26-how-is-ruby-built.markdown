---
layout: post
title: How is Ruby built?
tags:
- ruby
- wtf
- opinion
---

**Note:** This is a rant, I'm not actually going to explain anything of use

----

For a rather long time, I've used [clang](http://clang.llvm.org/) on my Linux
machine as the default value of the `$CC` environment variable. I've simply
found it to be a faster and more friendly compiler to work with than the
default `gcc`.


When I first came to Ruby, I tried building Ruby 1.8.7 with clang and it failed
*utterly*. After bitching on Twitter, as I'm prone to doing, [Joe
Damato](http://timetobleed.com) pointed out that Ruby 1.8 isn't really valid
C. Instead it is a hodge podge of macros, C code, assembly and tears.

I later found out that Ruby 1.9 seems to cope with being built with `clang`
properly, so I built a couple of [1.9 variants with
RVM](https://rvm.beginrescueend.com/) for my personal projects.


Everything was all fine and good until [I tried building a native extension for
a 1.9 Ruby:](https://gist.github.com/1521970A)

    make
    compiling em.cpp
    cc1plus: warning: command line option ‘-Wdeclaration-after-statement’ is valid for C/ObjC but not for C++ [enabled by default]
    cc1plus: error: unrecognized command line option ‘-Wshorten-64-to-32’
    cc1plus: warning: command line option ‘-Wimplicit-function-declaration’ is valid for C/ObjC but not for C++ [enabled by default]
    make: *** [em.o] Error 1

I lost **hours** trying to figure out what the hell was going on here. I was
convinced for hours that EventMachine (the gem being built here) had a bug in
it. Then I was convinced that RVM had a bug in it, but I finally landed on
Ruby's build system itself.


I should point out that the warning `shorten-64-to-32` only exists in patched
versions of compilers shipped with Mac OS X. It *certainly* doesn't exist on
any compiler on Linux, so where the hell did this flag come from?

Somehow, and arriving at this "somehow" took me a number of miserable hours,
the difference between using `clang(1)` and `gcc(1)` to build Ruby resulted in
a single nonsense `CXXFLAGS` value which didn't come back to bite me until I
tried to build a native extension.


How the shit does Ruby get built!?
