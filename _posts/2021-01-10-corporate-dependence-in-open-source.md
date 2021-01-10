---
layout: post
title: "Corporate dependence in free and open source projects"
tags:
- opensource
- opinion
---


The relationship between most open source developers and corporations engaging
in open source work is rife with paradoxes. Developers want to be paid for
their work, but when a company hires too many developers for a project, others
clutch their pearls and grow concerned that the company is "taking over the
project."  Large projects have significant expenses, but when companies join
foundations established to help secure those funds, they may also be admonished
for not "_really_ contributing to the project."  If a company creates and opens
up a new technology, users and developers inevitably come to assume that the
company should be perpetually responsible for the on-going development,
improvement, and maintenance of the project, to do otherwise would be
"betraying the open source userbase."

Sometimes I wonder if "the only way to win, is not to play."

Corporate involvement in free and open source projects can and should be
mutually beneficial. My previously employer [CloudBees](https://cloudbees.com)
is a good example of the possible symbiotic relationship between corporate
actors and a community. Many people might not know what CloudBees originally
was: it was EngineYard for Java applications. That is to say, it was a
"platform as a service" where you threw your `.war` and `.jar` artifacts over
the wall, and CloudBees would host and operate them. The reason nobody
remembers, is that cloud providers stepped up from the "infrastructure as a
service" domain into "platform" and gobbled all the market up from EngineYard,
Heroku, CloudBees, and a number of other upstarts. If it weren't for a savvy
business move, recognizing that continuous integration and delivery were a key
differentiator, CloudBees would have died long ago.

They hired [Kohsuke](https://kohsuke.org) and a **lot** of people straight out
of the Jenkins community, myself included. When I was there, we had a constant
push and pull between what should be proprietary (CloudBees Jenkins Enterprise,
or whatever it was called that quarter) and what should be upstreamed into
Jenkins.

What many users and other developers overlooked was the **literal millions of
dollars** that CloudBees invested in paid developer time, events, advocacy,
documentation, and marketing. Did CloudBees benefit from this arrangement,
_absolutely_. Did Jenkins also benefit from this arrangement, _absolutely_.

---

Recently in the [Delta project's Slack](https://delta.io) somebody came along,
concerned with the level of involvement by contributors other than
[Databricks](https://databricks.com) in the project. It's not uncommon to see
users come into the project and ask why Delta Lake doesn't support their
preferred compute or query engine, sometimes becoming upset that Delta Lake's
primary supported environment is [Apache Spark](https://spark.apache.org),
which also underpins the entire Databricks platform. Delta Lake was created by
Databricks, who have invested tremendous resources in its development and
stabilization.

While I would love to see them upstream more of their own in-house performance
improvements and tools around Delta Lake, I must also recognize that Databricks
is a _business_ and they're trying to ride that fine line between making money
and not.

The Delta project is however licensed under the Apache Software License 2.0,
easy to contribute to, and fairly well documented.

It's hard for me not to interpret those upset by "missing features" in Delta
Lake as anything more than somebody looking for a free lunch.


---

Linux admins across the internet got upset late last year with [CentOS' change
in approach](https://www.theregister.com/2020/12/09/centos_red_hat). It was hard for me
not to interpret the "backlash" as anything other than anger at no longer
getting Red Hat Enterprise Linux for free.

I think the Red Hat / CentOS relationship is severely underappreciated. The
company is pouring millions of dollars worth of investment into hundreds of
free and open source projects every year. For somebody who has never paid them
a dime, to shake their fist at Red Hat over how they operate their business
which _still funds significant development of free and open source software_ is
entitled to say the least.

---

There is this pattern of "my definition of open source" I see across the
industry, typically aired on Hacker News, Reddit, Twitter, and anywhere else
people shout and complain. The lamentations that Some Company or Some
Individual is not adhering to the "spirit" or "ethos" of how the author defines
free and open source software. The never-ending desire to have capitalistic
corporations pass some [purity
test](https://en.wikipedia.org/wiki/Purity_test) for each and every open source
community they interact with, is not only unfair but unrealistic too.

Free and open source software has created
**enormous** societal wealth and enabled entirely new industries since its
inception in the 1980's (roughly). I believe that is in no small part because
there are very little strings attached past the terms of the licenses and both
individuals and corporate actors can "vote with their feet." For example, I
will be drawn to projects which enrich my life or help me achieve my goals and
ambitions. If I tire of a project, or it's no longer useful, I leave. The same
goes for corporate actors, participating or _leaving_ projects as they deem
necessary in order to fulfill their own goals and ambitions.

I don't begrudge any company which lowers investment, shifts focus, or outright
leaves an open source community. No more than I would begrudge an individual
for doing the same. You don't need to be here for the same reasons I am here,
so long as we're able to both work together while we are.


So long as developers have bills to pay, there will always be a need for
corporate involvement in free and open source software. I believe the path to
success for any project is for developers to have curiosity and empathy towards
the motivations of prospective contributors, whether they are corporations or
individuals. Opportunities to align businesses and individuals can
provide an incredible boost, moving _everything_ forward in the project by
leaps and bounds.

Companies are not automatically "the enemy" of free and open source software,
with effort they can be engaged in ways that are beneficial to the lives of
developers, users, and maintainers. In my experience, it's usually worth the
effort.



