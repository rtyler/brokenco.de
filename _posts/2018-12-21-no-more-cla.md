---
layout: post
title: "I'm not interested in your corporate Contributor License Agreements"
tags:
- opinion
- freesoftware
- opensource
---

What an interesting year it has been in the world of free and open source
software! Adoption is through the roof and the age old question of "how should
we fund this" has come back to the forefront. This year a number of companies
have introduced **non**-open source licenses, sometimes referred to as "source
available" licenses. To date I have not seen a single _major_ open source
project change licenses. Funded companies which have built ancillary tools and
projects around some major open source projects have switched to these
curiously un-open licenses. The big heartburn seems to stem from larger service
providers taking open source software, turning it into a product-as-a-service,
and making money off of that service. All of which is perfectly valid for the
use of open source software. The subject of licenses is not one I wish to
discuss in this blog post, but rather something which enables these sorts of
license shenanigans: the **contributor license agreement**.

A contributor license agreement is a contract typically made between a
contributor and the entity responsible for some body of work. The
[Jenkins project](https://jenkins.io/) uses a [Contributor License
Agreement](https://jenkins.io/project/governance/#cla) for core contributions.
Originally sourced from our umbrella organization, [Software in the Public
Interest](https://spi-inc.org) (SPI), the Jenkins CLA does the following:

* Asserts that the contributor has the appropriate rights over the work that
  they're contributing. As in, they're not attempting to contribute code which
  they do not own.
* Grants SPI copyright license, which helps should re-licensing or
  license-upgrades be required in the future.
* Grants SPI patent license, which helps deter patent trolls.


This is all _fine_. It is actually _good_. This helps Software in the Public
Interest, a 501c3 charitable organization chartered with fostering and growing
open source projects, make necessary changes and defend the Jenkins project
should the need arise.


On the other side of the coin are **for-profit companies** which operate open
source projects such as HashiCorp, Puppet, Chef, and a number of others, which
_also_ require Contributor License Agreemnts (CLAs). In every case which I have seen,
these corporate CLAs have identical terms as the Jenkins CLA, including the
copyright and patent license grants.

Granting copyright and patent license to a for-profit company, on work which
you have done voluntarily is **absolutely nuts**. This is free work, plain and
simple. There is no commitment from the for-profit that your changes will
remain open source, or even that the project to which you are contributing will
remain open source. The grant of copyright license gives the for-profit company
legal clearance to **close** or completely re-license the source. Unlike
Software in the Public Interest, or any one of the numerous other foundations,
a for-profit company will never have the fostering of open source communities
and projects mandated in its charter.

Absolutely nuts.

I struggle to even imagine of how this arrangement is at all beneficial to a
contributor. It just seems like free work, and personally I'm not one for
donating my time and efforts to somebody else's bottom line.

---

For my personal projects I have started to aggressively license my work as GPL
or AGPL, as my opinion of the MIT, Apache Software License, and BSD licenses
has soured over the past decade. The specifics of my reasoning I will save for
another article. My interest, and time-investment is to "the commons", the shared
ecosystem of freely given, and freely consumed software which raises us all up.

Should you find yourself with patches for a project which requires such an
aggressive abdication of your rights, I recommend maintaining a patchset, or
lightweight fork of the upstream repository, which thanks to GitHub is
_significantly_ easier than it once was.

I have absolutely no interest in working for free, or helping fragment and
confuse the free and open source ecosystem. CLAs for projects governed by a
transparent free and open source foundation make sense to me, and in a number
of ways can help safeguard the future of my contributions. Corporate ones
however cannot make any such guarantees.

