---
layout: post
title: "Regarding Open Source and Sour Grapes"
tags:
- opinion
- opensource
- copyleft
---

A link was sent my way to the [Redis Labs "Commons
Clause"](https://redislabs.com/community/commons-clause/), which definitely
raised my eyebrow.  While the Commons Clause, as defined by Redis Labs, does
not apply to Redis itself, it is applied to their [non-closed source
software](https://redislabs.com/community/oss-projects/).

The relevant and interesting text of the "Commons Clause" is as follows:

> Without limiting other conditions in the License, the grant of rights under the License will not
> include, and the License does not grant to you, the right to Sell the Software.
>
> For purposes of the foregoing, “Sell” means practicing any or all of the rights granted to you
> under the License to provide to third parties, for a fee or other consideration (including without
> limitation fees for hosting or consulting/ support services related to the Software), a product or
> service whose value derives, entirely or substantially, from the functionality of the Software.

There have been a number of perspectives I have now read from [VM
Brasseur](https://anonymoushash.vmbrasseur.com/2018/08/21/redis-labs-and-the-questionable-business-decision/),
[Drew
DeVault](https://drewdevault.com/2018/08/22/Commons-clause-will-destroy-open-source.html),
and [Software Freedom
Conservancy](https://sfconservancy.org/blog/2018/aug/22/commons-clause/).
Additionally, [Redis Labs has
responded](https://redislabs.com/blog/redis-license-bsd-will-remain-bsd/) to
many of the concerns and criticisms.

As I was discussing this with my colleague
[Mo](https://twitter.com/moritzplassnig), his questions provided a useful foil
for why those who don't live and breathe the nuance between "open source",
"free software", and "source-available" should be interested in this discussion
around Redis Labs' "Commons Clause."

Before we go much further, here's a quick summary of (generalized) terms which
are important for this discussion:

* *open source*: "you can do whatever you want with this code, but it has to
  retain my copyright."
* *free software* "you can do lots with this code, but any changes you make
  have to also be made available to whomever you give or sell it to."
* *source available* "you can look at this source code, but for the most part
  don't expect to be able to give it or sell it to anybody."
* *proprietary* "if you somehow get a hold of this code, which we consider a
  trade secret, we'll probably sue your pants off."


From my perspective, there are two significant problems with the Commons Clause
which merit more analysis: first the disingenuous logic being used as a
justification, and more importantly the apparent attempt to monopolize all
value realized in the ecosystem around a piece of software.

### Disingenuous Logic

As a long time supporter and contributor to free and open source software, the
most fundamental problem with the Commons Clause, from my perspective, is how
**absolutely disingenuous** the justification is. From ["Why did Redis Labs
adopt it"](https://redislabs.com/community/licenses/):

> However, today’s cloud providers have repeatedly violated this ethos by taking
> advantage of successful open source projects and repackaging them into
> competitive, proprietary service offerings.  Cloud providers contribute very
> little (if anything) to those open source projects. Instead, they use their
> monopolistic nature to derive hundreds of millions dollars in revenues from
> them. Already, this behavior has damaged open source communities and put some
> of the companies that support them out of business.

AWS and Azure provide a scalable hosted version of **Redis**, which is BSD
licensed and **open source**. Redis Labs is changing their _other_ code to
"source available", none of which AWS and Azure (to my knowledge) use, because
**Redis** is **open source**.

What adds insult to injury is that Redis **was not developed by Redis Labs**.
Significant funding for the development of Redis was provided by Pivotal and
VMWare, with [additional third-party
contributions](https://github.com/antirez/redis/graphs/contributors).

I almost cannot believe the boldness of this position. In response to AWS and
Azure making money on providing a service based on **open source** software, a
company, which exists entirely thanks to development of **open source** software
funded by other parties, has decided all subsequent code developed
by them shall only be "source available." The logic doesn't make any sense to
me.

_However_, Redis Labs is wholly justified to license their software in
whatever manner they deem fit.

Let's just not pretend it's about Redis, but rather the business's failure to
realize value in these other pieces of software.


### Monopoly on realized value

The second problem with the Commons Clause is that it attempts to dictate an
absolute monopoly on any value realized from these other pieces of software
while masquerading as "open source."

Based on my read of the following section of the Commons Clause, this dictates
a monopoly on _any_ value realized around _any_ of these pieces of software.

> For purposes of the foregoing, “Sell” means practicing any or all of the rights granted to you
> under the License to provide to third parties, for a fee or other consideration (including without
> limitation fees for hosting or consulting/ support services related to the Software), a product or
> service whose value derives, entirely or substantially, from the functionality of the Software.

If I am understanding this correctly, an organization which provides any
support services for a fee which orient around
[ReJSON](https://github.com/RedisLabsModules/ReJSON) for example, would be in
violation of this license. How this
would be enforceable is beyond my legal understanding but I presume that Redis
Labs would have to prove that the value was derived "substantially" based on
ReJSON. Though the license provides no clarity for what potential remedies
might exist for my hypothetical ReJSON support company, other than "stop
existing."

I wonder what legal liability I might have if I sold a magazine called "Redis
Today" which wrote about ReJSON, Redis Graph, Redisearch, and others, and then
sold that through the Kindle store.

The closest potentially related license which comes to mind was the old
Trolltech license applied to [Qt](https://qt.org) which forbade distributing
the software commercially without a license. Since that involved the act of
_distribution_ of somebody else's (Trolltech's) code, the license
enforceability makes sense to me.  Attempting to enforce a monopoly on any and
all value associated with a piece of software, regardless of whether the
software itself was distributed, seems absurd and borderline
malicious.


**I have never seen anythinig quite like this before.**


## A path forward

In my discussion with Mo, he raised a good question which deserves an answer,
paraphrased: _What should a company, which has invested heavily in open
source, do when a vendor like AWs significantly erodes the potential to realize
value from that company's work?_

While I don't think Redis Labs has a leg to stand on in this discussion,
I do think [Elastic](https://elastic.co) is a _perfect_ example of this. Formerly
known as Elasticsearch, Elastic has invested millions of dollars in the
development of [Elasticsearch](https://en.wikipedia.org/wiki/Elasticsearch) which AWS hosts and provides to their customers
for a fee, ostensibly with none of that money flowing back to Elastic. In this
scenario AWS is **not** doing anything morally or legally wrong. Elasticsearch
is licensed under the Apache license (**open source**) and has not only seen
significant contributions from _outside_ Elastic as a result, but has also seen
widespread adoption.

That user adoption may or may not be providing some realization of value for
Elastic the company, but it's hard to tell from an outside perspective. It is
safe to say that Elastic receives some value from Elasticsearch, even if others
are making money off of it.

Which leads to the most important set of questions:

* Is that fair?
* How much would be fair for Elastic to receive?
* What are fair options for Elastic to receive _more_ value?


I believe it is certainly fair. I don't buy the "violation of the open source
ethos" argument proffered by Redis Labs which is, frankly, **bullshit.** The
open source ethos, or free software ethos, is defined by the licenses we chose
when we make our source code available on the internet, or to our customers.
On top of that, there are _numerous_ free and open source cultural norms, but
those are almost as varied as the number of projects floating around.

With regards to how much would be fair for Elastic to receive, for an
Elasticsearch service hosted, supported, and made available by AWS, that gets
to be more complex.  It would be unfair to AWS in this example to presume that
they have not also invested in the development and operation of this service
based on Elasticsearch. Therefore AWS is also entitled to realize value from
their investment.

While Elasticsearch is open source, I think it would be
shrewd for Elastic to utilize their ability to support Elasticsearch and
ownership of the trademark to negotiate a deal with a cloud vendor to:

* Ease support burden for the cloud vendor and provide strong levels of custom
  integration
* Implement a certification program which would require involvement from
  Elastic to allow the service to be called "Elasticsearch."


While I'm a supporter of **free software**, at no point would I suggest
re-licensing to a copy-left license like the GPL or AGPL, as neither would help
the company realize additional value in my opinion. Copy-left licenses are
designed to ensure access to the software by the user and ensure derivative
works remain free. They alone are not sufficient to help squeeze more value out
of a piece of software from a company like Elastic.

With GPL or AGPL licensed code, there's also a perspective many smart people
seem to have which is that those licenses are not suitable here. As Redis Labs
claims: "_We received requests from developers at large enterprises to move to
a more permissive license, because the use of AGPL was against their company’s
policy_." I don't buy this justification, mainly because of the use of a
"Contributor License Agreement" (CLA) with Redis Labs software. I first became aware of CLAs with Trolltech's
Qt, which typically grant the organization copyright thereby allowing the
organization to re-license the software as they see fit.

### Why even open source?

There are many benefits to producing corporate-supported free or open source
software, including:

* It's good marketing. Companies and developers are more likely to experiment
  with and adopt the software. Most organizations seem to have become
  increasing loathe to buy single-vendor pieces of software (SaaS offerings
  excluded) which follow the traditional proprietary software licensing schemes.
* External contributions become possible allowing the software to improve
  without the company directly funding that improvement.
* Increased market pressure in the problem domain which discourages others from
  creating competing products or projects. For example, it's very difficult to
  imagine another solution to the problems which Hadoop solves, since Hadoop
  already exists in the market, and is widely adopted and open source. Thereby
  providing HortonWorks and Cloudera with a competitive advantage: any new player
  has to play on their turf.

There are certainly trade-offs with opening source code up, but at the end of
the day, if you want to have a monopoly on value realized from the software you
create: **make it proprietary**.

Many companies very successfully do this, likely far more than ones who try to
squeeze revenue out of free and open source software.

---


The Commons Clause is an attempt to maintain all of the perceived benefits of
having open source software, _and_ all the benefits of proprietary software,
while avoiding some of the potential downsides of going proprietary such as
potential forks and the subsequent loss of control.

I don't think it's possible to have it both ways here.

I cannot imagine why anybody would bother contributing to any of these pieces
of software, The bad taste this move is leaving in the mouths of many has
damaged both the Redis Labs, and by proxy, the Redis brand. It is unclear what
market value those perceptions hold, but I'm certain they're non-zero.

---

Building any business is difficult, all the logistics and challenges of
building a product aside, finding product/market fit is difficult.  Building a
business around free and open source software is also difficult, but in
different ways than most seem to appreciate. My
employer, [CloudBees](https://cloudbees.com) is one such company endeavoring to
build around open source software and we have frequent discussions about what
is reasonable for the Jenkins community and what is reasonable for the
business. Suffice it to say, there's always going to be a healthy tension. Some
of that healthy tension we discussed in [this
presentation](https://www.youtube.com/watch?v=QENsnDdKvaM) given by my
colleague Liam Newman, worked on by Liam, Kohsuke Kawaguchi, and myself.


Overall I think free and open source software is incredibly important. As a
consumer of software, I'm far more likely to adopt it if for no other reason
than I know that if a business disappears tomorrow, I will still have
_something_ left to work with.

For the businesses which build and support free and open source software, there
is no silver bullet but I firmly believe that there is more than enough room in
the market building a number of successful businesses around all the different
facets of software and its adoption.

