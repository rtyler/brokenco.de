---
layout: post
title: The Five Stages of Incident Response
tags:
- infra
- devops
---

Training engineers to own their infrastructure can be challenging. It is
important to help them recognize the five stages of incident response, because
only then can system healing begin.

1. **Denial** - The first reaction is denial. In this stage, individuals
   believe the diagnosis is somehow mistaken, and cling to a false, preferable
   reality. "_This isn't an incident_" "_This lag will recover soon_"
2. **Anger** - When the individual recognizes that denial cannot continue, they
   become frustrated, especially at proximate individuals. Certain
   psychological responses of a person undergoing this phase would be: "_Who
   deployed this crap?_" "_Why would this happen during my on-call?_"
3. **Bargaining** - The third stage involves the hope that the individual can
   avoid an incident. Usually, the negotiation for extended uptime is made in
   exchange for reformed development practices. "_Maybe our users will stop
   accessing this endpoint_" "_If this can hold on just a little longer, we can
   deploy a fix tomorrow!_"
4. **Depression** - During the fourth stage, the individual despairs at the
   recognition of the failure.
5. **Acceptance** - In this last stage, individuals embrace the inevitable
   outage and begin to react, occasionally even following the runbooks which
   had been previously defined for just this type of scenario.

---

More seriously, without adequate documentation, drills, and training, most
engineers will *not* do the right thing during incidents, and may even
exacerbate them. There is nothing worse than a SEV3 becoming a SEV1 because the
engineers responding rushed to judgement and in a panic hit all the buttons
before understanding the problems they were facing.

I made a comment on Twitter recently that [Scribd](https://tech.scribd.com) has
had the most mature incident response processes of any company that I have
worked for. Still, there is *tons* of room for improvement, and incident
response is a constant topic of discussion and focus.
