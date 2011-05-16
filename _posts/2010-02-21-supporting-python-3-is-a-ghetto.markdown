--- 
layout: post
title: Supporting Python 3 is a Ghetto
tags: 
- Software Development
- Cheetah
- Python
created: 1266793348
---
In my spurious free time I maintain a few Python modules (<a id="aptureLink_LvMqViext1" href="http://github.com/rtyler/py-yajl">py-yajl</a>, <a id="aptureLink_SEruJN7rBc" href="http://en.wikipedia.org/wiki/CheetahTemplate">Cheetah</a>, <a id="aptureLink_3HQW6OMHEx" href="http://github.com/rtyler/PyECC">PyECC</a>) and am semi-involved in a couple others (<a id="aptureLink_1I31I3RdtY" href="http://www.djangoproject.com/">Django</a>, <a id="aptureLink_7qs5LoY2eY" href="http://eventlet.net/">Eventlet</a>), only one of which properly supports Python 3. For the uninitiated, Python 3 is a backwards incompatible progression of the Python language and CPython implementation thereof, it's represented significant challenges for the Python community insofar that supporting Python 2.xx, which is in wide deployment, and Python 3.xx simultaneously is difficult. 

As it stands now my primary development environment is Python 2.6 on Linux/amd64, which means I get to take advantage of some of the nice things that were added to Python 3 and then back-ported to Python 2.6/2.7. Regular readers know about my undying love for Hudson, a Java-based continuous integration server, which I use to test and build all of the Python projects that I work on. While working this weekend I noticed that one of my C-based projects (py-yajl) was failing to link properly on Python 2.4 and 2.5. It might be easy to cut-off support for Python 2.4, which was first released over **four years** ago, there are still a number of heavy users of 2.4 (such as <a id="aptureLink_k20Tw96O5B" href="http://www.crunchbase.com/company/slide">Slide</a>), in fact it's still the default `/usr/bin/python` on Red Hat Enterprise Linux 5. What makes this C-based module special, is that thanks to <a id="aptureLink_l6Vcy3ytZB" href="http://twitter.com/teepark">Travis</a>, it runs properly on Python 3.1 as well. Since the Python C-API has been *fairly* stable through the 2 series into Python 3, maintaining a C-based module that supports multiple versions of Python.

In this case, it's as easy as some simple pre-processor definitions:<code lang="c">#if PY_MAJOR_VERSION >= 3
#define IS_PYTHON3
#endif</code>Which I can use further down the line to modify the handling some of the minor internal changes for Python 3:<code lang="c">#ifdef IS_PYTHON3
    result = _internal_decode((_YajlDecoder *)decoder, PyBytes_AsString(bufferstring),
                PyBytes_Size(bufferstring));
    Py_XDECREF(bufferstring);
#else
    result = _internal_decode((_YajlDecoder *)decoder, PyString_AsString(buffer),
                  PyString_Size(buffer));
#endif </code>

Not particularly *pretty* but it gets the job done, supporting all major versions of Python.

### Python on Python
Writing modules in C is fun, can give you pretty good performance, but is not something you would want to do with a **large** package like Django (for example). Python is the language we all know and love to work with, a much more pleasant language to work with than C. If you build packages in pure Python, those packages have a much better chance running on top of IronPython or Jython, and the entire Python ecosystem is better for it.

A few weeks ago when I started to look deeper into the possibility of Cheetah support for Python 3, I found a process riddled with faults. First a disclaimer, Cheetah is almost **ten years** old; it's one of the oldest Python projects I can think of that's still chugging along. This translates into some *very* old looking code, most people who are new to the language aren't familiar with some of the ways the language has changed in the past five years, let alone ten. 

The current means of supporting Python 3 with pure Python packages is as follows:

1. Refactor the code enough such that `2to3` can process it
1. Run <a id="aptureLink_GtN83eZUU3" href="http://docs.python.org/library/2to3.html">2to3</a> over the codebase, with the `-w` option to literally write the changes to the files
1. Test your code on Python 3 (if it fails, go back to step 1)
1. Create a source tarball, post to <a id="aptureLink_lvET3CCrpS" href="http://pypi.python.org/">PyPI</a>, continue developing in Python 2.xx 

I'm hoping you spotted the same problem with this model that I did, due to the reliance on `2to3` you are now trapped into **always** developing Python targeting Python **2**. This model will never succeed in moving people to Python 3, regardless of what amazing improvements it contains (such as the Unladen Swallow work) because you cannot develop on a day-to-day basis with Python 3, it's a magic conversion tool away.

Unlike with a C module for Python, I cannot `#ifdef` certain segments of code in and out, which forces me to constantly use `2to3` *or* fork my code and maintain two separate branches of my project, duplicating the work for every change. With Python 2 sticking around on the scene for years to come (I don;t believe 2.7 will be the last release) I cannot imagine **either** of these workflows making sense long term. 


At a fundamental level, supporting Python 3 does not make sense for anybody developing modules, particularly open source ones. Despite Python 3 being "the future", it is currently impossible to develop using Python 3, maintaining support for Python 2, which **all** of us have to do. With enterprise operating systems like <a id="aptureLink_ehh7mOge8i" href="http://www.crunchbase.com/product/red-hat-enterprise-linux">Red Hat</a> or <a id="aptureLink_CklLBYgoAK" href="http://www.novell.com/linux/">SuSE</a> only now starting to get on board with Python 2.5 and Python 2.6, you can be certain that we're more than five years away from seeing Python 3 installed by default on any production machines.
<!--break-->
