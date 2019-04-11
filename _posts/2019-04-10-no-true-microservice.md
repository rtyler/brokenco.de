---
layout: post
title: No True Microservice
tags:
- opinion
---

"But they weren't doing true microservices" he droned on, while my train of
thought came grinding a halt on the assertion. In my experience, many software
developers apply all sorts of purity tests to the world around them, especially
when it comes to "legacy" code. In most of my experiences, it has been
delivered more subtly than this textbook example of the [No true Scotsman
fallacy](https://en.wikipedia.org/wiki/No_true_Scotsman). "Microservice" is
already a silly term, one which many people defend by evoking the mythic status
of "the unix philosophy." Composition of components is an extremely valuable
trait in a system, especially as an organization scales with new people and
projects.

This misguided notion that everything in a service-oriented infrastructure
should do "one thing and one thing well" is at complete odds with the realities
of data affinity and network latency. After trying to break up a few monoliths
"into services" in recent years, my focus has shifted from what serves the HTTP
requests and has settled onto: how the data is stored and accessed. Taking a
monolithic application and merely swapping function calls for remote procedure
calls is not _actually_ solving anything.

The "test" that I apply to the "no true microservices" approach is this: should
authentication and authorization be handled by one service, or two? I think the
question gets at the heart of many service-oriented architecture designs.
Authentication is "easy", compared to authorization which can bring in
a whole carton-load of business logic and data requirements. That said, are
there any flows now, or in the immediate future, which need authentication but
**don't** need authorization? Applying the "one thing" rule, these two
functions should probably be performed by two separate services. But if you
don't have any need for authentication without authorization coming alongside
it, then two separate services introduces another network call, another
service-dependency to manage, and unnecessary complexity. "But we might need it
some day!" a microservice aficionado might retort. I certainly agree, we might
need lots of things. Building and **delivering** software requires trade-offs,
and the business' requirements for the next 6-12 months are not going to be
addressed by pre-optimizing the split of these two concerns into separate
services, then it is likely best to say [You Aren't Going To Need
It](https://en.wikipedia.org/wiki/You_aren't_gonna_need_it) and move on.

It is always better to refactor a production system in the future, than to try
to design for imagined requirements in the present.

---

The availability of "Functions as a Service" does bring us closer to a "one
thing and one thing well" world. It also exaggerates the myriad of management,
monitoring, and debugging concerns which already affect service-oriented
architectures. This is not to say that Functions as a Service (FaaS) are a bad thing,
quite the contrary. I love the model for simple and stateless API endpoints,
like handling inbound requests, enriching them, and putting their contents
directly into a commit log/queue system for later processing and data
warehousing. To suggest that all services fit the FaaS model is patently
absurd; I feel similarly about the "one thing and one thing well" model of
microservices. 

Avoiding the No True Microservice fallacy, I recommend considering
service-oriented architecture design with the following, intentionally ordered
concerns in mind:

1. Debug-ability: if we can't debug it, we fail.
1. Deliverability: if we don't ship it, the team fails.
1. Manageability: if we cannot maintain this code, evolving it to meet the
   needs of the business, then the product will fail.
1. Scalability: if we cannot scale it to meet customer demand, the business
   will (probably) fail.

Service design is _always_ about trade-offs. Whether attempting to build
something from scratch, or replacing a monolith, it is important to prioritize
the concerns appropriately. Always keeping in mind that our first priority is
to deliver a functioning service, not to come up with the "best" whiteboard
design possible.
