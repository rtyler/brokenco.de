---
layout: post
title: Identi.ca is dead to me
tags:
- opinion
- identica
- microblogging
- twitter
---

There was a time when I was a big fan and user of open source microblogging
site [Identi.ca](http://identi.ca). I regret to inform you that this time has
passed and I can no longer in good conscience support the platform.


Identi.ca has always had issues, to be expected of an open source web property,
there are bound to some rough edges running around. Things took a turn for the
worse when the team decided to [perform a major
upgrade](http://status.net/2011/09/15/upgrading-identi-ca-and-other-statusnet-cloud-sites-to-1-0-0rc1)
which took the site offline for an entire weekend. The major upgrade in
mid-September introduced a number of issues:

* Entirely new UI which improved things in some areas (more AJAX) but
  introduced whole new UX flows, heavily padded rounded UI elements and new
  hiding places for elements (Groups) that I used to use heavily (why the
  christ would you put the Groups that I **admin** behind three clicks and not
  have them in the stupid sidebar? Idiocy).
* Took the XMPP bot offline for interacting with Identi.ca. This was often the
  *only* way I interacted with the site!
* [Data integrity
  issues](http://status.net/2011/10/28/big-loss-of-data-on-identi-ca)
* A [number](http://status.net/2011/12/20/identi-ca-down-update-not-any-more)
  of [stability
issues](http://status.net/2011/12/02/unscheduled-downtime-for-identi-ca) and
[bugs](http://status.net/2011/11/05/overview-of-technical-problems-with-identi-ca)


I would go on, but my mouth is already foaming at an unhealthy rate so I better
stop before I get kicked out of this coffee shop.

Anyways, it is of my opinion that the folks behind made a classic blunder: the
major re-write (joining Netscape 5, Perl 6, Python 3, and numerous other
over-promising projects that falter in the "real world"). Eschewing the
evolutionary approach to a project means large changes in data structure or
user experience can and will be made before anybody has seen them operate with
"real world" data and users.


I'm not sure where this leaves me with regards to using Identi.ca, I want to
like the site so badly but every tiem I've tried to use it in the past three
months I end up terribly frustrated.

----

*Extra bonus rant:* If you ever try to use the mobile site, you'll have a taste
of how silly Identi.ca can be sometimes. If the site doesn't detect that your
browser is mobile (which happens on every device for me), then you have to load
the full non-mobile home page, at the bottom of which is a "Switch to mobile
desktop layout" link. The link doesn't have an href, it uses **fucking
JavaScript**, clicking this link will reload the page with a special
mobile cookie set. There is no `m.identi.ca` site at all.

To use Identi.ca from a mobile browser: your browser must run JavaScripts, you
must load the full non-mobile document, click that link, set the cookie then
hope that your browser keeps that cookie around forever.

Uh oh, my mouth is foaming up again, better stop here.
