--- 
layout: post
title: Server-side image transforms in Python
tags: 
- miscellaneous
- software development
- python
created: 1259995893
---
While working at <a id="aptureLink_LQdA2xFWcb" href="http://twitter.com/slideinc">Slide</a>, I became enamored with the concept of cooperative threads (coroutines) and the in-house library built around <a id="aptureLink_uF9ePt8EiT" href="http://pypi.python.org/pypi/greenlet">greenlet</a> to implement coroutines for Python. As an engineer on the "server team" I had the joy of working in a coro-environment on a daily basis but now that I'm "out" I've had to find an alternative library to give me coroutines: <a id="aptureLink_k3TaZzEP9q" href="http://eventlet.net/doc/">eventlet</a>. Interestingly enough, eventlet shares common ancestry with Slide's internal coroutine implementation like two different species separated thousands of years ago by continental drift (a story for another day).

A few weekends ago, I had a coroutine itch to scratch one afternoon: an eventlet-based image server for applying transforms/filters/etc. After playing around for a couple hours "<a id="aptureLink_MaMftEzfE4" href="http://github.com/rtyler/PILServ/commits/master">PILServ</a>" started to come together. One of the key features I wanted to have in my little image server project was the ability to not only pass the server a URL of an image instead of a local path but also to "chain" transforms in a jQuery-esque style. Using segments of the URL as arguments, a user can arbitrarily chain arguments into PILServ, i.e.:

    http://localhost:8080/flip/filter(blur)/rotate(45)/resize(64x64)/<url to an image>

At the end of the evening I spent on PILServ, I had something going that likely shows off more of the skills of <a id="aptureLink_my0NPtWw65" href="http://www.pythonware.com/products/pil/">PIL</a> rather than eventlet itself but I still think it's *neat*. Below is a sample of some images transformed by PILServ running locally:

<center><a href="http://agentdero.cachefly.net/scratch/pilserv.png" rel='lightbox'><img src="http://agentdero.cachefly.net/scratch/pilserv.png" width="450" border="0"/></a></center>
