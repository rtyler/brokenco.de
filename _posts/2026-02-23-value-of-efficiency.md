---
layout: post
title: "The value of efficient software"
tags:
- software
- cloud
- opinion
- rust
---


The value of efficient and thoughtfully designed software is going to continue
to grow. What I never expected was for the "AI" data center to be the catalyst
that could help many organizations understand that argument!

Today Hetzner, a major cloud services provider in Europe [announced](https://www.hetzner.com/pressroom/statement-price-adjustment/)

> There have been drastic price increases in various areas in the IT sector
> recently. That is why, unfortunately, we must also increase the prices of our
> products.
>
> The costs to operate our infrastructure and to buy new hardware have both
> increased dramatically. Therefore, our price changes will affect both
> existing products and new orders and will take effect starting on 1 April
> 2026.


Last year for Earth Day I wrote [on the Buoyant Data blog](https://www.buoyantdata.com/blog/2025-04-22-rust-is-good-for-the-climate.html)

> Time is money. In the cloud time is measured and billed by the vCPU/hour and
> the most efficient software is always the cheapest.


Nothing makes the case for more efficient software like more expensive
hardware!

In the past five years I have _repeatedly_ seen success in taking a system
written in a less-efficient platform, redesigning and rebuilding in Rust, and
reaping the rewards in lower operational costs.

For a simple exercise, imagine a service which costs $100,000/year to operate,
that's roughly $1,900 a week. Assuming a developer's time costs roughly $6,000
a week, taking a month to rebuild the service might cost $25,000. The
efficiency needed is then only about 25% to pay off that rewrite in a year, but
what I have consistently seen is an _order of magnitude_ change in efficiency.

Instead of costing $100k, these newly deployed services tend to cost less than
10-20% of their predecessors. Recouping the cost of conversion in a couple of
months, freeing up money to go towards different investments.

The biggest cost to contend with is opportunity cost and that one is _much_
harder to model, and also much less subject to changing prices by your vendors.


