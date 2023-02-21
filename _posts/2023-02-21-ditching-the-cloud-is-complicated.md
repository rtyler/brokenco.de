---
layout: post
title: "Ditching the cloud is most likely a bad idea"
tags:
- aws
- opinion
---

I have the dubious honor of having recently led a migration from an on-premise
managed colocation facility into AWS. It was necessary to help the business
succeed, but frankly I would rather not have needed to do it. When I saw [a
post](https://world.hey.com/dhh/we-stand-to-save-7m-over-five-years-from-our-cloud-exit-53996caa)
by that attention-seeking guy who keeps trying to keynote RailsConf about
"leaving the cloud" this morning, I was hopped up on caffeine and free office
snacks, and couldn't help but share my thoughts in the fediverse.

Long story short, I think the original author's analysis is nonsense and will
most likely result in him Musking his own company. Either way, for posterity
here are some of my thoughts:

----

I have always disliked this dude's simpleton analyses but _IF_ you are
considering leaving AWS (or other cloud providers) you *must* include:

* Operational cost: which is all that the original author's analysis includes.
* Labor cost: migrations use people's time, which is typically the biggest
  portion of a company's budget.
* Opportunity cost: managing infrastructure or migrating it means you're not
  investing in growing the business. If your business isn't about running
  infrastructure (e.g. CloudFlare, Fastly, etc), this typically means you're
  actively harming your business by focusing elsewhere.


But there's so much more!


_IF_ the business' workloads are CPU intensive and consistent, buying metal
_might_ be cheaper.

Otherwise, if your math shows that on-premise is cheaper than I would have
*questions* about the current infrastructure, are you using:

* ECS/Fargate is crazy cheap and works great for almost all web apps you can
  shove into a container.
* AWS Aurora is crazy good and makes a *lot* of RDMS work and scaling easy.
* AWS Savings Plans help further reduce costs for predictable compute.

_IF_ the business already has a big investment into AWS S3, I hope you're
planning to get punished with S3 egress costs.

S3 is a modern marvel as [Corey Quinn](https://awscommunity.social/@Quinnypig)
has said. You literally cannot make faster, cheaper, or more resilient storage
But AWS uses cost to _encourage_ you not to walk away from S3.

Depending on the relation of the application to the S3 storage, transit fees
can eat you alive.

_IF_ the business' SLAs allow for the risk of a single-site on-premise
deployment, that's coo.

AWS can have downtimes but it can be enlightening to ask the ops old guard
about the time suck of configuration management, rack management, or dealing
with RMAs with shitty hardware vendors.

I don't relish funding Jeff Bezos' next super yacht any more than you do, but
the stack you can get on AWS is unrivaled in its cost, reliability, and ease
of use.

Nobody gives AWS enough credit for their security work.

Building secure infrastructure is really challenging. There's patch management,
role-based access control systems, data encryption needs, certificates, all
sorts of things.

Not all clouds do it well (lol azure).

But walking away from VPCs, Security Groups (Network Isolation), IAM
(Role-based access controls), CloudTrail (audit logging), GuardDuty (intrusion
detection), and automated upgrades for managed services would have me very
seriously questioning what security posture the org may or may not have.

Anyways, I don't love AWS. It's a monoculture and it makes an ugly
anti-competitive business viable.

It's still the right choice in my opinion the vast majority of businesses.

