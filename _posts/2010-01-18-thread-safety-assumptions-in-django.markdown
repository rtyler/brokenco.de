--- 
layout: post
title: Thread-safety assumptions in Django
tags: 
- Opinion
- Software Development
- Python
created: 1263878606
---
These days, the majority of my day job revolves around working with <a id="aptureLink_jvAxf3Xyiw" href="http://www.crunchbase.com/company/apture">Apture's</a> <a id="aptureLink_eYCk1i8kej" href="http://www.djangoproject.com/">Django</a>-based code which, depending on the situation, can be a blessing or a curse. In some of my recent work to help improve our ability to scale effectively, I started swapping out <a id="aptureLink_ybzn7lvyyE" href="http://en.wikipedia.org/wiki/Apache%20HTTP%20Server">Apache</a> for <a id="aptureLink_jDx5yFnmAS" href="http://pypi.python.org/pypi/Spawning">Spawning</a> web servers which can more efficiently handle large numbers of concurrent requests. One of the mechanisms by which Spawning accomplishes this task, is by using <a id="aptureLink_hJSBTiL356" href="http://eventlet.net/doc/">eventlet's</a> `tpool` (thread pool) module in addition to some other clever tricks. With Apache, we used pre-forked workers to accomplish the work needed to be done and while still using forked child processes with Spawning, threading was also thrown into the mix, that's when "shit got real" (so to speak).

We started seeing sporadic, difficult to reproduce errors. Not a lot, a trickle of exception emails throughout the day. Digging deeper into some of the exceptions, careful stepping through Apture code, into Django code and back again, I started to realize I had **thread-safety problems**. Shock! Panic! Despair! Lunch! Disappointment! Shock! I felt all these things and more. I've long lamented the number of globals used in Django's code base but this is the icing on the cake. 

Apparently Django's [threading problems](http://code.djangoproject.com/wiki/DjangoSpecifications/Core/Threading) are sufficiently documented in a [few places](http://y-node.com/blog/2008/oct/30/noreversematch/). Using a slightly older version of the Django framework certainly doesn't help but it doesn't *appear* that recent releases (1.1.1) can guarantee thread-safety anyways. I think it's safe to assume the majority of Django framework users are not using threaded web servers in any capacity, else this would have become a far larger issue (and hopefully of been fixed) by now. From  `NoReverseMatch` exceptions, to curious middleware problems to thread-safety [issues](http://code.djangoproject.com/ticket/11193) in the WSGI  support layer, Django has potholes lying all along the road to multithreadedness.

Beware.
<!--break-->
