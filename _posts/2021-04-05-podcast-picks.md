---
layout: post
title: Subscribe to my "Podcast Picks"
---

I am have always been a fan of podcasts, but have never had really any good way
to share the interesting things I am listening to. A couple weeks ago I struck
upon an idea that seems so bafflingly simple in retrospect: I could just host
my own podcast feed.

Podcasts at the end of the day are just [RSS
feed](https://en.wikipedia.org/wiki/RSS) which are a specific XML format.
Clients periodically reload the RSS feed and when new `<item/>` tags are
present, then they will typically prompt or automatically downloaded the nested
`<enclosure/>`. It really is a simple format, and trivial to wire into my [blog
set up](https://github.com/rtyler/brokenco.de).

Check out my [Podcast Picks](/podcast-picks.xml) feed, which you can add to
your podcast player to get semi-regular updates of podcasts episodes that I
have found interesting, funny, or generally usefu.
