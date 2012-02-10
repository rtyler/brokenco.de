---
layout: post
title: "FOSDEM: Smalltalk Pairing"
tags:
- smalltalk
- fosdem
- fosdem2012
- tripdiary
---

As I [previously mentioned](/2012/01/14/realtalk.html), I've been learning
Smalltalk lately, in an attempt the understand the language that inspired two
of my other favorite languages: Objective-C and Ruby.

This past weekend at FOSDEM, I was fortunate enough to attend a few sessions in
the "Smalltalk devroom", which from my understanding made its debut appearance
at this year's conference. I'll save my thoughts on
[Amber.js](http://www.amber-lang.net) for another time, but in this post I
wanted to talk about the Smalltalk Workshop which was held at the end of the
day.


One of my major stumbling blocks with Smalltalk has been general unfamiliarity
with the development environment, the workshop was the *perfect* opportunity to
resolve some of this. The structure was to pair one experienced Smalltalker
with one noob, and for both to work through a pre-planned exercise with an
existing image and application set up.

<center><a
href="http://www.a3aan.st/fosdem2012/index.php/view/23/01+DevRoom/IMG_6452.JPG" target="_blank"><img
src="http://agentdero.cachefly.net/unethicalblogger.com/images/pairing-on-smalltalk-at-fosdem.JPG" alt="Pairing on Smalltalk" width="500"/></a><br/><em>Haxx haxx haxx</em> (Photo courtesy of Adriaan van Os)</center>

While my partner (Norbert) and I did not complete all the exercises, we did
spend a good amount of time discussing and working through the "Smalltalk way",
or at least Norbert's Smalltalk way, of solving particular problems,
refactoring and method structure.

One of the things that struck me as we worked through the exercises was how
small the ideal method body is for most things in Smalltalk. I don't think
there was a single method that was longer than 10 lines, except for some test
methods which certainly had a bad code smell.

Below is a sample of one of the longest methods I wrote in the entire workshop:

    vote: aVote for: aUser
      author ~= aUser ifTrue: [
        self votes
          detect: [ :vote | vote author = aUser and: [ vote direction = aVote direction]]
          ifNone: [ self votes add: aVote ]]

I'm quite happy with the way things turned out, while I didn't anything I
didn't know already about [Seaside](http://www.seaside.st), I did learn a *lot*
about using the development environment effectively and test-driven development
"the Smalltalk way" which as it turns out is quite impressive.


I'm looking forward to learning more about the ways of the
[Pharo](http://www.pharo-project.org), maybe next year I'll count as one of the
experienced Smalltalkers.
