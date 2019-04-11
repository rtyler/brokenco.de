---
layout: post
title: "Self-sabotage with enterprise pricing"
tags:
- opinion
---

"Enterprise Software Sales" is not something I ever imagined spending as much
time considering as I have over the past four years, but life is full of
surprises isn't it? At my previous gig we had changed our pricing model at
least once during my time, and I learned quite a bit from the trade-off
discussions which were had. Now sitting on the other side of the table, I get
to enjoy a different perspective on the same underlying problem: how should
enterprise software be priced? The question is important to answer, not just
from a business perspective, but from a _user_ perspective; **the pricing model
determines how your software will be adopted and used**.

From the vendor's side, there is an understandable desire to maximize the
revenue potential from each sale, while minimizing the cost to acquire and
maintain the account. From the customer's side, there is an opposing desire to
minimize the cost for each piece of software, minimize the overhead of dealing
with the vendor, and maximize the utility and positive impact across the
organization. Vendors can optimize their worldview by applying the same
pricing model and scheme across their entire customer-base. What they can lose
sight of however is that customers have to navigate and manage a complex maze
of different bespoke pricing models, and somehow come to a realistic and
defensible budget.

Any route has trade-offs, but I want to share my perspective on the
user-behaviors different pricing models have within an organization. I will try
to avoid too much naming-and-shaming with particularly counter-intuitive
pricing.

## Per Resource


The most common model which I have experienced is the "per resource" model,
in which the vendor segments along some resource boundary and prices for N
number of additional resources defined or used. I would consider the most
egregious example of this pricing model from Oracle, charging per-cpu operating
the software. Newer and less dastardly companies such as CloudBees and Datadog
have applied similar variants of this approach. When I joined CloudBees, the
flagship product at the time ("CloudBees Jenkins Platform") was priced "per
Jenkins master." GitHub's old pricing model followed a similar vein with
per-private repository pricing. Datadog as another example, has an interesting
blend of per-host and quantity-of-metrics pricing. 

Depending on how the resource boundaries are defined, this is probably the most
easily understood approach for both vendor and customer. We are very
accustomed to applying value constructs to "finite" resources.

The most obvious consequence of this per resource pricing model are weird
organizational optimizations, and in some cases, customers applying
poor/counter-intuitive practices to their adoption of a piece of software. For
CloudBees, we observed a number of customers would overload a single Jenkins
master to avoid paying incurring the organizational pain of trying to upgrade
their account/licenses. Many of those same customers would then pepper our
talented support team with questions for which the answers were often: "stop
putting everything on one Jenkins master!"

GitHub had similar challenges with per-repository pricing. Attaching a cost to
private repositories led some organizations to try to put too many things in
larger and unwieldy repositories. Or perhaps worse, some organizations I
have encountered limited which projects internally were allowed to use GitHub
due to cost. An ideal outcome for GitHub in an organization is most certainly
widespread adoption across numerous teams and projects , all collaborating
together through GitHub, but the chilling effect of the per resource model was
quite real.

In both examples, I believe the pricing model encouraged bad user behavior and
ultimately may have damaged adoption of the product.

A number of companies I have interacted with recently have a per resource
model, and are either comfortable with, or blind to the adoption trade-off it
forces their customers through.


## Per user

The second common model I run into is the per user pricing model. Users for
many vendors indicates a "login" to the service, or a dedicated per-person
workspace. In some cases, user can be defined in rather confusing ways to try
to hedge adoption and price, such as "monthly active users" which then requires
the definition of "active" and "user!"

This is the current GitHub model, and in their implementation it makes quite a
bit of sense to me. In order to bring value to a new user in your organization,
you need to buy their ticket to the show. Makes sense. 

The specific price point per user is where most vendors get themselves into
trouble with this model. In the past I have been quoted per user prices
ranging between $50/user per month all the way up to thousands of dollars per
user, per month. Once a certain threshold is crossed, I will start to evaluate
whether each user accessing the system is going to get that much value from the
tool. If a user might only need to log into this system once a month for some
additional insight, or to deploy some particular thing, is that one monthly
possibility worth thousands of dollars? Probably not.

The resulting behavior I see from customers with this kind of model is that
they contort the organization around the tool's price gouging. Setting up a
single team account, restricting access to people within certain parts of the
org, or requiring budget approvals to head up to management to enable new
users.

This organizational yoga can be an especially acute problem for highly
specialized debugging or analysis tools. In the hands of our most senior
engineers they might prove to be worth their weight in gold. But at thousands
of dollars per user, I might be more reluctant to grant access to the more
junior developers who don't yet have the depth of knowledge to make effective
use of the tool.

Is it better to have one specialized team in the company adopting the product,
or would it be better if every team had access and saw the value of the given
service or software?




## Per Instance/Hour (Consumption)

My preferred model is the one adopted by all the major public cloud offerings:
time-based consumption billing. While not universally applicable, consumption
billing can be the easiest to understand. Your organization is going to use
some amount of storage/compute/etc resources provided by the vendor, with some
premium for the service overlaid on top of it. This obviously works much more
effectively with Software-as-a-Service providers, but can be harder to
implement.

Consumption-based billing makes it easy for customers to ramp up many different
users and teams on the product, and then only those who are actually using it
will incur costs. With a sane account structure in place, this model also makes
it much easier for finance offices to see where the costs, and in turn the
value, of any given tool is being realized.

For just about every vendor I'm alluding to in this post, consumption-based
billing is within their reach, but many seem to actively avoid it. My cynical
theory is because they want to pry as much money loose from their customers as
possible, and are less concerned about the organizational anti-patterns their
outmoded pricing models encourage.


---

Regardless of the pricing model chosen, if the value proposition is weak,
prospects are less likely to convert and existing customers are more likely to
push back against changes.  With some of the vendors I have interacted with in
recent years, it has taken willpower on my part not to laugh in their faces at
some of the outrageous prices I have heard. "You think this pile is worth _how
much?_" I personally have no objection to paying for software which
demonstrates its value. I have paid GitHub for their outstanding product for
years, and have actively encouraged the purchase of a number of other high
quality/high value products at employers as well. The flip-side is that I have
also encouraged cancelling of contracts which don't show enough value for
products which are poorly priced, poorly delivered, or poorly supported. The
vendors which survive are those who have made it easy to adopt, recognize the
value, and grow the adoption of their products inside an organization.
