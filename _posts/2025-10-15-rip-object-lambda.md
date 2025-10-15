---
layout: post
title: "R.I.P. S3 Object Lmabda"
tags:
- aws
---


Did you know that AWS S3 is almost 20 years old? The "cloud" as a concept is
fairly _recent_ but in the time-distortion that has occurred since the rise of
the internet, I think many of us have lost track of how _old_ some of these
public cloud providers are, and as a side-effect, how old their technology
offerings can become. Periodically you need to clean out the attic, and this week AWS did just that with their 
"[AWS Service Availability Updates](https://aws.amazon.com/about-aws/whats-new/2025/10/aws-service-availability/)."


In the list of services that probably have fewer users than most YC startups,
was one which I had recently found _incredibly useful_: **S3 Object Lambda**.


From Corey of [Last Week in AWS](https://www.lastweekinaws.com/) infamy:

> S3 Object Lambdas have always been a bit weird. You can still have Lambdas
> operate on S3, and at least actual Lambdas are likely to see service
> improvements; Object Lambdas have been moribund for years.


Object Lambda is admittedly a _niche_ product. But what makes it quite
interesting for my purposes is it allows you to modify S3 requests en route. It
is by far the fastest way to add custom business logic around data stored in S3
while preserving S3's API and semantics.

For example, you can create a _completely fabricated_ key space with S3 Object
Lambda that represents a _logical_ object layout, even if your physical object
layout, the actual bytes stored in S3, does not match.

As _handy_ as I think S3 Object Lambda is, when I spoke with some folks
responsible for S3 Object Lambda at AWS earlier this year, it became clear that
there was no further investment in the feature. To me the writing was on the
wall that AWS was going to kill the feature _eventually_, so I proactively
shifted any work where it was present.


S3 Object Lambda now joins the graveyard next to [S3
Select](https://docs.aws.amazon.com/AmazonS3/latest/userguide/selecting-content-from-objects.html)
and closes the book on "what if S3 were a data application platform." Instead
AWS continues to push vectors, vectors, VECTORS! Pivoting towards "what if S3
were an AI platform?".
