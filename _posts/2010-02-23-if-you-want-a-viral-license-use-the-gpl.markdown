--- 
layout: post
title: If you want a viral license, use the GPL
tags: 
- opinion
- python
created: 1266936300
---
My "roots" in the open source community come from the BSD side of the open source spectrum, my first major introduction being involvement with <a id="aptureLink_Z6pelwUEYA" href="http://en.wikipedia.org/wiki/FreeBSD">FreeBSD</a> and <a id="aptureLink_ZXZxVq5WFh" href="http://en.wikipedia.org/wiki/OpenBSD">OpenBSD</a>. It is not surprising that my licensing preferences fall on the BSD (2 or 3 clause) or MIT licenses, the MIT license reading as follows:<blockquote><p>Copyright (c) [year] [copyright holders]
<p>
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
<p>
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
<p>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.</blockquote>

I bring the subject up because I wanted to address a brief "kerfuffle" that occurred recently on the <a id="aptureLink_0mMM3DzSHh" href="http://eventlet.net/">Eventlet</a> mailing list with the maintainer of <a id="aptureLink_BWth7wZxHe" href="http://www.gevent.org/">gevent</a>, a fork/rewrite of Eventlet. Both projects are MIT licensed which gives anybody that would like to fork the source code of either project a great deal of leeway to hack about with the code, commercialize it, etc.
<!--break-->
**Disclaimer**: I personally am a fan of Eventlet, use it quite often, and have recently taking up maintaining Spawning, a WSGI server that supports multiple processes/threads, non-blocking I/O and graceful code reloading, built on top of Eventlet.

The "kerfuffle" occurred after Ryan, the maintainer of Eventlet, took a few good modules from gevent; *shocking* as it may seem, a developer working with liberally licensed code took liberally licensed code from a similar project. The issue that the maintainer of gevent took with the incorporation of his code was all about attribution:

> I don't mind you borrowing code from gevent, the license permits it. However, please make it clear where are you getting the code from.

Upon first reading the email, I doubled over to the [eventlet source on Bitbucket](http://bitbucket.org/which_linden/eventlet/), checked the files that were incorporated into the codebase ([timeout.py](http://bitbucket.org/which_linden/eventlet/src/tip/eventlet/timeout.py) and [queue.py](http://bitbucket.org/which_linden/eventlet/src/tip/eventlet/queue.py))and sure enough the copyright attributing the original author were still in tact, surely this is a non-issue?

Unfortunately not, license pedantry is an open source community past-time, right up their with drinking and shouting. When I replied mentioning that the copyrights were correctly in place, mentioning that both projects were MIT licensed so both constraints of the license were met, that is, the MIT license notice was included with the code. In essence the disagreement revolves around what the phrase "this permission notice shall be included" entail, my interpretation of the license is such that the MIT license itself shall be included, not the specific file with additions from one project to another; after sending off my mail, I received the following reply:

> Ok, it's acceptable to use one LICENSE file but only if the copyright notice from gevent is present unchanged.
> 
> That is, take the notice from here http://bitbucket.org/denis/gevent/src/tip/LICENSE (the line with the url), and put it into eventlet's LICENSE, on a separate line. (It's OK to add "Copyright (c) 2009-2010" before it to make it in line with others).
> 
> That would settle it.

Slightly pedantic in my opinion, the MIT license enumerates a line for copyright holders which has been hijacked for other information that the maintainer of gevent would like to propagate, I don't necessarily agree, but this is a mailing list not a court of law, so I'll allow it. The thread continues:

> The license did not change. I've only updated the copyright notice to include the url of the project to protect against abusive borrowers, that's it.

This is where I draw the line, go all in, plant my flag in the sand and other unnecessary metaphors. **Abusive borrowers?** Analyzing the semantics of the phrase alone makes my head hurt, I have a mental image of two old ladies wherein one says to the other: "may I borrow a cup of sugar, you horse-faced hunch-backed bucket of moron?" The rest of the email is full of similarly head-hurting quotes, for brevity I won't include them here (you can read the thread [in the archives](https://lists.secondlife.com/pipermail/eventletdev/2010-February/000731.html)).

I'm simply dumbfounded by the ignorance of what the MIT license actually *means*, unlike the LGPL or the GPL license which were specifically drafted to protect against "abusive borrowers", <a id="aptureLink_grMTA0vhuq" href="http://lwn.net/Articles/51570/">such as Cisco</a>, the MIT license is so open it's *almost* public domain. 

To a certain extent I can understand the emotions behind the thread on the mailing list, I don't agree with them. If you're seeking attribution past the copyright line in a header, than perhaps the "original" [4 clause BSD license](http://en.wikipedia.org/wiki/BSD_licenses#4-clause_license_.28original_.22BSD_License.22.29) is for you, or perhaps the LGPL or GPL which give you more control over what happens to the source code you originate? If this is what you're after, the MIT license is the wrong license.
