---
layout: post
title: "Hub board: Call for testers"
tags:
- resin
- amber
- github
- hubboard
---

I've been working on [Hub board](https://hubboard.herokuapp.com) off and on for
the past couple months, and I finally think it's ready for some more broad beta
testing.


Hub board itself is meant to be a more visual Kan-ban style board built on top
of GitHub Issues. There are three states for issues "Open / Assigned", "In
Progress" and "Closed." By default Hub board will not show you any issues that
are not assigned to you; unfortunately there is not a means to assign existing
issues to yourself through Hub board [issue #52](https://github.com/rtyler/Hubboard/issues/52)).


<center><a href="https://hubboard.herokuapp.com/intro" target="_blank"><img src="http://strongspace.com/rtyler/public/hubboard-2012-05-27.png" alt="Hub board yay"/></a></center>

Please visit the [intro page](https://hubboard.herokuapp.com/intro) to learn
more, and file [issues on GitHub](https://github.com/rtyler/Hubboard/issues).


---

For the curious, Hub board is built with [Amber
Smalltalk](http://amber-lang.net/) a JavaScript implementation of the Smalltalk
language and runtime. It is also built and deployed with the
[Resin](https://github.com/rtyler/resin) which embeds Amber and couples it with
a simple Sinatra web server to make developing Amber applications exceptionally
easy.


