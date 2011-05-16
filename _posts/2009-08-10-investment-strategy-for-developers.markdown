--- 
layout: post
title: Investment Strategy for Developers
tags: 
- Slide
- Opinion
- Software Development
created: 1249972459
---
It seems every time [@jasonrubenstein](http://twitter.com/jasonrubenstein), 
[@ggoss3](http://twitter.com/ggoss3), [@cablelounger](http://twitter.com/cablelounger) 
and I sit down to have lunch together, we invariably sway back and forth between 
generic venting about "[work stuff](http://www.slide.com)" and best practices for 
doing aforementioned "work stuff" better. The topic of "reusable code" came up 
over Mac 'n Cheese and beers this afternoon, and I felt it warranted "wider 
distribution" so to speak (yet-another-lame-Slide-inside-joke).

We, [Slide](http://www.slide.com), are approaching our fourth year in existence as a 
startup which means all sorts of interesting things from an investor standpoint, 
employees options are starting to become fully-vested and other mundane and boring 
financial terms. Being an engineer, I don't care too much about the stocks and such, 
but rather about development; four years is a **lot** from a code-investment 
standpoint (my bias towards code instead of financial planning will surely bite me 
eventually). Projects can experience bitrot, bloating (read: Vista'ing) and a myriad 
other illnesses endemic to software that's starting to grow long in the tooth.

At Slide, we have a number of projects on slightly different trajectories and timelines, 
meaning we have an intriguing cross-section of development histories representing 
themselves. We are no doubt experiencing a similar phenomenon to Facebook, MySpace, Yelp and a number of other "startups" who match this same age group of 4-7 
years. Just like our bretheren in the startup community, we have portions of code 
that fit all the major possible categories:

* That which was written extremely fast, without an afterthought to what would happen when it serve tens of millions of users
* That which was written slowly, trying to cater to every possible variation, ultimately to go over-budget and over-schedule.
* That which has been rewritten. And rewritten. And rewritten.
* Then the **exceptionally** rare, that which has been written in such a fashion that it has been elegantly extended to support more than it was originally conceived to support.

In all four cases, "we" (whereas "*we*" refers to an engineering department) have 
invested differently in our code portfolio depending on a number of factors and 
information given at the time. For example, it's been a year since Component X was
written. Component X is currently used by every single product The Company owns, but 
over the past year it's been refactored and partially rewritten each time a new 
product starts to "use" Component X. In its current state, Component X's code reads 
more like an embarrasing submission to [The Daily WTF](http://thedailywtf.com) with 
its hodge-podge of code, passed from team to team, developer to developer, like some
expensive game of "[Telephone](http://en.wikipedia.org/wiki/Chinese_whispers)" for 
software engineers. After the fact, it's difficult and not altogether helpful to 
try to lay blame with the mighty sword of hindsight, but it is feasible to identify the 
*reasons* for the N number of developer hours lost fiddling, extending, and refactoring 
Component X.

* Was the developer responsible for implementing Component X originally aware of the potentially far reaching scope of their work?
* Was the developer given an adequate time frame to implement a proper solution, or "this should have shipped yesterday!"
* Did somebody pass the project off to an intern or somebody who was on their way out the door?
* Were other developers in similar realms of responsibility asked questions or for their opinions?
* Is/was the culture proliferated by Engineering Leads and Managers encouraging of best practices that lead to extensible code?

I've found, watching Slide Engineering culture evolve, that the majority of libraries 
or components that go through multiple time/resource-expensive iterations tend to have 
experienced shortcomings in one of the five sections above. More often than not, 
a developer was given the task to implement Some Thing. Simple enough, Some Thing 
is developed with the specific use-case in mind, and the developer moves on with their 
life. Three months later however, somebody else asks another developer, to add Some Thing 
to **another** product. 

> "Product X has Some Thing, and it works great for them, let's incorporate Some Thing into Product Y by the end of the week." 

Invariably this leads to heavy developer drinking. And then perhaps some copy-paste, 
with a dash of re-jiggering, and quite possibly multiple forks of the same code. That 
is, if Some Thing was not properly planned and designed in the first place. 

Working as a developer on products that move at a fast pace, but will be around for 
longer than three months is an exercise in *investment strategy* (i.e. managing 
[technical debt](http://blogs.construx.com/blogs/stevemcc/archive/2007/11/01/technical-debt-2.aspx)). 
What makes great Engineering Managers great is their ability to determine when and where to invest 
the time to do things right, and where to write some Perl-style write-only code (*zing!*).
What makes a startup environment a more difficult one to work on your "code portfolio" 
is that you don't usually know what may or may not be a success, and in a lot of cases 
getting your product out there **now** is of paramount importance. Unfortunately 
there isn't any simple guideline or silver bullet, and there is **no bailout**, if 
you invest your time poorly up front, there will be nobody to save you further down 
the line when you're staring an resource-devouring refactor in its ugly face.

Where do you invest the time in any given project? What will happen if you shave a 
few days by deciding not to write any tests, or documentation. Will it cost you 
a week further down the road if you take shortcuts now? 

I wish I knew.
<!--break-->
