---
layout: post
title: Introducing the Vagrant plugin for Jenkins
tags:
- vagrant
- jenkinsci
- ruby
---

The impossible has happened. Not only have I written a plugin for Jenkins, I've
*released* it. An event I've long avoided has finally come to pass, mostly
thanks to the fantastic [Ruby plugin development
support](https://wiki.jenkins-ci.org/display/JENKINS/Jenkins+plugin+development+in+Ruby)
developed largley by [Charles Lowell](https://github.com/cowboyd).

<center><img
src="http://agentdero.cachefly.net/scratch/vagrant-plugin-0.0.3.png"
alt="Vagrant plugin"/></center>


The Vagrant plugin is still fairly new, and "beta" tested. Thus far I've
modeled it after the fantastic [Android Emulator
plugin](https://wiki.jenkins-ci.org/display/JENKINS/Android+Emulator+Plugin) in
that it will bring up a Vagrant VM for the duration of the job, and then
destroy it afterwards.

As you can see, the Vagrant plugin adds a couple new build steps to the
configure page. One thing to note is that the
[provisioning](http://vagrantup.com/docs/provisioners.html) is operated as a
separate step, instead of bundled in with the boot of the Vagrant machine. This
is purposeful, to allow any additional set up of the environment prior to
running Puppet or Chef.


The plugin does of course expect that you have a functional VirtualBox
environment on the slave you're running the job on, if you don't, Vagrant will
explode with a fantastic stack-trace and probably burn your house down.

#### In the near future

I'm thinking about bundling
[vagrant-snap](https://github.com/t9md/vagrant-snap) with the plugin to allow
fancy snapshotting support, but I'm not sure of a good definite usecase for
that just yet.

If there's anything you'd like to see, please file a request on the [GitHub
issues page](https://github.com/rtyler/vagrant-plugin/issues).

----

You can find the plugin:

* in your Jenkins "Manage Plugins" page :)
* [on GitHub](https://github.com/rtyler/vagrant-plugin)
* [on the Jenkins wiki](https://wiki.jenkins-ci.org/display/JENKINS/Vagrant+Plugin)


**Enjoy!**
