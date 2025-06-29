---
layout: post
title: Yes, please repeat yourself.
tags:
- software
- opinion
---

The oft touted principles of "pragmatic software development" are by and large
nonsense.  While not unique to software development many people like to choose
their dogma and then wield it uncritically when any opportunity arises. "Don't
Repeat Yourself" (DRY)is one of the "principles" that has always _irked_ me.

Designing sensible abstractions is one of the most difficult problems in software development. I have repeatedly found that zealous application of "DRY" or test-driven development (TDD) leads to one of two outcomes:

* _hundreds_ of small functions which require substantial mental context to work with.
* a few massive objects which capture far more scope than is sensible.

[Matthew Endler wrote a great
post](https://endler.dev/2025/repeat-yourself/) on the subject of DRY, which does a
much better job articulating the problems I have had observed.

> When you start to write code, you don’t know the right abstraction just yet.
> But if you copy code, the right abstraction reveals itself; it’s too tedious to
> copy the same code over and over again, at which point you start to look for
> ways to abstract it away. For me, this typically happens after the first copy
> of the same code, but I try to resist the urge until the 2nd or 3rd copy.

[..]

> Abstractions can make code harder to read, understand, and maintain because
> you have to jump between multiple levels of indirection to understand what
> the code does. The abstraction might live in different files, modules, or
> libraries.

Working with large monolith Ruby on Rails codebases, the weight of poor
abstractions makes the code intolerably difficult. Trying to mentally model the
code invocation paths through mixins,
[concerns](https://www.honeybadger.io/blog/rails-concern/), class hierarchies,
or other Rails conventions has led me in some cases to _give up_ on trying to
understand the code. Instead I will sometimes find myself throwing exceptions
just to figure out what call stack actually touches the code under scrutiny.

I personally find the guideline of "write code to be read" helps wade through
the pragmatic principles in a way that is practical. Avoiding unnecessary
repetition _can_ be useful but its utility ends as soon as readability suffers.



