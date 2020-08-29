---
layout: post
title: "Comparing apples to orange rustaceans"
tags:
- rust
- opinion
---

Never trust a developer who praises the purity or elegance of the C programming
language.  I find comparisons often made between Rust and C for "systems
programming" to be one of my least favorite, and most disingenuous discussion
topics among developers on the internet. It's like comparing roller skates to
an electric car. While they both can transport you from one place to another,
only one of them is likely going to bring you safely to your destination.

Tweets like [this
one](https://twitter.com/JamesWidman/status/1122921637798662144) or blog posts
like [this
one](https://thephd.github.io/your-c-compiler-and-standard-library-will-not-help-you)
really help drive the point home that C is **not** what most people think it
is.  One of the common themes is "complexity." It is absurd to talk about
C's simplicity compared to Rust's complexity because C:

* Doesn't have a standard library
* Doesn't have any built in concurrency or parallelism primitives
* Doesn't have any concept of modularization.
* Doesn't offer type safety.

C isn't actually one thing to begin with either. Depending on which revision of
the specification and which compiler you use, a C program may not be
compilable. Each compiler has a slightly different perspective on what the
gaps, "undefined behavior" in what C is actually defined as, should mean in the
real world.

Most of the [worst security
bugs](https://www.bleepingcomputer.com/news/security/mitre-shares-this-years-top-25-most-dangerous-software-bugs/)
are trivial to write in C. In order to "safely" write C, a significant amount
of static analysis, developer chutzpah, and code review needs to be added into
the development process.

C was invented 48 years ago.

As an industry we have learned and evolved so much in the way we think about
safety, concurrency, and software development as a discipline in the last five
decades. To me, adopting C for a new project is throwing all that away for
misguided notions of purity and performance.

I considered offering platitudes about what C is good at, or
where C belongs. Instead I'm going to take a hardline approach:

**C is dangerous, inefficient, and has no place in modern development.**

Don't take this as "you should use Rust" (you should) but rather: you should
_not_ use C for anything new.
