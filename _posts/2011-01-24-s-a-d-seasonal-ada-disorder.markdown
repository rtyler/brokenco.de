--- 
layout: post
title: S.A.D. - Seasonal Ada Disorder
tags: 
- opinion
- software development
- ada
created: 1295881200
---
Last Sunday, I announced the "0.1" release of my
[memcache-ada](http://adacommons.org/Memcache) project on
[comp.lang.ada](http://groups.google.com/group/comp.lang.ada/browse_thread/thread/c70dc869310ffb51#),
thus ending a 2 month experiment with the Ada programming language.

In my [previous
post](http://unethicalblogger.com/posts/2010/12/ada_surely_you_jest_mr_pythonman)
on the topic, I mentioned some of the things that interested me with regards to
Ada and while I didn't use all the concepts that make Ada a powerful language,
I can now confidentally say that I know enough to be dangerous (not much more
though).

<center><img src="http://agentdero.cachefly.net/unethicalblogger.com/images/terminaloperator.png" alt="Old school"/><br><em>This is what my coworkers thought of me, learning Ada.</em></center>

All said and done I spent *less than* two months off and on creating
memcache-ada, mostly on my morning and evening commutes. The exercise of
beginning and ending my day with a language which tends to be incredibly strict
was interesting to say the least. Due to the lack of an REPL such as Python's,
I found myself writing more and more unit and integration tests to get a *feel*
for the language and the behavior of my library.
<!--break-->
Due to my "fluency" in Python, I tend to think in Python when scratching out
code, similar to how a native speaker of a language will write or speak "from the hip" instead of doing
large amount of mental work to construct statements. With Ada, not only
am I not yet "fluent", the langauge won't let me get away with as much as
Python allows me.

The overhead of writing Ada, in my opinion, is a double-edged sword, I can very
quickly informally test, debug and rewrite Python but with Ada such a process
is (in my opinion) onerous. My 20 minute walk to the train station would be
spent contemplating how and what I wanted to write and where. By the
time I sat down on the train, I had thought out and designed things internally, so I would
immediately write out tests around my ideas and assumptions before writing code to pass the
tests. The time spent writing code was minimal since I rarely had to rewrite code, I can think of only one function that had to be rewritten after it had passed tests (botched some socket reading) in the whole project.



I'm not yet sure what will be my next project in Ada, I am certain that I don't
want to build anything of consequence in C again. Working with a language, like
C, that not only gives you the rope with which to hang yourself but will often
times push you off the chair is more masochism than I feel comfortable with
these days. Ada on the other hand will allow you to hang yourself, but it'll
make damn certain that have the perseverence to go through with it. Frankly, I
don't have that kind of drive to really shoot myself in the foot anymore. I
want to build software that works with a language that doesn't want to make me
suffer, which means I'll be in a weird Ada + Python love triangle until future notice.
