---
layout: post
title: Pulling Jenkins' strings with Puppet
tags:
- jenkins
- puppet
---

A couple months ago I created this
[puppet-jenkins](https://github.com/rtyler/puppet-jenkins) module while
experimenting with using Puppet to script or otherwise control more and more of
my daily sysadmin-life.

After a weekend of hacking I figured I was mostly finished, that was until Puppet Labs
engineer [Jeff McCune](https://github.com/jeffmccune) picked up the module and
added a number of rspec tests, CentOS/RHEL support and generally tidied up the
place. Pretty neat I thought!

Once again through the power of GitHub a weekend project has taken a life of
its own now that multiple people are interested in the concept and have
[forked the repo](https://github.com/rtyler/puppet-jenkins/network/members)
accordingly.

With the encouragement of a number of people, I've also [published
the module to Puppet Forge](http://forge.puppetlabs.com/rtyler/jenkins) which
allows for easy integration with thousands of Puppet installations.

If you'd like to use the Jenkins puppet module from Puppet Forge, you can use:

    % -> puppet-module install rtyler-jenkins

Once the module is included you can slurp in the Jenkins module with this in
your manifests:

    class { 'jenkins': ; }  # logically equivalent to "include jenkins"

You can also use the module to handle plugin installation for you with the
`install-jenkins-plugin` type:

    install-jenkins-plugin {
        "git-plugin" :
            name    => "git,
            version => "1.1.11";
    }

(Omit the "version" if you just want to pull the latest)

If you're interested in contributing, the [GitHub project is
here](https://github.com/rtyler/puppet-jenkins).


Add this to the ever increasing list of projects that were planted on GitHub
and flourished afterward.
