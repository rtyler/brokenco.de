---
layout: post
title: X is business value
tags:
- devops
- buzzwords
- continuousdeployment
---

***Disclaimer:*** *I hate the term "business value", it's completely subjective
and generic; it is one of my least favorite synergies.*

A few weeks ago [Christian Trabold](https://twitter.com/ctrabold) posted to
Twitter saying "Speed is business value", a simple statement that is often
forgotten by both developers and non-developers alike in the process of
building and deploying software. That is to say, the ability to deliver
software in a timely fashion is a very important, sometimes the most important,
facet of building a product.

The statement has stuck with me, constantly coming up in the back of my mind
whenever [we](http://www.mylookout.com) spend a little bit of time improving
our internal development and deployment processes.

I believe that you can tease out the statement to include:

 * **Speed is business value**
 * **Quality is business value**
 * **Cost is business value**

Look at all that business value man! Unless you're a telecom company, or a
manufacturer of sugared water, your company **is** competing in the
marketplace. In this competition your product is typically judged loosely
on these three axis.

**How soon can I have the new one? How crappy is it? How much will it cost
me?**

----

The _practice_ of continuous deployment can help improve each of these axis. I
emphasis "practice" because I think continuous deployment is an on-going
exercise of reaction, reflection and improvement.

<center><a
href="http://www.20x200.com/art/2009/03/untitled-lets-make-better-mistakes-tomorrow.html"
target="_blank"><img
src="http://agentdero.cachefly.net/unethicalblogger.com/images/better-mistakes-tomorrow.jpg"
border="0"/></a></center>

Being part of the startup world, where you live by the phrase "fail fast",
mistakes are going to happen. You might even argue that you want to make some
mistakes, it's a great learning experience and helps make the product better.

All to often, this mantra is applied to the product, but not engineering. In
the past I've worked in organizations with little-to-zero automated
testing, and absolutely zero time for post-mortems and improvement. Looking
back, that situation is so dysfunctional I have trouble believing I was
actually part of it.

Coming back to Christian's quote, I'm even more bewildered by our actions at
the time.  Manual QA is expensive and time consuming, regressions become more
and more costly the further down the deployment pipeline you get, the most
costly being "in production" where you're affecting actual users.

At face value, deploying rapidly ("shooting from the hip") with little or zero
automated tests, seems like you're moving faster than everybody else until
you're not. Until you:

* Take down the site
* Screw up your payment flow
* Introduce subtle regressions that affect one side of an A/B test
* Spend many man hours manually verifying production


If you would imagine the pipeline of a feature going from: Product -> Developer -> QA -> Live.

The further down the pipeline you find failures, the more time-consuming and
expensive those failures are.

----

My answer to the problem is predictable, automated testing. Unit tests,
integration tests, browser tests. [Test ALL the
things](http://knowyourmeme.com/memes/x-all-the-y)!

Tests by themselves aren't enough, unfortunately. As an organization you
absolutely **must** do some form of post-mortems after screwing things up. If
for example, a bad deployment contains JavaScript that causes browsers
to fall into infinite loops. The easy fix after such an event is to say "don't
write bad JavaScript", but that's not very realistic is it? What if a bad
deployment contains poorly optimized database queries? What about a simple
logic error where the developer simply assumed `x.foo()` would return `Y` but
instead it returns `Z`? What else can you do outside of testing, in your
development practices and deployment processes to ensure quality?

The only way you can move faster, cheaper and with more stability is if you make
this practice of analysis and improvement commonplace.

Stop being stupid and do things better.
