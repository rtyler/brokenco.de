---
layout: post
title: Making ri useful
tags:
- ruby
- documentation
- ri
- rdoc
---


When I joined [Lookout](http://www.mylookout.com) I made the transition from
long-time Python developer, to Ruby noob. It wasn't a terrifically painful
transition since the two languages are more alike than they are different, and
I got assigned to a C project shortly after arriving.

One thing that had always bothered me, but not enough to fix it (since I was
mostly working with C), was how **obscenely** frustrating it was to find
documentation for methods/classes/modules/etc. Being habitual user of the
Python [REPL](https://secure.wikimedia.org/wikipedia/en/wiki/REPL) and its
built in `help()` function, I was thrashing around like a sea turtle caught in
a fishing net.

Earlier this week, after deciding that I *had* to fix this (lest I shoot
myself), I noticed that somehow, someway, one of my
[RVM](https://rvm.beginrescueend.com/) gemsets gave me ***useful*** output from
the tool `ri`. I had become accustomed to `ri` not giving me useful information
unless I had the *full* name of a class or method, e.g.:

    -> % ri assert_raise
    Nothing known about .assert_raise
    -> %

Rubyists will recognize assert\_raise as a method involved in the `Test::Unit`
module (specifically it's mixed-in from `Test::Unit::Assertions`, which is
another bucket of frustration for me), but up until recently my method of
"documentation method resolution" had been to open a browser, pass a query to
Google and pray that the method name wasn't too vague.

As it turns out, this is **not** the proper behavior for `ri`, something a Ruby
novice like myself simply didn't know. In order to make `ri` useful, at least
in versions under 1.9.2, you must install the `rdoc-data` gem **and** run a
subsequent command:

    -> % gem install rdoc rdoc-data
    -> % rdoc-data --install

Having that gem installed, and having run `rdoc-data --install` all of a sudden
turns that same `ri` command above into this:


    -> % ri assert_raise

    = .assert_raise

    (from ruby core)
    === Implementation from Test::Unit::Assertions
    ------------------------------------------------------------------------------
    assert_raise(*args) { || ... }

    ------------------------------------------------------------------------------

    Passes if the block raises one of the given exceptions.

    Example:
        assert_raise RuntimeError, LoadError do
            raise 'Boom!!!'
        end

    -> %


All of a sudden, `<Shift>-k` when the cursor is over a symbol in Vim does
something *useful*, all of a sudden I don't feel so completely and utterly lost
when dealing with Ruby code, especially with methods being included from third
party gems.


All of a sudden, I got *really* pissed that `ri` never informed me that I was
operating in a completely dysfunctional state.

If nobody ever tells me that something is broken, how will I ever know to fix
it?

