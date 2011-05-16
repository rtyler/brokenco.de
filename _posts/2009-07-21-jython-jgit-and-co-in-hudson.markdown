--- 
layout: post
title: Jython, JGit and co. in Hudson
tags: 
- Opinion
- Miscellaneous
- Software Development
- Git
- Hudson
created: 1248243398
---
At the [Hudson Bay Area Meetup/Hackathon](http://wiki.hudson-ci.org/display/HUDSON/BayAreaMeetup) 
that [Slide, Inc.](http://slideinc.github.com) hosted last weekend, I worked on the 
[Jython plugin](http://wiki.hudson-ci.org/display/HUDSON/Jython+Plugin) 
and released it just days after releasing a strikingly similar plugin, the 
[Python plugin](http://wiki.hudson-ci.org/display/HUDSON/Python+Plugin). I felt 
that an explanation might be warranted as to why I would do such a thing.

For those that don't know, [Hudson](http://hudson-ci.org) is a Java-based continuous 
integration server, one of the best CI servers developed (in my humblest of opinions). 
What makes Hudson so great is a **very** solid [plugin architecture](http://wiki.hudson-ci.org/display/HUDSON/Extend+Hudson) 
allowing developers to extend Hudson to support a wide variety of scripting languages 
as well as notifiers, source control systems, and so on ([related post](http://weblogs.java.net/blog/kohsuke/archive/2009/06/growth_of_hudso.html) 
on the growth of Hudson's plugin ecosystem). Additionally, Hudson supports *slaves* on
any operating system that Java supports, allowing you to have a central manager (the 
"master" Hudson server/node) and a vast network of different machines performing tasks 
and executing jobs. Now that you're up to speed, back to the topic at hand.

**Jython** versus **Python** plugin. Why bother with either, as [@gboissinot](http://twitter.com/gboissinot) 
pointed out in [this tweet](http://twitter.com/gboissinot/status/2619505521)? The 
*interesting* thing about the Jython plugin, particularly when you use a large number
of slaves is that with the installation of the Jython plugin, suddenly you have the 
ability to execute Python script on **every** single slave, regardless of whether or 
not they actually have Python installed. The more "third party" that can be moved into 
Hudson by way of the plugin system means reduced dependencies and difficulty setting 
up slaves to help handle load.

Take the "git" versus the "git2" plugin, the git plugin was recently criticized on the 
[#hudson channel](irc://irc.freenode.net/hudson) because of it's use of the [JGit](http://www.jgit.org/) 
library, versus "git2" which invokes [git(1)](http://git-scm.org) on the command line. 
The latter approach is flawed for a number of reasons, particularly the reliance on the git 
command line executables and scripts to return consistent formatting is specious at best 
even if you aren't relying on "porcelain" (git community terminology for front-end-ish 
script and code sitting on top of the "plumbing", the breakdown is detailed [here](http://www.kernel.org/pub/software/scm/git/docs/)). 
The command-line approach also means you now have to ensure every one of your slaves 
that are likely to be executing builds have the appropriate packages installed. 
One the flipside however, with the JGit-based approach, the Hudson slave 
agent can transfer the 
appropriate bytecode to the machine in question and execute that without relying on 
system-dependencies.

The Hudson Subversion plugin takes a similar approach, being based on [SVNKit](http://svnkit.com/). 

Being a Python developer by trade, I am certainly not in the "Java Fanboy" camp, but 
the efficiencies gained by incorporating Java-based libraries in Hudson plugins and 
extensions is a no brainer, the reduction of dependencies on the systems incorporated 
in your build farm will save you plenty of time in maintenance and version woes alone. 
In my opinion, the benefits of JGit, Jython, SVNKit, and the other Java-based libraries 
that are running some of the most highly used plugins in the Hudson ecosystem continue 
to outweigh the costs, especially as [we](http://slideinc.github.com) find ourselves bringing more and more slaves 
online.
<!--break-->
