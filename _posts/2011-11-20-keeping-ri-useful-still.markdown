---
layout: post
title: Keeping ri useful, still
tags:
- ri
- ruby
- documentation
- rdoc
---

A couple months ago [I posted some tips](/2011/09/01/making-ri-useful.html) on
making the [ri](http://www.caliban.org/ruby/rubyguide.shtml#ri) a bit more
useful.

In the post I mention how installations of anything lower than Ruby 1.9.2 need
special treatment in order to make `ri` usable on a day-to-day basis.

For my side-projects, I've been using Ruby 1.9.2, so imagine my surprise when I
ran the following command:

    -> % ri Random
    Nothing known about Random
    -> %


In order to manage swapping between Ruby 1.8 for work and Ruby 1.9 for play,
I've been using the tool [rvm](https://rvm.beginrescueend.com/) to manage local
installations of multiple rubies.

As [bad] luck would have it, `rvm install ruby-1.9.2` by default doesn't
generate any of the standard library documentation, which will leave you with a
marginally useful `ri` as shown above.

The remedy for this is quite simple, re-run the installation command with the
`--docs` flag:

    -> % rvm install ruby-1.9.2 --docs
      ... # configuring
      ... # installing
      Attempting to generate ri documentation...
      Install of ruby-1.9.2-p290 - #complete 
    -> %

Ta-da! Proper local documentation for the standard library.

    -> % ri Random
    Random < Object

    # --- etc

    -> %

