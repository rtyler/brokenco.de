---
layout: post
title: Introducing Blimpy, a cloud thing
tags:
- blimpy
- puppet
- devops
---


**DEATH TO VIRTUALBOX**

---

Phew, okay. With that out of the way, let me tell you about
[Blimpy](https://github.com/rtyler/blimpy#readme); a tool that I have written
to make working with "cloud" machines easy as pie.

<img src="http://strongspace.com/rtyler/public/excelsior.png" align="right"
title="Uh, hello? Airplanes? It's Blimps, you win."/>

As much as I love my Thinkpad, it's not really suited to heavy virtualization.
Despite having a delightful 8GB handy, it still only has a couple of teeny tiny
CPU cores. What it *does* have though, is a nice internet connection to the
CLOUD.

Blimpy was built to help me take advantage of the plethora of machines that can
be spun up on [AWS](http://aws.amazon.com) and other public cloud providers.

My immediate usecase for Blimpy is that I've needed to spin up a machines
rapidly to perform end-to-end testing of
[Puppet](http://puppetlabs.com/puppet/puppet-open-source/) modules such as
[puppet-jenkins](https://github.com/rtyler/puppet-jenkins)


Below is a screencast of using Blimpy to validate the module:

<center><iframe width="640" height="480"
src="https://www.youtube-nocookie.com/embed/ub8V_TbYEE8?rel=0" frameborder="0"
allowfullscreen></iframe></center>

This was done with a simple Blimpfile:

     Blimpy.fleet do |fleet|
       fleet.add(:aws) do |ship|
         ship.name = 'puppet-jenkins'
         ship.ports = [22, 8080]
         ship.livery = :cwd
         ship.flavor = 'm1.large'
       end
     end

Blimpy is structured to make it easy to spin up multiple machines at once, in
this case however I'm only going to spin up a single machine (defaulted to
Ubuntu 10.04 64-bit in US West 2), of the "m1.large" flavor. Jenkins is a
hungry application, so I'm not going to use the default "t1.micro" flavor.

The `Blimpfile` also specifies that port 8080 should be opened, and will create
a special Blimpy security group in AWS that properly allows ports 22 and 8080
through.


The project is still fairly young, but reasonably well tested (in my opinion)
Ruby code, all of which can [be found on
GitHub](https://github.com/rtyler/blimpy#readme)
