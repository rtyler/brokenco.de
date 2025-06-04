---
layout: post
title: "Lowering my TCO with battery power"
tags:
- solar
---

I spend a _lot_ of time looking at and optimizing costs, kind of for anything.
I do it as part of my [day job](https://tech.scribd.com), I do it as part of my
[night job](https://www.buoyantdata.com), and of course for my home life as
well. Spreadsheets on spreadsheets tracking and analyzing, finding
inefficiencies and opportunities for investment. In 2024 an opportunity
presented itself to invest in a next generation home battery which I can now
unequivocally say is a **good investment**.


I [wrote a few years ago](/2021/07/25/cost-of-power) about the frustrating
discrepancy between the retail and the wholesale cost of power with Pacific Gas
and Electric (PG&E) in California. Capacity and performance of home batteries
have finally tipped the scales in the consumer's favor over the past few years.

The model I purchased was recently released to the market, and my patience has paid off quite well!
This type of home battery allows building much larger arrays, and each unit has
a capacity of 15kWh and can discharge up to 10kW at a time.
Essentially the battery hardware is not my limiting factor, but rather my solar
panel capacity. A good problem to have, especially given the trajectory of
solar panel prices over the past 5 years, recent tariff turmoil
notwithstanding.

The most notable downside to having new solar and a home battery installed in
the middle of winter: **there's not much sun**. The days are short and the
angle of the sun in the Northern Hemisphere noticeably reduces solar power
output. Over the past two weeks however there has been enough sunny days to
provide me with really compelling performance data.


Consider the following chart:

![Electricity cost per day](/images/post-images/2025-solar/cost-per-day.png)


This displays the past couple months of electricity costs per day along with
the 5-day moving average. The system was fully provisioned towards the end of
January, but due shortcomings in winter solar production the battery was not
fully charging on a daily basis until mid-February.

After mid-February the solar production has started to shift, allowing the
storage of "free" power during the mid-point of the day which dramatically
pulls down the average costs. Based on my preliminary math, the battery system
will _likely_ pay for itself in savings in less than five years.

That's a good clean investment in my book!

---

**2025-06-04 update** I am including this updated chart which demonstrates the
negative (credit) usage results from this aggressive "peak arbitrage" approach.

![Electricity cost per day](/images/post-images/2025-solar/cost-per-day-summer.png)

---

## Configuring the schedule

Solar customers must adopt "time-of-use" schedules with PG&E which means I pay
peak rates during the late afternoon/evening, but other parts of the day where
power is cheap, I pay "off-peak" rates.

My current rate arbitrage schedule is configured as such:

* **12-6:00** off-peak EV charging.
* **6-15:00** off-peak self-consumption and battery charging.
* **15-24:00** peak and partial-peak self-consumption and **grid-export**.

The **grid-export** is what really causes the dramatic downward trend in the
moving-average above. Having analyzed what my typical consumption is on a 24
hour cycle, I have configured the battery system to send as much power back to
the grid as possible during the peak period. On my usage data this means that
the house is not consuming any electricity during peak _but also_ earning
credits by offloading power back to the grid when it is priced the highest.

Despite only being early March, there has already been at least one day of
_negative cost_, i.e. surplus.

---

I'm looking forward to seeing how this data evolves as the spring and summer
progress. As the sun gets higher in the sky and as the days get longer our
solar panels will have a much larger and stronger generation period each day. I
am expecting a good surplus of power on the year!
