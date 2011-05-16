--- 
layout: post
title: Breathing life into a dead open source project
tags: 
- Miscellaneous
- Software Development
- Cheetah
created: 1239006828
---
Over the past [couple years](http://twitter.com/agentdero/status/1441656514) that I have been working at [Slide, Inc.](http://www.slide.com) I've had a love/hate relationship with the [Cheetah](http://www.cheetahtemplate.org) templating engine. Like almost every templating engine, it allows for abuse by its users, which can result in some templating code that looks quite horrendous, contributing significantly to some negative opinions of the templating engine. At one point, I figured an upgrade of Cheetah would help correct some of these abuses and I distinctly remember pushing to upgrade to the 2.xx series of Cheetah. I then found out that I had unintentionally volunteered myself to oversee the migration and also to update any *ancient* code that was lying around that depended on "features" (see: *bugs*) in Cheetah prior to the 2.xx series. We upgraded to Cheetah 2.xx and life was good, but Cheetah was practically dead.

The last **official** release of Cheetah was in November of 2007, this is not something altogether uncommon in the world of open source development. Projects come and go, some reach a point in their growth and development where they're abandoned, or their community dissipates, etc. As time wore on, I found myself coming up with a patch here and there that corrected some deficiency in Cheetah, but I also noticed that many others were doing the same. There was very clearly a need for the project to continue moving forward, and with my introduction to both Git and [GitHub](http://www.github.com) as a way of distributing development, I did what any weekend hacker is prone to do, I forked it.
<!--break-->
Meet Community Cheetah
----------------
On January 5th, 2009 I started to commit to my local fork of the Cheetah code base (taken from [Cheetah CVS tree](http://sourceforge.net/scm/?type=cvs&group_id=28961)), making sure my patches were committed but also taking the patches from a number of others on the [mailing list](https://lists.sourceforge.net/lists/listinfo/cheetahtemplate-discuss). By mid-March I had collected enough patches to properly announce [Cheetah Community Edition v2.1.0](http://sourceforge.net/mailarchive/forum.php?thread_name=20090316070839.GD31561%40starfruit.corp.slide.com&forum_name=cheetahtemplate-discuss) to the mailing list. I was entirely unprepared for the response.

Whereas the previous 6 months of posts to the mailing list averaged about 4 messages a month, March exploded to **88** messages, 20 of them in the thread announcing Cheetah CE (now deemed *Community Cheetah* (it had a better ring to it, and an available [domain name](http://www.communitycheetah.org) to boot)). All of a sudden the slumbering community is awake and the patches have started to trickle in. 

We've fixed some issues with running Cheetah on Python 2.6, Cheetah now supports compiling templates in parallel, issues with import behavior have been fixed and added a number of smaller features. In 2008 there were **six** commits to the Cheetah codebase, thus far in 2009 there have been over seventy (I'm still waiting on a few patches from colleagues at other startups in Silicon Valley as well). 

I'm not going to throw up a "Mission Accomplished" banner just yet, Cheetah still needs a large amount of improvement. It was written during a much different era of Python, the changes in Python 2.6 and moving forward to Python 3.0 present new challenges in modernizing a template engine that was introduced in **2001**. 


Being a maintainer
-----------------
Starting your own open source project is tremendously easy, especially with the advent of hosts like Google Code or GitHub. What's terrifying and difficult, is when other people depend on your work. By stepping up and becoming the de-facto maintainer of [Community Cheetah](http://www.communitycheetah.org), I've opened myself up to a larger collection of expectations than I originally anticipated. I feel as if I have zero credibility with the community at this point, which means I painstakingly check the changes that are committed and review as much code as possible before tagging a release. I'm scared to death of releasing a bad release of Community Cheetah and driving people away from the project, the nightmare scenario I play over in my head when tagging a release in Git is somebody going "this crap doesn't work at all, I'm going to stick with Cheetah v2.0.1 for now" such that I cannot get them to upgrade to subsequent releases of Community Cheetah. I think creators of a project have a lot of "builtin street cred" with their users and community of developers, whereas I still have to establish my street cred through introduction of bug fixes/features, knowledge of the code base and generally being available through the mailing list or IRC.


Moving Forward
-------------
Currently I'm preparing the third Community Cheetah release (which I tagged today) [v2.1.1](http://github.com/rtyler/cheetah/tarball/v2.1.1rc1) which comes almost a month after the previous one and introduces a number of fixes but also some newer features like the **#transform** directive, markdown support, and 100% Python 2.6 compatibility.

Thanks to an intrepid contributor, Jean-Baptiste Quenot, we have a v2.2 release lined up for the near future which fixes a **large** number of Unicode specific faults that Cheetah currently has (the code can currently be found in the [unicode branch](http://github.com/rtyler/cheetah/tree/unicode)) and moves the internal representation of code within the Cheetah compiler/parser to a unicode string object in Python.

I eagerly look forward to more and more usage of Cheetah, with other templating engines out there for Python like [Mako](http://www.makotemplates.org/) and [Genshi](http://genshi.edgewall.org/) I still feel Cheetah sits far and above the others in its power and versatility but has just been neglected for far too long.

If you're interested in contributing to Cheetah, you can [fork it on GitHub](http://github.com/rtyler/cheetah/tree/master), join the [mailing list](http://lists.sourceforge.net/lists/listinfo/cheetahtemplate-discuss) or find us on IRC (#cheetah on Freenode). 

This experiment on restarting an open source project is far from over, but we're off to a promising start.
