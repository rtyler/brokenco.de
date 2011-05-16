--- 
layout: post
title: On GitHub and how I came to write the fastest Python JSON module in town
tags: 
- software development
- git
- python
created: 1259919009
---
Perhaps the title is a bit too much ego stroking, yes, I did write the fastest Python module for decoding JSON strings and encoding Python objects to JSON. I didn't however write the parser behind the scenes.

Over the summer I discovered "<a id="aptureLink_n24z7kSMi1" href="http://lloyd.github.com/yajl/">Yet Another JSON Library</a>" on <a id="aptureLink_u0eQz9GMNI" href="http://www.crunchbase.com/company/github">GitHub</a>, written by <a id="aptureLink_YqaYOvz7FP" href="http://twitter.com/lloydhilaiel">Lloyd Hilaiel</a>, jonesing for a Saturday afternoon project I started the "<a id="aptureLink_iih8O9gONv" href="http://search.twitter.com/search?q=py-yajl">py-yajl</a>" project to see if I could implement a Python C module atop Lloyd's marvelous parsing library. After tinkering with the project for a while I got a working prototype building (learning how to define custom types in Python along the way) and let the project stagnate as my weekend ended and the workweek resumed.

A little over a week ago "<a id="aptureLink_S2nwrzEgQp" href="http://github.com/autodata">autodata</a>", another GitHub user, sent me a "Pull Request" with some minor changes to make py-yajl build cleaner on amd64; my interest in the project was suddenly reignited, amazing what a little interest can do for motivation. Over the 10  days following autodata's pull request I discovered that a former colleague of mine and fellow GitHub user "<a id="aptureLink_mY3NgqZfrq" href="http://twitter.com/teepark">teepark</a>" had forked the project as well, working on Python 3 support. Going from zero to **two** people interested in the project, I quickly converted the code from a stagnant, borderline embarrassing, dump of C code into a leak-free, swift JSON library
for Python. Not one to miss out on the fun, I pinged Lloyd who quickly became as enamored with making py-yajl the best Python JSON module available, he forked the project and almost immediately sent a number of pull requests my way with further optimizations to py-yajl such as:

* Swapping out the use of Python lists to a custom pointer stack for maintaining internal state
* Accelerating parsing and handling of Number objects
* Pruning a few memory leaks here and there

Thanks to <a id="aptureLink_CZHm3Z4vyV" href="http://twitter.com/mikeal">mikeal</a>'s <a id="aptureLink_2E75jRgjq1" href="http://www.mikealrogers.com/archives/695">JSON post</a> and <a href="http://gist.github.com/239887">jsonperf.py</a> script, Lloyd and I could both see how py-yajl was stacking up against <a id="aptureLink_kofLpe0ikl" href="http://pypi.python.org/pypi/python-cjson">cjson</a>, jsonlib, <a id="aptureLink_V0T79aEWbu" href="http://code.google.com/p/jsonlib2/">jsonlib2</a> and <a id="aptureLink_bZhlC8WgRE" href="http://code.google.com/p/simplejson/">simplejson</a>; things got competitive. Below are the most recent `jsonperf.py` results with py-yajl v0.1.1:

    json.loads:         6470.22037ms
    simplejson.loads:   202.21063ms  
    yajl.loads:         145.32621ms
    cjson.decode:       102.44788ms

    json.dumps:         2309.15286ms
    cjson.encode:       276.49586ms   
    simplejson.dumps:   201.59785ms
    yajl.dumps:         161.00153ms

Over the coming days or weeks (as time permits) I'm planning on adding JSON stream parsing support, i.e. parsing a stream of data as it's coming in off a socket or file object, as well as a few other miscellaneous tasks.

Given the nature of GitHub's social coding dynamic, py-yajl got off the ground as a project but Yajl itself gained an IRC channel (#yajl on Freenode) and a mailing list (yajl@librelist.com). To date I have over 20 unique repositories on GitHub (i.e. authored by me) but the experience around Yajl has been the most exciting and finally proved the "social coding" concept beneficial to me.
