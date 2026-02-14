---
layout: post
title: Screaming in the Cloud
tags:
- opinion
- aws
- podcast
---


One of the reasons I work where I work is because of the fascinating
data-at-scale problems that they have. This has led me deep into the world of
[Delta Lake](https://delta.io) and AWS S3.  Not one to take anything too
seriously, I have been cooking up absolutely bonkers solutions to some of these
_billions-scale_ challenges I am tasked with solving.

Recently I was fortunate enough to discuss some of the objectively insane ideas
with an old PuppetConf pal [Corey Quinn](https://www.linkedin.com/in/coquinn/).

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/TZj38Bm1DC4?si=m_jo0HOFPHqPC--2" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

In [this post](https://tech.scribd.com/blog/2026/content-crush.html) I wrote
about the design of Content Crush and how Scribd is consolidating objects in S3
to minimize our costs. 

_Checking if files are damaged? $100K. Using newer S3 tools? Way too expensive.
Normal solutions don't work anymore. Tyler shares how with this much data, you
can't just throw money at the problem, but rather you have to engineer your way
out._

For better or worse I have been so much fun coming up with crazy data solutions
during the day, that I also am doing it on nights and weekends with my
consultancy [Buoyant Data](https://www.buoyantdata.com).

In the coming months I'm expecting to have some more time free up, so I'm
hoping to find another couple clients who need some AWS and data expertise to
spice up their infrastructure! You can find me at
[rtyler@buoyantdata.com](mailto:rtyler@buoyantdata.com) for that type of thing,
but if you just want to share your own crazy ideas with me, or commiserate with
me about S3, you can find me at
[rtyler@brokenco.de](mailto:rtyler@brokenco.de).

