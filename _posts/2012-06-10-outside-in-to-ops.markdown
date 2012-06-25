---
layout: post
title: Outside-in for Operations
tags:
- bdd
- cucumber
- ops
---

**Update**: I've posted the [update to this post
here](/2012/06/19/outside-in-to-ops-with-code.html) which contains some code
and more fully fleshed out ideas

---

I have been thinking a lot about "outside-in" developement for operations as of
late, primarily focusing on how [Cucumber](http://cukes.info) might fit into
the equation.

[cucumber-puppet](http://blog.nistu.de/2012/06/09/cucumber-puppet-end-of-life/)
reached its "end-of-life" recently as the developer can no longer provide the
tender love and code (TLC) that the project requires. I don't particularly like
the way cucumber-puppet works but at the same time, I've been faced with more
and more questions about how to bridge into, or out of,
[rspec-puppet](http://rspec-puppet.com/).

As a development tool rspec-puppet is quite handy, but at the end of the day,
Puppet manifests should be run in an actual Puppet environment on real or
virtualized hardware before they get shipped off to the production site.

What does that look like?

Before you answer that, I think it is important to answer "who are the
stake-holders?" for the work that operations is doing?

### Developers as Stake Holders

Let's say I'm developing an application called "PentaGram", this is a simple
Rails application that will help Satan worshippers upload evil photos and share
them with their fellow demonic friends.

To host PentaGram, I'm going to need a web server, an Oracle database (this
application is evil, after all) and memcached. I think for now I'll just break
up my Cucumber `.feature` files into machine types (web, db, cache).

For this post, i'll focus on `featurees/apphost.feature`:

    Feature: Serve the PentaGram web application
      In order to serve up the PentaGram to millions of devil worshippers
      As a developer
      Web hosts should be configured to run the application

I think this makes sense as an 'introduction' to the feature, I need web hosts
to serve my web application.

    Feature: Serve the PentaGram web application
      ...

      Scenario: Provision a fresh web host
        Given an empty host
        And the host is of type "pentagram-app"
        When I provision the host
        Then it should be running a web server
        And it should be responding to web requests


Alright, I'm not supremeley thrilled with this approach, one such example is
that "pentagram-app" is a Puppet module, and I'm not very comfortable with that
leaky of an abstraction. So I'm going to reword it to: `And the host is a
PentaGram app host` and start to define a vocabulary between my stake-holders
instead of letting Puppet module names leak upwards into Cucumber.

The more I think about it, I'm not sure "developers" or even product-owners are the stake
holders to address with these features. As a developer, I care very little
about the operational details, so long as PentaGram works!

Operations is its own compelling stake-holder, but that presents a complication
of making "outside-in" features such as these too leaky in terms of
abstractions and not very descriptive.

### Operations as Stake Holders

That web host you provisioned above is nice and fancy and all that, but as far as I
am concerned (being a fellow Ops engineer), there's a lot more to an app host
than just running the web server.

    Feature: Serve the PentaGram web application
      ...

      Scenario: Add app hosts into the load balancer
        Given a load balancer with a pool for app hosts
        And an empty PentaGram app host
        When I provision the host
        Then it should be added to the load balancer
        And it should be receiving requests from the load balancer

I'm reasonably pleased with this, I'm going to pretend writing all these step
definitions is going to be rather easy to write, and forge ahead writing out
more Scenarios.

      Scenario: Create the appropriate firewall rules
        Given an empty PengtaGram app host
        When I provision the host
        Then traffic should be allowed to port 80
        And traffic should be allowed to port 443

      Scenario: Nagios checks for app hosts
        Given a Nagios server
        And an empty PentaGram app host
        When I provision the host
        Then Nagios HTTP checks should be added for the host
        And Nagios HTTPs checks should be added for the host

---

At this point I've not written any step definitions or Ruby code to run these
Cucumber features, but I *think* this enumerates what I want out of a PentaGram
app host.

I know the following things are needed for an app host, just by reading
`apphost.feature`:

* A web server should be running (but how do we know it's not "It Works!"
  coming from Apache instead of the PentaGram app?)
* The app host should be added to the load balancer's app-host pool when it is
  provisioned
* The app host should port 80 and 443 open, ostensibly because Apache is
  listening on those ports (we didn't say that it should be though! should we?)
* When the app host comes online, it should have Nagios checks added for its
  service running on port 80 and port 443 (again, this doesn't verify the
  PentaGram app is actually running there).

---

I am not sure if this is the best approach, or even an approach that doesn't
suck, this entire blog post has been me riffing on what outside-in might look
like for Operations.

In my next post on the subject, I should have some example code available with
fleshed out step definitions and some valid/passing scenarios.


