---
layout: post
title: Adios Drupal
tags:
- drupal
- opinion
- jekyll
---

If you've seen a recent flood of backlogged blog posts of mine in your feed
reader then I sincerely apologize. I finally pulled the trigger on switching
from [Drupal](http://www.drupal.org), the fantastic CMS, to
[Jekyll](https://github.com/mojombo/jekyll/wiki), a fantastic site generator.

For a rather long time I've been pining to write my blog posts in nothing but
[Markdown](http://en.wikipedia.org/wiki/Markdown) and [Vim](http://www.vim.org)
and with Jekyll I can finally do that. I can also use
[Git](http://www.git-scm.org) to properly manage the content for the blog,
meaning I just about *everything* I do now resides in Git.


Migrating from Drupal was easy enough but I did need to modify [this
script](https://github.com/rtyler/unethicalblogger.com/blob/master/drupal.rb) a
bit in order to properly pull out:

* taxonomy (i.e. tags)
* path alias

Overall, I'm very pleased with the transition. I spent far more time tweeking
the look and feel rather than actually doing work (that's how it usually is
with these things). Here's hoping it gets me blogging more!
