--- 
layout: post
title: New Year's Python Meme
tags: 
- python
nodeid: 255
created: 1262597316
---
While I'm not aggregated into the [Python Planet](http://planet.python.org) I wanted to join in the [meme](http://just-another.net/2009/12/28/new-years-python-meme/) [that's](http://blog.tplus1.com/index.php/2010/01/04/new-years-python-meme/) [already](http://tarekziade.wordpress.com/2009/12/28/new-years-python-meme/) [going](http://coreygoldberg.blogspot.com/2009/12/new-years-python-meme.html) [on](http://www.protocolostomy.com/2009/12/29/2009-python-meme/).

### What’s the coolest Python application, framework or library you have discovered in 2009?

While I didn't discover it until the latter half of 2009, I'd have to say [eventlet](http://eventlet.net) is the coolest Python library I discovered in 2009. After leaving Slide, where I learned the joys of coroutines (a concept previously foreign to me) I briefly contemplated using greenlet to write a coroutines library similar to what is used at Slide. Fortunately I stumbled across eventlet in time, which shares common ancestry with Slide's proprietary library.


### What new programming technique did you learn in 2009?
I'm not sure I really learned any new techniques over the past year, I started writing a *lot* more tests this past year but my habits don't quite qualify as Test Driven Development just yet. As far as Python goes, I've been introduced to the Python C API over the past year (written two entire modules in C [PyECC](http://github.com/rtyler/PyECC) and [py-yajl](http://github.com/rtyler/py-yajl)) and while I wouldn't exactly call implementing Python modules in C a "technique" it's certainly a departure from regular Python (`Py_XDECREF` I'm looking at you)

### What’s the name of the open source project you contributed the most in 2009? What did you do?
Regular readers of my blog can likely guess which open source project I contributed to most in 2009, [Cheetah](http://cheetahtemplate.org), of which I've become the maintainer. I also authored a number of new Python projects in 2009: [PyECC](http://github.com/rtyler/PyECC) a module implementing Elliptical Curve Cryptography (built on top of [seccure](http://point-at-infinity.org/seccure/)), [py-yajl](http://github.com/rtyler/py-yajl) a module utilizing [yajl](http://lloyd.github.com/yajl) for fast JSON encoding/decoding, [IronWatin](http://github.com/rtyler/IronWatin) an IronPython-based module for writing [WatiN](http://watin.sourceforge.net/) tests in Python (supporting screengrabs as well), [PILServ](http://github.com/rtyler/PILServ) an eventlet-based server to do server-side image transformations with [PIL](http://www.pythonware.com/products/pil/), [TweepyDeck](http://github.com/rtyler/TweepyDeck) a PyGTK+ based Twitter client and [MicroMVC](http://github.com/rtyler/MicroMVC) a teeny-tiny MVC styled framework for Python and WSGI built on eventlet and Cheetah.

### What was the Python blog or website you read the most in 2009?

The [Python reddit](http://reddit.com/r/python) was probably the most read Python-related "blog" I read in 2009, it generally supercedes the [Python Planet](http://planet.python.org) with regards to content but also includes discussions as well as package release posts.  

### What are the top three things you want to learn in 2010?
 
* **Python 3**. After spending a couple weekends trying to get Cheetah into good working order on Python 3, I must say, maintaining a Python-based module on both Python 2.xx and 3.xx really feels like a nightmare. py-yajl on the otherhand, being entirely C, was **trivial** to get compiling and executing perfectly for 2.xx and 3.xx
* **NoSQL**. Earlier this very evening I dumped a boatload of data out of PostgreSQL into [Redis](http://code.google.com/p/redis/) and the resulting Python code for data access using [redis-py](http://github.com/andymccurdy/redis-py) is shockingly simple. I'm looking forward to finding more places where a relational database is overkill for certain types of stored data, and using Redis instead.
* **Optimizing Python**. With py-yajl [Lloyd](http://github.com/lloyd) and I had some fun optimizing the C code behind the module, but I'd love to learn some handy tricks to making pure-Python execute as fast as possible.
