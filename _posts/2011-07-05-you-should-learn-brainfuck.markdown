---
layout: post
title: Why you should learn Brainfuck
tags:
- brainfuck
- programming
- opinion
---

This past weekend I finally had a satisfyingly large chunk of free time that I
could devote to hacking on various ideas, it was glorious.

For one reason or another one of those things that I hacked on was a [Brainfuck
interpreter in Ada](https://github.com/rtyler/fucked-ada/).

Writing the interpeter wasn't terrifically difficult (getting the loop logic
correct was a little tricky), but the more I tinkered with Brainfuck, the more
fascinated I became.

----

***Disclaimer:*** Brainfuck is a silly, silly language that I would never try
to use in any serious context.

----

For the uninitiated, [Brainfuck](https://secure.wikimedia.org/wikipedia/en/wiki/Brainfuck) is a woefully esoteric programming language with
eight commands: `< > . , + - [ ]`. The core concept of the language is that you
have a stack of "cells" (think bytes in memory), and all you can really do in
the language is: move around, increment cell values and decrement cell values.

What fascinates me about Brainfuck is that it **forces** you to maintain
an exact replica of the stack in your head, there is no disconnect between my
mental model and the computer's model of the program and its data.

I'm reminded by an essay I read a week or two ago titled "[Why Programming
Languages?](http://soft.vub.ac.be/~tvcutsem/whypls.html)" and the points the
article's author [Tom Van Cutsem](http://soft.vub.ac.be/~tvcutsem) makes
regarding "Language as a thought shaper"

> *The goal of a thought shaper language is to change the way a programmer thinks
> about structuring his or her program. The basic building blocks provided by a
> programming language, as well as the ways in which they can (or cannot) be
> combined ...*

To me, this is what makes Brainfuck compelling, it is by no means a "useful"
language in its own right but it *is* a language that affects your thinking
about particular problems.

You might enjoy the challenge of solving a sodoku puzzle on the train, I enjoy
the challenge of solving a problem with Brainfuck.

Oh, and saying "Brainfuck" out loud in polite company, I enjoy that too.

Brainfuck.

----
