--- 
layout: post
title: Awesomely Bad
tags: 
- opinion
- miscellaneous
- linux
created: 1248580338
---
A coworker of mine, [@teepark](http://twitter.com/teepark) and I recently 
fell in love with tiling window managers, <a id="aptureLink_cBdTGh5mhu" href="http://en.wikipedia.org/wiki/Awesome%20%28window%20manager%29">Awesome</a>
in particular. The project has been interesting to follow, to say the least. When I 
first installed Awesome, from the [openSUSE package directory](http://software.opensuse.org/search),
I had version 2, it was fairly basic, relatively easy to configure and enough to hook
me on the idea of a tiling window manager. After conferring with [@teepark](http://twitter.com/teepark), 
I discovered that he had **version 3** which was much better, had some new fancy features, and
an incremented version number, therefore I required it.

In general, I'm a fairly competent open-source contributor and user. <a id="aptureLink_JtLnexfCQX" href="http://en.wikipedia.org/wiki/Autoconf">Autoconf</a> and <a id="aptureLink_tFM3XdzbUg" href="http://en.wikipedia.org/wiki/Automake">Automake,</a> while I
despise them, aren't mean and scary to me and I'm able to work with them to fit my needs. 
I run Linux on two laptops, and a few 
workstations, not to mention the myriad of servers I'm either directly or peripherally responsible 
for. I grok open sources. Thusly, I was not put off by the idea of grabbing the latest "*stable*" tarball 
of Awesome to build and install it. That began my slow and painful journey to get this software built, 
and installed.

* Oh, it needs <a id="aptureLink_7epjSjKClG" href="http://en.wikipedia.org/wiki/Lua%20programming%20language">Lua</a>, I'll install that from the repositories.
* Hm, what's this [xcb](http://xcb.freedesktop.org/) I need, and isn't in the repositories. I guess I'll have to build that myself, oh but wait, there's different subsets of xcb? xcb-util, xcb-proto, libxcb-xlib, xcb-kitchensink, etc.
* Well, I need [xproto](http://xorg.freedesktop.org/archive/individual/proto/) as well, which isn't in the repositories either.
* CMake? Really guys? Fine.
* ImLib2, I've never even heard of that!
* libstartup-notification huh? Fine, i'll build this too.

After compiling what felt like an eternity of subpackages, I discovered a number of *interesting* 
things about the varying versions of Awesome v3. The configuration file format has changed a few 
times, even between one release candidate to another. I ran across issues that [other people had](http://spiralofhope.wordpress.com/2009/04/14/awesome-window-manager-installation-misadventure/) 
that effectively require recompilling X11's libraries to link against the newly built xcb libraries 
in order to work  (`/usr/lib/libxcb-xlib.so.0: undefined reference to _xcb_unlock_io`). Nothing I 
seemed to try worked as I might expect, if I couldn't recompile the majority of my system to be 
"bleeding edge" I was screwed. The entire affair was absolutely infuriating.

There were a few major things that I think the team behind Awesome failed miserably at accomplishing, 
that every open source developer should consider when releasing software:

* **If you depend on a hodge-podge of libraries, don't make your dependency on the bleeding edge of each package**
* **Maintain an open dialogue with those that package your software, don't try to make their job hell.**
* **When a user cannot build your packages with the latest stable versions of their distribution without almost rebuilding their entire system, perhaps you're "doin' it wrong"**
* **Changing file formats, or anything major between two release candidates is idiocy.**
* **If you don't actually care about your users, be sure to state it clearly, so then we don't bother using or trying to improve your poor quality software**


In the end, I decided that <a id="aptureLink_9yLUGUwEJ0" href="http://en.wikipedia.org/wiki/Haskell%20%28programming%20language%29">Haskell</a> isn't scary enough not to install <a id="aptureLink_IqW50ui9RW" href="http://en.wikipedia.org/wiki/Xmonad">XMonad</a>, so 
I've started replacing machines that run Awesome, with XMonad, and I'm not looking back. Ever.

