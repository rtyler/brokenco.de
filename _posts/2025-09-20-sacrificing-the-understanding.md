---
layout: post
title: Sacrifice to AI
tags:
- software
- ai
- opinion
---

What a wild time to be alive. It's really quite something. How wonderful it is
to have a phrase like "what a wild time to be alive" that could mean a dozen
different moderately positive or extremely negative things depending on where in
your news or social feed you find this article. 

There's a **lot** of not okay stuff going on right now, which makes it
difficult to really difficult to articulate much about the moderately not-okay
or mildly annoying things which are _also_ going on right now.

Not only are they [putting blue food coloring in
everything](https://blog.foxtrotluna.social/theyre-putting-blue-food-coloring-in-everything/),
a bunch of people I know are **craving** blue food coloring. They're building
out roadmaps to further enmesh blue food coloring in their processes. The only
path towards progress, efficiency, and success is to adopt blue food coloring.

I have been assured that blue food coloring is going to absolutely rock my
fucking world.

Then some of its **proponents** will _also_ write things like this:

> I find that AI models are especially prone to handing me walls of text when
> they think they're "done". And I'm prone to just tuning out a bit and
> thinking "it's probably fine" when confronted with a wall of text written by
> an agent.

(sidenote: I make spelling errors all the time but the author of the above
quote originally misspelled two words which must have slipped by _the agents_)

All hail blue food coloring. 

----

I have enabled "Blue Code Review" on some repositories. Shortly thereafter I disabled it, as it:

* Gave incorrect information.
* Nitpicked the author about spelling. That one was particularly silly because
  the author was using the British spelling of words.
* Offered to introduce bugs.


You shouldn't be using that version of blue food coloring. Try using a
different vendor. We just need to introduce some rules files to the repository
to make things work better.

These people are absolutely insane.

Here are some "rules" I plucked from an "awesome rules" repository"

> _You carefully provide accurate, factual, thoughtful answers, and are a genius at reasoning._

> _You always use the latest stable version of Django, and you are familiar with the latest features and best practices._

> _Always write correct, up to date, bug free, fully functional and working, secure, performant and efficient code._

**What incredible technology!**

I feel like this is some elaborate joke that has gotten out of hand.
Why are these people trying so hard to make the machine think for them?


---

Generally speaking the blue food coloring has been a drag on my productivity.

There was the situation where a developer took generated code all the way to
production and it crushed them because they _also_ tuned out and thought "it's
probably fine" as they shipped something with `O(x^y)` performance.

Then there was that time where another a Blue-assisted developer proposed a
pull request which caused a `ListObjectsV2` operation of an entire prefix when
all that was needed was to fetch a single object via `GetObject`. Fortunately that one exploded on the launch pad.

One time it was actually sort of useful, a developer ran across a curious bug
where a buffer consistently truncated at the same length. The machine was able
to tell them where that magic integer came from, but unfortunately the
developer didn't really know what to do with that information. (They asked me).


It all feels like such a waste of energy, and for what?

So much churn on what the "right way" to use it. Make sure to trim your context
window, try increasingly elaborate persuasive prose, cross-reference one
version's output against another too. A million artificial monkeys slapping on
artificial keyboards racing to produce what you might probably want.

At some point somebody, somewhere, is going to have to actually understand how
things work.

You cannot trick the machine into doing your thinking for you, better to do it
yourself.
