--- 
layout: post
title: Sometimes Software as a Service Sucks
tags: 
- opinion
- software development
- hudson
created: 1269352800
---
Being a big fan of "continuous integration", particularly with <a id="aptureLink_PmOzQb3Bo7" href="http://twitter.com/hudsonci">Hudson</a>, I've often thought about the possibilities of turning it into a business. It's no surprise really, my first commercial application as a rogue Mac software developer was a product called [BuildFactory](http://bleepsoft.com/buildfactory/) which, while fun to build, never sold all that many licenses. With the advent of Amazon's <a id="aptureLink_SLPMEfLHeR" href="http://en.wikipedia.org/wiki/Amazon%20Elastic%20Compute%20Cloud">EC2</a> service and the transition of these cloud computing resources into a building block for many businesses, I've long thought about the idea of building "continuous integration as a service." 

At face value the idea sounds incredibly fun to build, I'll build a service that integrates with <a id="aptureLink_q5Kr8iq6a2" href="http://twitter.com/gIthub">GitHub</a>, <a id="aptureLink_BLDvLKGYwy" href="http://www.crunchbase.com/product/google-code">Google Code</a>, <a id="aptureLink_z9njtjnyXs" href="http://en.wikipedia.org/wiki/SourceForge">SourceForge</a> and private source control systems. The end (paying) user would "plug-in" to the "continuous integration grid", they'd work throughout the day, committing code and then the CI grid would pick up those changes, build releases and run tests against a number of different architecture, automatically detecting failures and reporting them back to the developers. It involves some of my favorite challenges in programming:

* Scaling up
* Efficiently using cycles, and only when needed
* Building and testing cross-architecture and cross-platform

Unfortunately, it's a crap business idea, I now have second-hand confirmation from a group of guys who've attempted the concept. The folks behind <a id="aptureLink_Yb3agfhs2a" href="http://runcoderun.com/">RunCodeRun</a> are [shutting down the service](http://blog.runcoderun.com/post/463439385/saying-goodbye-to-runcoderun). In the post outlining why they're shutting down, they've hit the nail on the head on why "continuous integration as a service" can **never** work:

> Large scale hosted continuous integration is consumed as a commodity but built as a craft, and the rewards, both emotional and financial, are insufficient to support the effort.

Elaborating further on their point, continuous integration by itself is a relatively basic task: build, test, repeat. The biggest problem with continuous integration as a service however, is that no two projects are alike. My build targets or requirements might be vastly different from project to project, let alone customer to customer, making the amount of tweaking and customization per-job too large such that at some point the only benefit that one derives from such a service is the hosting of the machines to perform the task. If you're just taking care of that, why wouldn't your customers just use Hudson in "the cloud" themselves? The CI grid at that point offers no exceptional value.

As much as I regret letting a fun idea die, I think I'll have to file this one under "To do after becoming so rich I'll care about capital gains taxes."
