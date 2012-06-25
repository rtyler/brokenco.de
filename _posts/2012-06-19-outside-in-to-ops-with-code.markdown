---
layout: post
title: Outside-in for Ops, with code!
tags:
- bdd
- cucumber
- ops
- blimpy
---

Last week [I discussed](/2012/06/10/outside-in-to-ops.html) some ideas about
how to apply some
[BDD](http://en.wikipedia.org/wiki/Behavior_Driven_Development) concepts to
operations, primarily the "outside-in" approach.


Over the course of the past couple days, I've been experimenting with some
ideas with my "[PentaGram](https://github.com/rtyler/pentagram)" project, and I
think I've made enough progress to write a follow-up blog post.

It's worth mentioning now that [the
commits](https://github.com/rtyler/pentagram/commits/) to the repository have a
lot of commentary in the commit messages and are meant to help guide you along
step-by-step.

I do recommend opening the linked commit messages in a separate window and
check them out as you follow along at home.

---


In order to best emulate a true outside-in workflow, I started with [this
commit](https://github.com/rtyler/pentagram/commit/c307db4cfb3b9aec83b401ea14b6dd3f3f783ca2)
which really just added the `apphost.feature` file mentioned in the previous
post:

    Feature: Serve the PentaGram web application
      In order to serve up PentaGram (and satanic phots)
      to millions of devil worshippers

      As an operations engineer

      App hosts should be configured to run the PentaGram
      web application

As you might expect, this by itself is pretty useless so I wrote out the
first scenario and [committed that
too.](https://github.com/rtyler/pentagram/commit/940541c01d84e9f042d0c2303bc9d175bac89c7e)

I should mention now that between just about every commit, and at every step of
the way I was both running Cucumber and RSpec.


In order to realistically test the Puppet code underlying the entirety of the
`apphost.feature`, I needed to spin machines up and down rapidly, so I
integrated another one of my projects:
[Blimpy](/2012/05/21/introducing-blimpy.html). Since this was very
experimental, the majority of my first few hours of work on PentaGram was
consumed making the first couple steps in the scenario work:

    Scenario: Provision a fresh app host
      Given an empty host
      And the host is to become a PentaGram app host
      When I provision the host


[This
commit](https://github.com/rtyler/pentagram/commit/2a323e55345c4b117c318c86242f84787d6a4cb1)
concluded the work on just spinning machines up and down, and marked the
turning point. After this commit I could dig *deeper* into actually writing
[rspec-puppet](http://rspec-puppet.com) tests and _real_ Puppet code.

At this point I was ready to start driving the code necessary make the "When I
provision the host" step run correctly. This required me to do a couple things:

* Define a "pentagram-web" module
* Set up the whole module structure inside of the pentagram repo

Unfortunately as you can see
[here](https://github.com/rtyler/pentagram/commit/47386fdd8270294cbcdff609f07663db77532374)
getting rspec-puppet up and running properly can be a little bit of work. I
found out as I started to look at pulling in third party modules to manage
things such as Apache, that I needed to create symlinks for them inside my
"pentagram-web" module in order for rspec-puppet to find them properly.

With the dependencies properly being loaded, I could pull in the Ruby, Apache
and Passenger modules with these commits:
[apache](https://github.com/rtyler/pentagram/commit/47386fdd8270294cbcdff609f07663db77532374),
[ruby](https://github.com/rtyler/pentagram/commit/a2f35833adb91dc2bf5181d0b507fd2b126cf779),
[passenger](https://github.com/rtyler/pentagram/commit/5f02821ee8054606dd5b8241e54a956af392c3d1).

With these dependencies being pulled into my "pentagram-web" module, I felt
ready to step back **out** into Cucumber land.

What I found out when I ran the Cucumber scenario again, and actually
provisioned the machine, was that the Passenger module required some more
dependencies to be installed! Sure, I could have found this out by actually
reading the full documentation on the Passenger module, but who has time for
that these days? I addressed this in [this
commit](https://github.com/rtyler/pentagram/commit/5367271c145d4e495b264efb06f3c1a7ecf547cb),
which was a good reminder that it doesn't matter how good your RSpec is,
there's nothing quite like *actually running your code*.


Once everything was provisioning "mostly" properly, I was left to jump back
"out" to Cucumber and implement the last two step definitions:

    Then it should be running a web server
    And it should be responding to web requests

I thought about how best to implement this, and decided on the most simple
solution (in my opinion): ssh into the box and look! The reason I went for this
approach was to keep things simple, I could have made web requests to the
machine, but I wanted to focus on the bare minimum needed to pass the test. For
the first step I executed "`pgrep httpd`" and made sure it returned a zero exit
code. For the second step, I invoked `curl` against `localhost` and made sure
that it could connect properly.

What I found out when I implemented these two steps was that...I actually was
**failing my Cucumber!** In another great example of there being no substitute
for running the code, I discovered an unspecified dependency in the Puppet
resource graph between the Passenger module and Apache, which was fixed [in
this
commit](https://github.com/rtyler/pentagram/commit/5f07a8dfb7662604184994e7422bdcd209c36ea5).
Even though Puppet was provisioning the host correctly, it was failing to
correctly start Apache, and thus failed the scenario!


### Lessons Learned

The most important lesson I learned in this exercise was that you *must*
execute your Puppet against a real machine before going to production.
Correctly parsing Puppet, passing
[puppet-lint](https://github.com/rodjek/puppet-lint) and
[rspec-puppet](http://rspec-puppet.com) checks is **not** enough, it must
execute on a machine or else you're really just guessing that it will work in
production.


A couple weeks ago when I wrote [about Puppetizing
OpenGrok](/2012/06/02/grokking-code-with-puppet.html) I mentioned using "Tinker
Driven Development." At the time I really didn't know anything about OpenGrok
or how I would manage it with Puppet. I am more convinced now that if I had
taken an "outside-in" appraoch with the
[puppet-opengrok](https://github.com/rtyler/puppet-opengrok) module, I would
have been able to actually use Behavior/Test Driven Development. Even though I
really didn't know anything about how OpenGrok worked, I knew what behavior I
wanted from the system.


**Provisioning isn't the end.** In my previous post, I talked about "Operations as
a stake-holder" which for this level of "outside-in" I think is fine, but in
the end, Operations is a part of a greater organization. Even though the
code implemented thus far provisons an app host which has *effectively*
everything it needs to run PentaGram, it's not actually *running* PentaGram.
From the "business perspective" I still haven't done anything! There's no
PentaGram app running, there's no deployment happening, we're still not
satisfying our users' need to post daemonic photos! I'm sure this can be
fleshed out in additional scenarios that could be addressed after I met the
needs of the Operations group.


It's clearer to me now where outside-in for Operations fits in the overall
scheme of things. I can very easily imagine sitting down with an Operations
Manager and discussing what needs to be done to "make PentaGram production
ready" and in doing so, writing out the features and scenarios mentioned in the
[previous post](/2012/06/10/outside-in-to-ops.html).


There's still some tooling work that I think needs to be done to make this
easier, but I'm optimistic about the future of behavior-driven operations!

