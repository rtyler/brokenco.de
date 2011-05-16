--- 
layout: post
title: "Writing for Stability (or: I hate writing tests)"
tags: 
- slide
- opinion
- software development
nodeid: 221
created: 1248852608
---
Since moving to the infrastructure team at [Slide](http://slideinc.github.com) 
I've found the rate at which my software gets deployed has plummeted, while the 
quantity of the code that I am deploying to the live site has sky-rocketed. When
on an applications-team within Slide, code is typically pushed in small incrememnts a few
days a week, if not daily. This allows for really exciting compact milestones that 
make more fine-grained analysis achievable, post-push for product management and metrics 
purposes. On the _infrastructure_ team however, the requirements are *wholly* different, 
the "fail-fast, ship-now" mentality that prevails when doing user-facing web application 
development just *does not* work in infrastructure. The most important aspects of building
out infrastructure components are stability and usability, our "customers" are the rest of 
engineering, and that has a definite effect on your workflow.

Code Review
------------
One of the things that [@jasonrubenstein](http://twitter.com/jasonrubenstein) and I always 
did when we worked together, was occasional code review. In the majority of cases, our "code review" sessions 
were more or less [rubber duck debugging](http://en.wikipedia.org/wiki/Rubber_duck_debugging), but 
occasionally it would escalate into more complex discussions about the "right way" to do something. 
When you're writing infrastructure software for services that are handling [tens of millions of users](http://www.slide.com/static/about_press) 
the notion of "code review" goes from being _optional_ to being absolutely _required_. Discussions 
are had on the correctness or performance characteristics of database indexes, the necessity of some 
objects instantiating default values of attributes or having them lazily load, or debating garbage 
collection of objects while meticulously watching [memory consumption](https://twitter.com/agentdero/status/2442677113).

For one of my most recent projects, I was working on [something](http://github.com/slideinc/PyECC/tree/master) in C, 
a rarity at Slide since we work with managed code in [Python](http://python.org) the majority of the 
time. As the project neared completion, I counted roughly two or three *hours* of code review time 
dedicated by our Chief Architect. The attention to detail paid to this code was extremely high, 
as the service was going to be handling millions of requests from other levels of 
the Slide infrastructure, before getting cycled or restarted. 

A particularly frustrating aspect of code review by your peers is that a second set of eyes not only 
will find problems with your code, but will likely mean refactoring or bug fixes, more work.
In my case, whenever a bug or stability issue was discovered, a test needed to be 
written for it to make sure the bug did not present itself again, the workload would be larger than 
if I had just fixed the bug and moved on with my life.


Testing, oh the testing
-----------------------
If you expect to write an API, have it stablize, and *then* be used, you *must* write test cases for 
it. I'm not a [TDD](http://en.wikipedia.org/wiki/Test-driven_development) "nut", I actually *hate* 
writing test cases, I absolutely abhor it. Writing test cases is _responsible_ and  the _adult_ 
thing to do. In my experience, it can also be _tedious_ and usually comes as a result of 
finding flaws in my own software. The majority of tests that I find myself writing are admissions of
defeat, admitting that I don't crap roses and by george, my code isn't perfect either. 

On the flipside however, *I hate debugging* even more. Stepping through a call stack is on par 
with waterboarding in my book, torture. Which means I'm more than willing to tolerate writing tests
so long as it means I can be certain I will be cutting down on the time spent being tortured with 
either [pdb](http://docs.python.org/library/pdb.html) or [gdb](http://www.gnu.org/software/gdb/). 
In almost every situation where I've written tests properly, like the _responsible_ developer that 
I am, I find them saving me at some point. It might be getting late, or I'm just feeling a little
cavalier, but tests failing almost always indicates that I've screwed something up I shouldn't have.

Additionally, now that the majority of my projects are infrastructure-level projects, the tests I write serve 
a second "undocumented" purpose, they provide ready-made examples for other developers on _how to 
use my code_. Bonus!


The more and more code I write, the more amazed I am at the pushback against testing in general, 
there exists decent libraries for *every* language imaginable (well, perhaps BrainfuckUnit doesn't 
exist), and its *sole* purpose (in my opinion) is to save develpoment time, particularly when coupled 
with a [good continuous integration server](http://www.hudson-ci.org). Further to that effect, if you're 
building services for *other developers* to use, and you're not writing tests for it, you're not only 
wasting your time and your employer's money, but the time of your users as well (read: stop being a jerk). 

Sure there are a lot of articles/books/etc about writing stable code, but in my opinion, solid code
review and testing will stablize your code far more than any design pattern ever will.
<!--break-->
