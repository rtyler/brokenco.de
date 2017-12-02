---
layout: post
title: "They will blame you"
tags:
- sysadmin
- devops
- opinion
---

Over the past decade two things have become increasingly clear: practically
every modern industry is part of "the software industry," in one way or
another, and "the software industry" is rife with shortcuts and technical debt.
Working in an Operations or Systems Administration capacity provides a
front-row seat to many of these dysfunctional behaviors. But it's not just
sysadmins, many developers are also called to engage in or allow: half-baked
product launches, poor-quality code deployments, or subpar patch lifecycle
management.

Make no mistake, if something goes wrong, **they will blame you.**

Just yesterday, I was working on my truck in the driveway and a neighbor struck
up a conversation about diesel engines. The conversation naturally led to a
discussion about Volkswagen's massive diesel emissions scandal. I mentioned to
my neighbor how infuriated I was that [Volkswagen executives blamed developers](http://www.latimes.com/business/autos/la-fi-hy-vw-hearing-20151009-story.html)
for the scandal. Prior to that news story, I naively assumed that executives
took ultimate responsibility for the successes, and failures, of their
organizations.

As the sun set, I wrapped up my work and came back inside to see [this story from Engadget](https://www.engadget.com/2017/10/03/former-equifax-ceo-blames-breach-on-one-it-employee/)
wherein former Equifax CEO blamed IT staff for the failure. The Equifax breach
was made possible because of an out-of-date Apache Struts dependency.

Setting aside for a moment that personal-identifying information should _never_
be a single vulnerability away from exposure. Setting aside for a moment that
the majority of the Equifax business relies on **trust**, and should have
therefore been subject to vigorous and regular third-party security audits.
Setting aside for a moment that information security relies on defense in
depth, which is an organization-wide practice. The former CEO blamed
underlings, rather than leadership for the systemic failures of Equifax to
secure highly sensitive personal information.

Make no mistake, if something goes wrong, **they will blame you.**

---

Before I dropped out of college, while I was still pretending to study
Computer Engineering, I took an Engineering Ethics course. We discussed Space
Shuttle disasters, bridge failures, and other calamities, at length. One
recurring theme from many of the incidents was management ignoring or covering
up expert advice, or concerns, by engineering staff. The conclusion drawn, for
the auditorium of young engineering students, was that it was our
responsibility as "Professional Engineers" to ensure the safety and quality of
our work, and make sure that we had solid documentation for any safety concerns
we raise, otherwise we could be held liable.


I am starting to believe that, before the decade is over, we will start to see
developers and systems administrators held civilly liable for failures in
systems we create and for which we are responsible.

It is up to you to advocate for good patch lifecycle management practices. It
is up to you to build systems which prevent poor-quality code deployments. It
is up to you to advocate for well-designed products which defend user privacy
and personally-identifiable information. Because make no mistake, if something
goes catastrophically wrong, they will blame you.
