--- 
layout: post
title: Template Theory
tags: 
- opinion
- software development
- cheetah
created: 1242506511
---
Since becoming the (*de-facto*) maintainer of the [Cheetah project](http://www.cheetahtemplate.org) I've been thinking
more and more about what a templating engine *should* do and where the boundary between template engine
and language are drawn. At their most basic level, template engines are means of programmatically 
generating large strings or otherwise massaging chunks of text. What tends to separate template 
engines from one another are: the language they're written in and what level of "host-language" access
they offer the author of the template.

[Cheetah](http://www.cheetahtemplate.org) is special in that for all intents and purposes 
Cheetah **is** [Python](http://www.python.org) which blurs the line between the controller layer 
and the view layer, as Cheetah is compiled into literal Python code. 
In fact, one of the noted strengths of Cheetah is that Cheetah templates can 
subclass from regular Python objects defined in normal Python modules, and vice versa. That being
the case, how do you organize your code, and where should particular portions physically reside in the
source tree? What qualifies code to be entered into a **.py** file
versus a **.tmpl** file? If you zoom out from this particular problem, to a larger scope, I believe there is a 
much larger question to be answered here: as a *language*, what should Cheetah provide?

Since Cheetah compiles down to Python, does it merit introducing all the Python constructs that one 
has at their disposal within Cheetah, including:
 
 * Properties
 * Decorated methods
 * Full/multiple inheritance
 * Metaclasses/class factories

Attacked from the other end, what *Cheetah-specific* language constructs are acceptable to be introduced 
into Cheetah as a Python-based hybrid language? Currently some of the language constructs that exist in Cheetah
that are distinct to Cheetah itself are:

 * `#include`
 * `#filter`
 * `#stop`
 * `#shBang`
 * `#block`
 * `#indent`
 * `#transform`
 * `#silent`
 * `#slurp`
 * `#encoding`

Some of the examples of unique Cheetah directives are necessary in order to manipulate template output
in ways that aren't applicable to normal Python (take `#slurp`, `#indent`, `#filter` for example), but where does one draw
the line?

Too add yet another layer of complexity into the problem, Cheetah is not only used in the traditional
Model-View-Controller set up (e.g. [Django + Cheetah templates](http://code.google.com/p/django-cheetahtemplate/)) 
but it's also used to generate *other* code, i.e. Cheetah is sometimes used as a means of generating 
source code (`bash`, `C`, etc). 

In My Humble Opinion
--------------------
Cheetah, at least to me, is not a lump of text files that you can perform loops and use variables in, 
it is a fully functional, object-oriented, Pythonic text-aware programming language. Whether or not it compiles to Python or 
is fully interoperable with Python is largely irrelevant (that is not to say that [we](http://www.slide.com) 
don't make use of this feature). As far as "what should Cheetah provide?" I think the best way to answer the question
is to not think about Cheetah as Python, or as a "strict" template engine (Mako, Genshi, etc) but rather as a 
*domain specific language* for complex text generation and templating. When deciding on what Python features 
to expose as directives in Cheetah (the language) the litmus test that should be evaluated against is: *does this make 
generating text easier?*

Cheetah need not have hash-directives for every feature available in Python, the idea of requiring meta-classes 
in Cheetah is ridiculous at best, a feature like decorators however could prove quite useful in text processing/generation 
(e.g. function output filters), along with proper full inheritance. 

My goals ultimately with Cheetah, are to make [our](http://www.slide.com) lives easier developing
rich interfaces for our various web properties, but also to make "things" faster. Whereas "things" can
fall under a few different buckets: development time, execution time, maintenance time.


Cheetah will likely look largely the same a year from now, and if we (the developers of Cheetah)
have done our jobs correctly, it should be just as simple to pick up and learn, but even more
powerful and expressive than before.
