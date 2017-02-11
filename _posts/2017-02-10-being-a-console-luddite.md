---
layout: post
title: "In Defense of Being a Console Luddite"
tags:
- opinion
---

Most people would consider me to be a nerd. I work in the tech industry, my
laptop looks quite non-standard (a stickered Thinkpad), and I tend to travel
with suitable amount of electronic kit. Within what I would call "the nerd
community," I sometimes get looks as if I'm _especially_ nerdy. I use a tiling
window manager on my Linux desktop, I have strong opinions on free and open
source software, and above all else, I use a myriad of "super nerdy"
console-only applications like mutt and irssi.

Presently I find myself delayed in a foreign airport with a "hostile wifi
situation." That is to say that while technically there is wifi, one must
surrender their information to a captive portal which will no doubt result in a
plethora of new spam, all for a meager allotment of usage time. Instead I am
passing the time, with my Android phone acting as my wireless hotspot, over my
"unlimited" 2G data.

You really haven't experienced the bloat of the internet in 2017 until you have
attempted to be productive over a 2G link, with bonus latency between the
European and American continents. Even websites I would have assumed were
fairly simple, looking at you `reddit.com`, download excessive amounts of data
between loading pages and client/server background-chatter.

As a console luddite however, things aren't so bad! The benefit of
console-based applications is that they tend to be *much* lighter, not only in
CPU and memory consumption, but also in network utilization. The difference
between `irssi` and IRC Cloud, for example, is staggering. With `mutt`, my mail
client of course, I am only downloading the emails themselves rather than the
entire interface around the emails like with a web mail client. Even for
content which only lives at the other end of an HTTP connection, using the
console-based browser `w3m` results in much lighter page loads and zero
on-going data consumption after the page has loaded.

I don't advocate going to 100% console-based applications however. Chrome, with
the Vimium extension, is one of my most heavily used applications. But there
are certainly some benefits to maintaining familiarity with console-based
applications today. 

### Recommendations

Below are some recommendations I can make for resource-thrifty console-based
tools.

* `w3m` - For most basic browsing while on low-bandwidth connections. I also
  find the `-dump` option to be very useful when inside of `tmux` for dumping
  HTML-based test reports or other locally generated HTML files. For most
  websites, their mobile versions render quite nice in `w3m`.
* `mutt` - As my primary email client, mutt allows me to speedily navigate
  around email via its stellar key bindings, but perhaps most importantly, it
  allows me to use `vim` for authoring my emails.
* `irssi` - For IRC (and also [Gitter](https://irc.gitter.im)) chat; very
  important for actively participating in most free and open source projects.
* `newsbeuter` - I am apparently one of the few remaining humans who uses
  RSS/Atom feeds for consuming content. As a console-based news reader, I find
 `newsbeuter` to be very user-friendly.


All of these applications have the added benefit of being primarily
keyboard-driven, giving them a higher learning curve, but once the basics are
mastered it's quite easy to rapidly context-switch within and between them. A
number of console-based tools are also easily incorporated into other scripts.
`w3m` for example is referenced in a few task-specific scripts I keep floating
around in `~/bin`.


---

There are downsides to frequently using console-based applications. Other nerds
will look down their nose at you whilst complaining about Slack, Firefox, or
Chrome consuming heaps of heap. Strangers will come up to you and ask you silly
questions like "how do you READ all that!?" And of course, the more comfortable
you get with console-based tools, custom scripts, and all the other things you
start to use because they make you work faster, the harder it will be for you
to ever use a "normal desktop" again.

You may end up being a console luddite like me, but at least you'll be
efficient and productive regardless of the situation you find yourself in.
