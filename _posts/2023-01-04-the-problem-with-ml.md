---
layout: post
title: "The problem with ML"
tags:
- software
- ml
- aws
- databricks
---


The holidays are the time of year when I typically field a lot of questions
from relatives about technology or the tech industry, and this year my favorite
questions were around **AI**. (*insert your own scary music*) Machine-learning
(ML) or Artificial Intelligence (AI) are being widely deployed and I have some
**Problems&trade;** with that. Machine learning is not necessarily a new
domain, the practices commonly accepted as "ML" have been used for quite a
while to support search and recommendations use-cases. In fact, my day job
includes supporting data scientists and those who are actively creating models
and deploying them to production. _However_, many of my relatives outside of the tech industry believe that "AI" is going to replace people, their jobs, and/or run the future. I genuinely hope AI/ML comes nowhere close to this future imagined by members of my family.


Like many pieces of technology, it is not inherently good or bad, but the
problem with ML as it is applied today is that **its application is far
outpacing our understanding of its consequences**.

Brian Kernighan, co-creator of the C programming language and UNIX, said:

> Everyone knows that debugging is twice as hard as writing a program in the
> first place. So if you're as clever as you can be when you write it, how will
> you ever debug it?

Setting aside the _mountain_ of ethical concerns around the application of ML
which have and should continue to be discussed in the technology industry,
there's a fundamental challenge with ML-based systems: I don't think their
creators understand how they work, how their conclusions are determined, or how
to consistently improve them over time. Imagine you are a data scientist or ML
developer, how confident are you in what your models will predict between
experiments or evolutions of the model? Would you be willing to testify in a
court of law about the veracity of your model's output?

Imagine you are a developer working on the models that Tesla's "full
self-driving" (FSD) mode relies upon. Your model has been implicated in a Tesla
killing the driver and/or pedestrians (which [has
happened](https://www.reuters.com/business/autos-transportation/us-probing-fatal-tesla-crash-that-killed-pedestrian-2021-09-03/)).
Do you think it would be possible to convince a judge and jury that your model
is _not_ programmed to mow down pedestrians outside of a crosswalk? How do you
prove what a model is or is not supposed to do given never before seen inputs?

Traditional software _does_ have a variation of this problem but source code
lends itself to scrutiny far better than the ML models. Many of which have come
from successive evolutions of public training data, proprietary model changes,
and integrations with new data sources.

These problems may be solvable in the ML ecosystem, but problem is that the
application of ML is outpacing our ability to understand, monitor, and diagnose
models when they do harm.

That model your startup is working on to help accelerate home loan approvals
based on historical mortgages, how do you assert that your models are not
re-introducing racist policies like
    [redlining](https://en.wikipedia.org/wiki/Redlining). (forms of this [have happened](https://fortune.com/2020/02/11/a-i-fairness-eye-on-a-i/)).

How about that fun image generation (AI art!) project you have been tinkering
with uses a publicly available model that was trained on millions of images
from the internet, and as a result in some cases unintentionally outputs
explicit images, or even what some jurisdictions might consider bordering on
child pornography. (forms of this [have
happened](https://www.wired.com/story/lensa-artificial-intelligence-csem/)).

Really anything you teach based on the data "from the internet" is asking for
racist, pornographic, or otherwise offensive results, as the [Microsoft
Tay](https://www.cbsnews.com/news/microsoft-shuts-down-ai-chatbot-after-it-turned-into-racist-nazi/)
example should have taught us.


Can you imagine the human-rights nightmare that could ensue from shoddy ML
models being brought into a healthcare setting? Law-enforcement? Or even
military settings?

---

Machine-learning encompasses a very powerful set of tools and patterns, but our
ability to predict how those models will be used, what they will output, or how
to prevent negative outcomes are _dangerously_ insufficient for the use outside
of search and recommendation systems.

I understand how models are developed, how they are utilized, and what I
_think_ they're supposed to do.

Fundamentally the challenge with AI/ML is that we understand how to "make it
work", but we don't understand _why_ it works.

Nonetheless we keep deploying "AI" anywhere there's funding, consequences be
damned.

And that's a problem.

