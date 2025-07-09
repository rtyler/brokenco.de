---
layout: post
title: "Save the world, write more efficient code"
tags:
- software
- rust
- opinion
- solar
---

Large Language Models have made the relationship between software efficiency
and environmentalism ***click*** for many people in the technology
field.  **The cost of computing _matters_.**

Software efficiency has been one of the most prominent themes of my
professional career, but never in order to "be green" but almost always to
squeeze more performance out of less "stuff", in essence, boosting the margins
for my employer's business. This is nowhere more prevalent than in "cloud computing" where efficiency and cost are inextricably linked, as I wrote in [Build more climate friendly applications with Rust](https://www.buoyantdata.com/blog/2025-04-22-rust-is-good-for-the-climate.html):


> Time is money. In the cloud time is measured and billed by the vCPU/hour and
> the most efficient software is always the cheapest. 
> [..]
> For most businesses doing more with less cost is an inherently valuable
> objective. That makes application design optimization with or without Rust a
> worthwhile pursuit. The cost improvements in this case were so substantial I
> could not help but wonder about the change in CO2 impact and how big of a
> role Rust played. 


I stumbled across [this presentation](https://www.youtube.com/watch?v=XntLynSlYjI&t=286s) by the always-worth-listening-to 
[Bert Hubert](https://eupolicy.social/@bert_hubert) and it struck me so
strongly that I had to share! One point he made about PowerDNS I am still
sitting with: in the on-premise world for PowerDNS if their software exceeded
the capacity of their hardware, they would optimize the software rather than go
rack more hardware. The idea is so obvious but also novel when applied to
cloud-computing. If we were to set a vCPU budget for an application, once we
start to exhaust our vCPU capacity, rather than scale up more containers
perhaps we should upgrade system dependencies, inspect application traces, or
find other ways of minimizing utilization.

In my [day job](https://tech.scribd.com) we operate a number of web properties
receiving billions of requests per month. Our content library contains hundreds
of millions of documents. To Bert's point, at a large enough scale those
percentage points really start to add up! 

An application using ECS Fargate that requires 100 tasks each with 8 vCPU and
16GB RAM costs **$28.8k/month** to keep online. Bert suggests that there are
likely many _easy_ efficiency wins if we go looking for them, and believes that
a factor of 10 improvement should be feasible. For large-scale Ruby, Python, or
JavaScript applications I'm a little skeptical of that claim _but_ even a 50%
reduction in containers needed would drop the cost to $14.4k/month. Every 5% of
improved efficiency is worth approximately $1400 per month, or $17.5k/year.

The economic impact alone should be compelling for most organizations to at
least take a pass over some application traces, but as Bert says, it might not
hurt to wrap this in the green climate friendly flag as a way to get more
organizational buy-in on software efficiency.


I strongly recommend watching his
[presentation](https://www.youtube.com/watch?v=XntLynSlYjI&t=286s) and
_strongly agree_ with two of Bert's key points:

* Our software efficiency matters on a global scale.
* There are quicks wins if we're willing to look for them.


Make sure to follow Bert on [Mastodon](https://eupolicy.social/@bert_hubert)
for other thought-provoking musings on digital sovereignty and European tech.

