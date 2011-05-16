--- 
layout: post
title: Programming as an objective art
tags: 
- Opinion
- Miscellaneous
- Software Development
created: 1267457400
---
Writing software is an outlet for artistic expression to many people, myself included.
For me, solving problems involves a good deal of creativity not only in the actual solution
but also in the manipulating several moving parts in order to fit the solution into an
existing code-base. Combining this creative outlet with a beautiful language, such as Python
results in some developers writing code that holds an masterpiece-level of beauty to them,
to the untrained eye one might look at a class and think nothing of it, but to the author of
that code, it might represent a substantial amount of work and personal investment.

Like art, sometimes the beauty is entirely subjective. there has been times where I've been
immensely pleased with one of my creations, only to turn to wholly unimpressed <a id="aptureLink_0iGpof5YL6" href="http://twitter.com/stuffonfire">Dave</a>. Managing
or working with any team of highly motivated, passionate and creative developers presents this
problem, as a group: **how can you objectively judge code while preserving the sense of ownership by
the author?**
<!--break-->
The first step to objectively judging code in my opinion, is to separate it from the individual
who wrote it when discussing the code. For a lot of people this is easier said than done, particularly
for younger engineers like myself. Younger engineers tend to have "more to prove" and are thereby
far more emotionally invested in the code that they write, while older engineers whether by experience
or simply by having written more code than their younger counterparts are able to distance themselves
emotionally more easily from the code that they write. Not to say older engineers aren't emotionally
invested in their work, in my experience they typically are, it's just a matter being better at picking battles.

Code review is a common sticking point for a lot of engineers, it's incredibly important for both
parties in a code review to judge the code objectively, if you are not, a code review can result in
hurt feelings and resentment, personal differences bubbling up to the surface in a venue they don't belong in. I think it's immensely important to refer to code as an entity unto itself
once a code review starts, phrases like "your code" are a major taboo. Separating the person who wrote
the code from the code itself can help both the reviewer but also the original author of the code
look at the changes in an objective light. "*The code is overly complicated when all it should be doing
is X.*" "*The patch doesn't appropriately account for condition Y, which can happen if Z.*" With a change
in semantics, the conversation changes from one developer judging another's work, to two developers
objectively discussing whether or not the desired goal has been acheived with minimal downside.
(*Note*: I'm presuming "proper code review" is being performed, devoid of nitpicking on minor style
differences) You will find behavior like this in many successful open source projects that make
heavy use of code review, the Git project comes to mind. When patches are posted to the mailing list,
their merits are discussed as a separate entity, separated from the original author.

This same strategy of separating the individual from the code should also be applied to bugs in the code.
When using <a id="aptureLink_BRxnybEToo" href="http://www.kernel.org/pub/software/scm/git/docs/git-blame.html">git-blame(1)</a> for example, there is a tendency to look at who authored the change, seek them
out and pummel them with a herring. In a smaller team dynamic, as well as an open source environment,
pinning "ownership" of a bug to a particular person is *entirely* non-constructive. Publicly citing
and referencing somebody else's mistake does nothing other than hurt that individual's ego. The
important part to refer to with git-blame(1) is the commit hash, and nothing else. With the conversation
changed from "*Jacob introduced a bug that causes X*" into "*Commit ff612a introduces a bug that causes X*"
those involved can then look at the code, and determine what about that code causes the issue. For
simpler bugs the original author will typically pipe up with "*Whoops, forgot about X, here's a fix*" but
there are also cases where the original author didn't know about the implications of the change, had
no means of testing for X, or the bug was caused by another change the original author wasn't privvy to. If the code is not separate from the individual, those latter cases can be tension points between developers that need not exist, making it all the more important (especially in small teams) to discuss changes openly and objectively.


With code decoupled from the author himself, how does the author maintain that same sense of pride
and ownership? The original author should be charge with making any changes that arise out of a
code review (naturally) but also should maintain responsibility for that portion of code moving
forward; this added responsibility ensures less "fire and forget" changes and adds more pressure on the
code reviews to yield improvements to the stability and readability of new code.

As soon as more than one developer is working on a project, it becomes increasingly important to recognize the difference between the "works of art" and the artist himself. The ceilings of the <a id="aptureLink_C8Ludq175A" href="http://en.wikipedia.org/wiki/Sistine%20Chapel%20ceiling">Sistine Chapel</a> are an incredible piece of art, not because they were painted by Michelangelo. Writing code should be no different, the art is not the artist and vice versa.
