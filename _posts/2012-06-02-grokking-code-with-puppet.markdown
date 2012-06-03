---
layout: post
title: Grok code with Puppet
tags:
- puppet
- opengrok
---


As the [Lookout](http://hackers.mylookout.com) code-base grows, both in
individual repositories but also in the sheer number of repos we maintain, I've
found it often difficult to find what I'm looking for.

Some of that difficulty is due to ActiveRecord's determination to implement the
world through meta-programming, but for everything else I'm turning to
[OpenGrok](http://www.opensolaris.org/os/project/opengrok/).


OpenGrok itself is a Java-based code cross reference and search engine, which
works surprisingly well with Ruby. While not perfect, it certainly blew
[LXR](http://lxr.sourceforge.net/en/index.shtml) away in both ease-of-use but
also cross-referencing of Ruby, Java, and C code.

Below is an example of searching for the `AWS` class in my
[Blimpy](https://github.com/rtyler/blimpy) project.

<center><img src="http://strongspace.com/rtyler/public/opengrok-defsearch.png" alt="Searching for Definitions in OpenGrok"/></center>


You'll notice in the search results that there is a green-colored annotation to
the right of the code snippet denoting the actual definitions compared to other
search results.

When I click on `aws.rb` and dive into the code itself, I can navigate based on
method definitions, but also pull in `git-annotate(1)` style annotations (not
pictured).

<center><img src="http://strongspace.com/rtyler/public/opengrok-methodnav.png" alt="Navigating code itself"/></center>


----

Since I'm no longer in the business of hand-crafting machines, I went ahead and
created [puppet-opengrok](https://github.com/rtyler/puppet-opengrok). This
OpenGrok Puppet module, while lacking in rspec-puppet tests (see
[@glarizza](https://twitter.com/glarizza), I'm a hypocrite), will allow you to
stand up a simple OpenGrok instance on an Ubuntu Server of your choosing.

Take the following manifest for example:

    node default {
      include opengrok

      opengrok::repo {
        "puppet" :
          git_url => 'git://github.com/puppetlabs/puppet.git';
      }
    }


The module will handle installing the packages `tomcat6`, `git-core` and a few
others to make things possible, but after you've run Puppet you can navigate
to: `http://yourhostname.lan:8080/source` and you'll find OpenGrok has indexed
the Puppet code base for you!

The module will also install a cronjob which updates the source trees and
indexes every 10 minutes.


Currently [puppet-opengrok](https://github.com/rtyler/puppet-opengrok) is quite
rough around the edges, since I used TDD (Tinker Driven Development) to build
it intead of TDD (Test Driven Development). It will most certainly work on
Ubuntu 10.04 LTS, but anywhere else your mileage may vary :)


If you're familliar with [Puppet Forge](http://forge.puppetlabs.com), you can
install the [rtyler-opengrok](http://forge.puppetlabs.com/rtyler/opengrok)
module with the `puppet-module` tool.
