---
layout: post
title: Managing buffer overflows
tags:
- home
---

Working in the data storage and services it can seem like everything revolves
around capacity and throughput. We don't think of throughput until it is
lacking. A traffic jam, a flipped breaker, or an overflowing drain. There are
architectural changes we make to improve throughput and there are tactical
fixes. This post is about the tactical fixes.

By American standards my house is old, approaching its eightieth birthday, the
bones are good, but it was designed for a different era. At some point the
detached garage was attached, with a concrete slab stretching the 12ft between
the two. On the garage side exists the laundry room, I later learned that the
sewer line connects on the house side.

Embedded in this concrete slab are water lines running one direction and
what appears to be a 2" drain line running the other direction.

Whether it's internet, electricity, or water, the size of the pipe has a big
impact on _throughput_.

For unclear reasons the washer's drain cycle will no longer drain without
dumping water all over the floor.

I snaked the drain. Nothing.

I poured fun solvents and drain cleaners through the pipe. Nothing.

I extended the drain piping upwards to try to add a bit more gravity pressure
to the system. Nothing.

I noticed during my diagnostics that the next drain on this pipe would gurgle
when overflows would happen, indicating that there was simply insufficient
airflow to the pipe system. I tried some measures short of drilling new holes
in the roof. Nothing.

I even researched whether I could change the output flow on the washer, to no
avail.

---

The house was empty when we moved in. Vacant for almost a year sitting
on the market. I never got to see how the previous owner had laid anything
out or how they used the difference areas like the laundry room. 

2" galvanized pipe connected the laundry room drain to a concrete sink with
cracks in it. Why a concrete sink I will never know. Why the sink didn't have a
p-trap, also remains a mystery. A second 2" galvanized pipe, threaded, sticks
out from the wall at roughly the height for a typical washer drain outlet box.

A modern 2" PVC pipe with appropriate venting could support a modern washer.
Chances are the actual lines under a modern house are 3" or 4" depending on
local code. Galvanized pipe gets rusty, clogged, and is generally terrible for
purposes of transmitting water.

With all my other tactics having failed, I revisited that cracked concrete sink.

The idea is so simple. It annoys me that I didn't arrive at this conclusion
sooner. That funky concrete sink wasn't a typical laundry room sink. Where you
soak your delicates or wash the mud off your garden clothes.

That broken sink was a queue, a capacitor. With the design constraint of a
narrow pipe set in literal stone, the only possible way to handle higher
output from modern washers was to provide a buffer, a [store and
forward](https://en.wikipedia.org/wiki/Store_and_forward) protocol in physical
form.

My newly installed laundry room sink has completely resolved the buffer
overflows, 

As is always the case with home ownership, one item crossed off the list means
another one will soon appear..
