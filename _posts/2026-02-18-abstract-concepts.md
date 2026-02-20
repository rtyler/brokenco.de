---
layout: post
title: Abstraction cannot hide complexity
tags:
- software
- opinion
---

One of the first advanced concepts taught to people learning to code is
abstraction, practicing taking logic and _hiding it_. Object-oriented
programming articles and books frequently will encourage the reader to take
logic and complexity and build simpler APIs around it. Abstracting _and_
encapsulating that logic helps us offload cognitive burden and allows us to
focus on other aspects of the program. Abstraction is useful. Abstraction is
good. 

Abstraction can only hide complexity for so long.

In my weekly conversation with [Robert](https://github.com/roeap) we were
discussing potential solutions to some ungainly APIs. In the discussion of the
design I found myself in a familiar predicament: _maybe this API could work if
we just found the **right** abstraction_. The reason this concept is so
difficult is because we have not found the right model, we must discover the
_correct_ abstraction and then this will all be easier!

Programming as an act of
[anamnesis](https://en.wikipedia.org/wiki/Anamnesis_(philosophy))

> The concept posits the claim that learning involves the act of rediscovering
> knowledge from within oneself.

The [delta-rs](https://github.com/delta-io/delta-rs) repository has a number of examples
of this pathology. Multiple attempts by different people, myself included. All
searching for ways to make a complex thing simpler.

Ultimately **abstraction cannot hide complexity**.

Hard things are sometimes just _hard_. Many abstractions are
[potemkin](https://en.wikipedia.org/wiki/Potemkin_village) barely hiding the
truths beneath, but in a complex system these characteristics simply cannot be
hidden. Think of the simple `Request` and `Response` classes in any language
for interacting with HTTP services. There's HTTP 1.0/1.1/2.0 to consider,
keepalives, compression, cookies, redirects, state, all manner of things that
creep in from one direction or the other.

[Kyle Kingsbury](https://aphyr.com/) and his [Jepsen](https://jepsen.io/) work
is a _repeated_ reminder about the faults in our abstractions and consistent
attempts to hide the complexities behind a `Transaction` or a `Write` or just
about _anything_ in a distributed system.

**Abstractions are useful** but they are _never_ reality. They are instead
[images on the cave walls](https://en.wikipedia.org/wiki/Allegory_of_the_cave).

There is no one true abstraction waiting to be found. It  simply does not
exist. The entirety of the technology stack is filled with useful but
ultimately fictional interpretations of reality.

One of our challenges as software developers is knowing when to accept the
abstraction..

Sometimes complex things are _simply complex_.
