---
layout: post
title: Support Escalations to Engineering are Outages
tags:
- opinion
- software
---


I have been thinking a lot about customer support over the past two years. My
role as "Director of Evangelism" has placed me at the leading edge of what
could be referred to as "customer success" or "user education." What I have
come to appreciate, especially in Enterprise-focused startup companies, is the
connected and complimentary roles between Product, Engineering, Quality,
Evangelism, Customer Support, and Sales. In an Enterprise-focused organization
what defines the success for each of these groups is fundamentally the same,
but they are not all equally "connected" to the customer's feedback and
concerns.

My mental model is one of a line spiraling outward from the customer. The
Account Executive should have the highest understanding of what that
particular customer needs and wants. Moving outward, the Support team should
have a fairly good understanding of that customer's initiatives over time,
their stumbling blocks, and so on. Further away from a discrete customer,
Evangelism/Marketing/Advocacy should understand the general problem domains
that these "types" or "personas" of customers are facing, in order to tailor
education or marketing content to help inform them. Perhaps furthest out from
a single customer, Product and Engineering must understand classes of problems
faced by types of customers, and devise solutions therefore. This of course is
not to say that Product and Engineering _should_ be ignorant to the needs of
customers, but in order for a Software Business to scale, they may necessarily
focus less on individual customers' needs and instead try to create generalized
solutions to problem domains.


Each of the four companies I have worked at thus far had Customer Support in
some form or fashion, but only at the last two, those which turned their focus
more towards Enterprises, have I noticed patterns of "escalations" into the
Engineering teams. **Escalations** in Support, like those in Operations, are
the passing of tickets which require either more expertise, more authority, or
a larger response than the previous level of responsibility.

Suffice it to say, Support looks really a lot like an Operations team to me.
Looks like an Ops, complains like an Ops, drinks like an Ops, must be an Ops!

What tends to happen in Operations teams with regards to escalations is that
sometimes an incident requires custom knowledge by the person who is
responsible for the application to resolve.  Those weird, yet-to-be-documented,
behaviors from an application which go bump in the night and degrade service.
When these things happen, typically somebody from Engineering is looped into
the discussion, some developer who is not accustomed to their phone ringing in
the night will sleepily answer only to be barraged with trivia about code they
have written. In high-performing and mature organizations, typically the next
day or whenever the incident has been resolved, people want to have
retrospectives. They want to perform a root-cause analysis and fix the root
cause so that next time they can sleep off their future hangovers in peace and
quiet.

From my observations of Enterprise support, something eerily similar to the
first part tends to occur. Somewhere between a customer's infrastructure and
our software, something goes wrong, or a weird yet-unknown use-case crops up
which is not well supported by our software, and causes grief for a customer.
Even the most stellar of Support teams will eventually need to escalate to
Engineering, if for no other reason than to ask "what the hell is _supposed_ to
happen here?"

While I plead ignorance of what goes for best practices in Customer or
Technical Support circles, I wonder what would happen if we treated every
single escalation into Engineering like a "**production outage**?"

If the Support team is unable to resolve an issue for a customer, in the
strictest terms, to me that is either: an education problem to resolve within
the Support team or **a bug**.

The first option is easy to resolve, training, documentation, more mentorship
are all easily within reach for the savvy organization. The second one is a
_very_ difficult pill to swallow, and where treating an escalation as an outage
offers the most rewards.

"The customer has done something wrong and this is a self-inflicted problem."

Bug. The software should not allow the customer to get into broken states.

"But the customer is using the software incorrectly!"

Bug. If the software cannot be easily used properly, then the design and user
experience are broken.

"But the customer applied local scripts and hacks, we cannot support those!"

Bug! If a customer has to further extend the software in order to make it
useful, then perhaps we're not solving the problems for the customer we thought
we were.


Perhaps my favorite part of the Outage Retrospective or Post-Incident Analysis
is that it forces an organization to pause and reflect on whether it is
successfully delivering the solutions it portends to deliver. Like an NTSB
Accident Report, walking an incident back, chronicling all the missed
opportunities for remediation, documenting the numerous fail-safes which didn't
help, and so on, when applied well can only lead to better software, a stronger
organization, and more satisfied customers.


I don't really know whether this is already done inside in some form within
organizations, including my own. I do know, however, that treating failures not
as inevitabilities but as opportunities to improve, is the only sure path
forward.


The fastest possible resolution for a customer support ticket, is to prevent it
from ever needing to be filed.
