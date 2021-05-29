---
layout: post
title: "The kind of smart appliances I want"
tags:
- opinion
---

I _want_ smart appliances, not the current commonly understood "smart"
Internet-of-Things (IoT) appliances, but smart in actually useful ways.  A
couple years ago I had solar panels installed. The "smart" I want is pretty
simple: I want devices that know about surplus energy. Devices which have lower
power idle modes that can kick into more productive usage when solar power is
bountiful. Generally IoT devices seem to be almost everything I don't want. I
don't need devices that listen in on my conversations, track my data, and open
up security holes in my home network. In this post I want to outline what I
_do_ want from "smart" appliances in my home.


In California electricity metering  for residential solar customers typically
involves variable rates for off-peak, partial-peak, and peak usage. In essence,
when everybody is awake in the middle of the day (peak) grid-power is the
highest price while 3am when little utilization is present (off-peak) the price
is lowest. Solar customers typically contribute back to the grid during that
peak demand and then generate nothing after dark and will draw from the grid in
partial-peak and off-peak modes.

What this means in practice is that there is incentive to run electricity
intense workloads either in mid-afternoon, when I am generating "free" power,
or in the middle of the night when grid-power is cheapest.

Accordingly some behaviors have changed. We don't place a load of clothes in
the washer _whenever_ but rather will use delayed starts to fall into one of
those optimal time periods. The same goes for the dishwasher. When I had an
electric car, returned during the pandemic, it was programmed to only charge in
the off-peak hours as dictated by the utility. 

---

_Side note:_ if you have a home-charger for your electric car, it still might
be too expensive to charge off of solar during peak. Our Nissan Leaf would draw
6.6kW while our slightly oversized solar system maxes out at 4.6kW. It was
still more cost-effective to charge at night.

---

Programming timers is a simple and effective way to spread out electric load,
but I want **smart** devices, not timed devices. Other major usage falls into:

* Climate control (AC/heat)
* Refrigerator
* Computer(s)

Each of these could be smarter in their electricity usage. Products may exist
for these use-cases, but most of what I have seen are for off-grid applications
rather than "smarter" residential on-grid energy consumption.

### Climate Control

I would love to be able to set ranges of acceptable use for surplus energy,
especially when it is hot. For example, in the hottest periods of the summer to
reduce load on the grid and comfort in the house, nothing should try to push
lower than 74F, but we're generally comfortable up to 78-80F inside. This is of
course zone dependent, some parts of the house we do not typically occupy
during the day, so those can be safely allowed to get warmer if there is no
surplus power available. If surplus power is available however, they should
stay at the desired comfort level.

Even smarter would be to recognize that surplus power falls off at the end of
the day, and to be proactive and pre-cool or pre-heat areas of the house before
the surplus power disappears into the sunset.

### Refrigerator

The refrigerator is the biggest constant energy draw we have in the entire
house. The ideal smart refrigerator would turn surplus power into reserve
"cold" for use as that power dissipates, basically with the objective of
reducing the amount of times the compressor needs to turn on during non-surplus
energy periods. Ideally it would tap into these same surplus power events as
other appliances and freeze a coolant bladder or something analogous. If there
were some way to _only_ run the refrigerator off of solar power, allowing it to
turn itself into a glorified icebox through the night, that would be incredible.

I definitely don't want an "off-grid" refrigerator, but somewhere in between
what off-grid folks do and the typical residential unit would probably fit my
desired use-case.

### Computers

Unsurprisingly, I run a number of computers at home, having a gigabit fiber
line has certainly helped me "domesticate" some of my prior remote server
workloads. The "smartness" I would like is to queue up or schedule high CPU
tasks for _either_ surplus energy periods or off-peak periods. For example,
video encoding, encrypting backups, or image processing could all be spun up
during these periods of cheap energy.

What could be even more interesting is that if the computers pinned their
different CPU performance profiles to these events. If a chipset supports three
frequency, and therefore power utilization levels, during peak/partial-peak
periods with no surplus energy available if they pinned themselves to the
lowest setting, and letting the OS scheduler sort it out after that, would be
quite interesting.

For laptops that are mains connected, it would also be interesting to have the
computer self-regulate off of battery power to both keep the battery from
deteriorating on constant mains power, but also to spread electric load around
during the day.

---

Overall I think the challenge for homeowners like myself is around capturing
surplus energy to make use of it. As is widely reported, the biggest challenge
with solar applications is that surplus energy capture during the day. From an
IoT or "smart" device standpoint, the biggest challenge to me is security and
privacy. I am _extremely_ weary of internet connected devices that area
reporting data about my life back to an unknown number of data brokers. Or
worse, devices which open up security holes on my network and endanger me in
other ways. I'm happy to put devices on the wireless network, I'm much less
happy when they talk to "cloud services."

The peak "give back" to the grid I have observed on my system has been over
3.5kW, which is great for my net usage report but I end up "selling" highly
valuable energy at a low rate, and then buying back electricity when I need
it.

The more I can reduce the amount of energy I have to "buy back" from the power
utility the better!


If you have tips for smart appliances or other solar utilization tips, feel
free to shoot me an email to `rtyler@` this domain :)
