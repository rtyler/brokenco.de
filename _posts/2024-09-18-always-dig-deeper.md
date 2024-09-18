---
layout: post
title: "Always dig deeper into the error"
tags:
- opinion
- software
---

The staggering complexity of modern software makes it impossible for us to
truly understand what is happening while our code runs, but when it fails there
is **always** something we can learn. At the beginning of my career we, the
industry, generally understood that programs were getting complex. Without
hesitation we made things _more_ complex, _more_ distributed, and somehow
_more_ coupled. Failure is a "learning opportunity", and those opportunities
are in abundance.

Applications that I work with can fail for any number of reasons, each
interesting in its own way:

* It received invalid or unexpected data from another application.
* It received too much data, and therefore exceeded runtime limits causing it to fail.
* Somethign in the maze of dependencies the application has was updated and had a slight, unexpected, change in behavior.
* Somebody (hi!) goofed and did not anticipate some operating condition.

The list could go on and on until we're all sad.

I have been working with AWS Lambda more heavily, not because I have
finally _seen the light on Serverless_, but because it turns out that its
constrained runtime environment and narrow functional scope has been
ideal for a number of recent projects.

Lambda functions can suffer from every one of the errors above, but the
_runtime limitations_ are where I have learned the most from errors in
real-world applications. For the most part, if we have an application which
needs more CPU, memory, or storage, we just...allocate more CPU, memory, or
storage. In the case of Lambda functions, there is a heavy incentive **not** to
carelessly vertically scale.

Over the last couple days one such function, which processed a sizable bit of
data, started exceeding its timeout.  The function has a fairly limited vCPU
and memory allotment, and will be terminated after 120s of runtime.

It's _easy_ to turn 120s into 180s.

It's easy to crank up the vCPU.

But it is almost _always_ worth digging a little deeper and understanding _why_
something has changeed.

Typically I am looking into (in this order):

1. **Application logs**: the number of problems that are _actually recorded in
   the logs_ is sometimes embarrassing. It can be difficult to find signal amid
   the noise of most application logs, but in most cases the problem was
   clearly being reported in the application logs. For AWS Lambda the logs will
   also contain when the function finished executing and how much of its
   allotted memory was consumed during runtime, which makes it easier to
   identify cases where a function failed simply because it ran out of memory.
2. **Runtime metrics**: for most things in AWS, there are soem basic CloudWatch
   Metrics which can be useful to gain an understanding about aggregate
   performance and patterns. With AWS Lambda this can help demonstrate trends
   of failures and timeouts
3. **"Telemetry"**: there's lots of other information that can be gleaned about
   application failures that is kind of purpose specific. In data processing
   applications this could be data volume, throughput, etc.


The value in digging deeper comes from reviewing these sources of information
and building a clearer picture of how the application is working in concert
with the inputs/outputs around it. The failures I have recently been
investigating revealed problems **not** in the application I was investigating,
but a series of failures in the sequence of events _preceding_ the
applications' execution.

In one case I found a 2 year old bug which existed because important code was
simply removed(!). Another situation led me to identify an anomaly where a
months old release of a totally different application caused a 3x increase in data
volume. That massive increase in volume had gone unnoticed, until a couple days
ago when it started to time out a Lambda I maintain.


It is not possible to deeply investigate every single error that pops up, but I
think it is important for developers to allocate some time every day or week to
learn more about the systems for which they are responsible. Errors provide a
productive way to develop that knowledge.

**Every** error represents an unexpected condition, and therefore a chance to
learn more about how an application is (mis)behaving in real-world conditions.


