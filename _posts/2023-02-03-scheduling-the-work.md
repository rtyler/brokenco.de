---
layout: post
title: "Scheduling work with market dynamics"
tags:
- otto
- software
---

I had a lucky break in the day and was able to read [this blog
post](https://fly.io/blog/carving-the-scheduler-out-of-our-orchestrator/) which popped up in my social feed. In essence it talks about what Fly.io did to rebuild
their scheduler to better match what they're trying to accomplish.
Orchestration and scheduling are topics I like to geek out on, going back many
years as part of the [Jenkins project](https://jenkins.io). But this quote in
particular caught my eye:

> `flyd` has a radically different model from Kubernetes and Nomad. Mainstream
> orchestrators are like sophisticated memory allocators, operating from a
> reliable global picture of all capacity everywhere in the cluster. Not `flyd`.
>
> Instead, `flyd` operates like a market. Requests to schedule jobs are bids for
> resources; workers are suppliers. Our orchestrator sits in the middle like an
> exchange. ratemysandwich.com asks for a Fly Machine with 4 dedicated CPU cores
> in Chennai (sandwich: bun kebab?). Some worker in MAA offers room; a match is
> made, the order is filled.


I _love_ this idea for a lot of reasons, not the least of which is that it's a
real-world incantation of an unoriginal idea that I had for
[Otto](https://github.com/rtyler/otto), an overly ambitious CI/CD side-project.

In my work I referred to it as [resource allocation by
auction](https://github.com/rtyler/otto/blob/main/rfc/0003-resource-auctioning.adoc)
and had only just begun to experiment with the concept. I once read a computer
science paper which described this concept more in detail, but I cannot seem to
find it again.

Suffice it to say, there's a lot of good efficiency to be gained by resource
auctioning in this manner, especially in a multi-tenant system. The Fly.io blog
post is an interesting read either way, but efficient resource scheduling in
this way I hope makes it into a _lot_ of other systems.
