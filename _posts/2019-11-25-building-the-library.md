---
layout: post
title: Changing the way the world reads at Scribd
tags:
- scribd
- aws
---

This week we launched the
[Scribd tech blog](https://tech.scribd.com), on which I published today's
article: [We're building the largest library in
history](https://tech.scribd.com/blog/2019/building-the-library.html). I
frequently have to remind myself that I have been here less than a year, and we
have undergone incredible positive change, with more coming in 2020.

The [post](https://tech.scribd.com/blog/2019/building-the-library.html)
portends a high-level idea of what is to come for technology at Scribd in the
coming year or two, related to our [announcement
today](https://blog.scribd.com/home/scribd-announces-58-million-strategic-investment-led-by-spectrum-equity)
of a major round of funding:

> Today we are excited to announce Scribd has closed $58 million in equity
> financing led by Spectrum Equity. The investment will be used to support
> growth and product innovation, enhance operations, and further the company's
> mission to change the way the world reads. 

The most important detail I was able to share in the blog post is in the
Infrastructure section:

> The future of our infrastructure, and our applications, is **entirely in the
> cloud**. The migration [to AWS] requires shifting workloads between
> datacenters with a tiny error and downtime budget. At our size, that’s many
> terabytes of data and thousands of requests per second, which dictates
> serious upfront planning, automation, testing, and monitoring of every facet
> of our environment.


Hiding behind this paragraph has been a tremendous amount of my time from these
past few months. Arriving at Scribd in January, there were no plans in the
roadmap to adopt a cloud provider for our infrastructure. I must have
been the straw that broke the camel's back. "We need to move into the cloud"
was met with "We agree! What's your plan?" And then it became one of the many
plates I have kept spinning.

We already have migrated a few services, including a major production service
which Core Platform moved over without any issues; I'm very proud of that one!

Unlike many "datacenter to cloud" migrations, I believe ours is unique in that
we have:

* A very limited error and downtime budget.
* The green-light to share the process as we go along.


I'm looking forward to sharing more on
[tech.scribd.com](https://tech.scribd.com)
([RSS](https://tech.scribd.com/feed.xml)) as we move to AWS, I hope you'll tune
in!
