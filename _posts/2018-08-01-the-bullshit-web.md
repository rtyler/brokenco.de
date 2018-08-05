---
layout: post
title: Coping with The Bullshit Web
tags:
- opinion
---

I recently came across [this post](https://pxlnv.com/blog/bullshit-web/) from
Nick Heer castigating "the bullshit web." A term he uses to describe the fairly
despicable state of modern web applications. While I overwhelmingly agree with
the points he lays out, especially in his disparaging remarks towards
[AMP](https://www.ampproject.org/), I think there's more to be said about
alternative approaches for web users to once again experience the web without the
bullshit.

My personal computing setup is a bit towards the extreme, so I understand that
most people will not utilize the approaches I favor, but I will list them here
nonetheless.

* **Navigating to mobile sites by default**: one easy trick which I've utilized
  on a number of international data connections is to default to using a web
  site's mobile version, even though I'm on laptop (heresy!). A number of sites,
  excluding news sites, become much more pleasant for mobile users due to the
  constraints on CPU and network most mobile devices have.
* [NoScript](https://noscript.net): I have used NoScript, and it's Chrome
  analogue
  [ScriptSafe](https://chrome.google.com/webstore/detail/scriptsafe/oiigbmnaadbkfbmpbfijlflahbdbdgdf),
  for quite some time to block enormous amounts of JavaScript being loaded by
  various pages. This is a very big hammer to wield against the bullshit web,
  which makes it extremely effective but it requires a bit of understanding about
  what domains contain adware or surveillance scripts versus those which are
  simply part of the web application, despite being served from another domain.
  Special dishonorable mention here to all the CloudFront users whose CDN domains
  are completely opaque and impossible to determine whether they're serving
  legitimate application code or adware.
* [Tor Browser](https://www.torproject.org/projects/torbrowser.html.en): one
  aspect of the bullshit web which I find particularly obnoxious is the
  tracking, especially done on an IP basis. I've seen numerous people complain
  in forums, and even within my own family, that "something creepy" was going on
  when they saw an ad on an unrelated website for something they referenced in a
  Facebook post, or had Googled. While NoScript by itself does an admirable job
  preventing surveillance by tracker/beacon scripts, many larger web companies
  will track you based on the browsr's fingerprint or your IP address. The Tor
  Browser utilizes the Tor network to provide an anonymization layer upon which I
  rely **heavily**. A non-trivial amount of my every day web traffic is routed
  over the Tor network, further helping me opt out of the bullshit web.
* `w3m`: as I mentioned in my blog post last year [In Defense of Being a
  Console Luddite](/2017/02/10/being-a-console-luddite.html), you would be
  surprised how much faster everything gets when you cut the web down to it's
  most basic, content-centric, components. While only a small percentage of my
  traffic ends up going through the `w3m` text-based browser, I find it quite
  useful for quickly getting answers without ever leaving my terminal (where I'm
  typically working anyways).


Most of these approaches are good for the web-as-a-document-centric-universe,
but perform much more poorly with the web-as-an-application-platform. For many
web applications there is simply no practical way around a heavy browser-based
experience (e.g. Confluence, Jira, Slack). For these applications I don't have
much advice except to "vote with your wallet", or as is the case for many
people, advocate internally for better tools which are lighter weight or
support alternative nad more native interfaces.


Regardless of how you accomplish it, I hope you'll echo Nick's closing rally
cry:

**Death to the bullshit web**.
