---
layout: post
title: "2026 April: Recently Studied Stuff"
tags:
- rss
- deltalake
- data
- dataengineering
- opensource
---

Similar to last month I have given more intention to some of the interesting
things that I have stumbled across in my feed reader or the fediverse. Rather
than just a quip, boost, or reply, I have wanted to consolidate these thoughts
with more permanance here to my blog. 

Chris' talk below at [North Bay Python](https://northbaypython.org/) was, as
his always are, well-delivered and worth consideration. 

<center><iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/d7AeWFbOTHg?si=zW0bHhRpj--dsrdW" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe></center>

The conclusion that he
draws towards the end is similar to something I was [noodling last
year](/2025/09/20/sacrificing-the-understanding.html):

> At some point somebody, somewhere, is going to have to actually understand
> how things work.

Chris makes the point, as he typically does, much more thoughtfully and with a
stronger philosophical base.

---

Had some discussions with the [delta-kernel-rs](https://github.com/delta-io/delta-kernel-rs) developers after they mistakenly added a _ton_ of new files to `tests/` blowing up test cycle times. Another community member shared [this great overview](https://matklad.github.io/2021/02/27/delete-cargo-integration-tests.html) about **not** using Cargo integration tests.

---

Catching up on [Daniel's thoughts on Data
Quality](https://open.substack.com/pub/dataengineeringcentral/p/revisiting-data-quality?utm_source=share&utm_medium=android&r=cxg56)
and reconsidering the domain. The generation of slop has resulted in renewed
discussions of "but how do we ensure correctness?" which is a great question to
be trying to answer, but I am still rather disappointed with the state of the
art for data quality tooling.

---


I recommend [this blog
post](https://etbe.coker.com.au/2026/03/29/communication-hostile-ais/) which
has some good citations for negative AI behaviors affecting free and open
source communities.

> This is going to be a difficult problem to solve, more difficult than the
> email spam problem we have been unable to solve after 30
> years of working on it.
> 
> This is also a very important problem, we are currently in an age where we have
> access to information that most people couldn't even dream of 30 years ago. We
> also have disinformation that combines some of the worst aspects of
> authoritarian regimes throughout history combined with the worst aspects of
> cult brainwashing. If we lose access to the information but the disinformation
> remains (or get worse) then the result will be terrible.


---


I really enjoy [Planet Debian](https://planet.debian.org) as an aggregator of an international set of voices from the Debian community. I get exposed to so many different view points from around the free software ecosystem, which I really value. This past week I read 
[this blog post](https://blog.bofh.it/debian/id_473) by a debian maintainer which I was so flummoxed by I [wrote out my thoughts on the topic here](/2026/03/25/do-not-comply.html)


---

Streaming tar over SSH is one of the more novel Unix tricks I don't get to use
much anymore. [Drew
Devault](https://drewdevault.com/2026/03/28/2026-03-28-rsync-without-rsync.html)
shared some helpful tips for using it without needing to use incantations of
`rsync(1)`.
