---
layout: post
title: SF Redis Meetup Recap
tags:
- redis
- meetups
---

I went to the [impromptu redis SF
meetup](http://groups.google.com/group/redis-db/browse_thread/thread/b56c0c3819aaf922#)
yesterday at Epicenter Cafe in SoMA and I figured I'd write up some notes about
it after the fact.

I'm very thankful that [Andy McCurdy](http://twitter.com/andymccurdy) (of
redis-py fame) got the ball rolling on this since [Pieter
Noordhuis](http://twitter.com/pnoordhuis) (of hiredis and redis fame) is only
in town for a few more days.

Apologies if some of my recollections are incorrect, I typed this up the day
after.

----

The meetup was predictably sized at about 10-12 folks at it's peak, with a lot
of the discussion centered around hammering [Pieter](https://github.com/pietern)
with questions.

For those who don't know, Pieter Noordhuis is 50% of the full-time engineering
staff working on Redis for VMWare (Salvatore being the other 50%).

The two main themes of discussion were: clustering and the scripting branch.

### Clustering

Probably not going to work well if you have very large keys or very large
values. Better suited for smallish keys/values which can be easily migrated
from one node to another. Migrations will block a request for the
in-transit key and wait for an acknowledgement from the destination node,
if the migration succeeds then the request will respond with an "ASK {host}"
styled response, otherwise it will return the value (IIRC) if it could not
be migrated properly.

Some additional commands and responses will be added to the protocol to
enable better client support for clustering. It is hoped that clients will
do a sufficiently good job of abstracting clustering out so it's more
opaque to API consumers.

The Redis team is trying to avoid solving too many perceived problems with
clustering before it's released and they can see how people are using it in
the real world.


### Scripting Branch

If you're not familiar, there's a branch of Redis right now that has a lot
of folks excited as it adds Lua scripting support to Redis by way of the
`EVAL` and `EVALSHA` commands. Allowing you to send tiny scripts to the server
and have it atomically evaluate the script (think: classic check-and-set
problem).

The way things are going, there's certainly seems to enough interest to
warrant merging the scripting branch into a more mainline branch (2.4 or
something).

They intend on exposing `EVALSHA` as part of the API, allowing you to invoke
a previously registered/evaluated script by the SHA1 of the script.

Scripting and clustering are orthogonal, while the regular key-space is
clusterable the hashes containing the Lua code objects and the script SHA1s
is completely separate. Any server you want to evaluate a script on, must
be informed of that script itself.

While you can disable certain commands in the Redis config, I expressed my
anxiety about letting clients willy-nilly call `EVAL` as the script
evaluation will block the event loop in Redis until the script is finished.
Pieter seemed interested in a potential configuration of allowing EVALSHA
while disallowing `EVAL`, allowing deployment (see: puppet) to pre-register
"approved" scripts in some form or fashion to be appropriately (and safely)
called.

----

Overall the night was interesting, Pieter and Salvatore are both really bright
guys who approach these problems very thoughtfully and carefully (yet not
paralized by uncertainty).

Redis has a bright future.

----
