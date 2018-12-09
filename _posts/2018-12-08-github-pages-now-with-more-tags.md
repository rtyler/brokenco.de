---
layout: post
title: "Jekyll and tags on GitHub Pages"
tags:
- github
---


For the last little while I have been hosting this blog on GitHub Pages,
generated using [Jekyll](http://jekyllrb.com). All that is well and good except
GitHub Pages doesn't properly support the `jekyll-tagging` plugin. Therefore
tags on this site have been broken since the migration, until I found ]this
blog post](http://longqian.me/2017/02/09/github-jekyll-tag/) by [Long
Qian](http://longqian.me/).

THe approach is rather simple and relies on pre-generating tag pages ahead of
time, then committing those into the source repository. It requires a little
extra in the way of a local `pre-commit` hook.

With tags fixed, here are some interesting tags which might be worth perusing:


* [alc](/tag/alc.html) - AIDS/LifeCycle 2019 training and fundraising blog
  posts
* [javascript](/tag/javascript.html) - various tips and tricks from my
  server-side work with JavaScript.
* [cicd](/tag/cicd.html) and [jenkins](/tag/jenkins.html) cover much of my
  thoughts and work revolving around continuous delivery and Jenkins.













