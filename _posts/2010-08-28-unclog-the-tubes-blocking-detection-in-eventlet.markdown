--- 
layout: post
title: Unclog the tubes; blocking detection in Eventlet
tags: 
- Software Development
- Python
created: 1283033527
---
Colleagues of mine are all very familiar with my admiration of [Eventlet](http://eventlet.net), a
Python concurrency library, built on top of [greenlet](http://pypi.python.org/pypi/greenlet), that
provides lightweight "greenthreads" that naturally yield around I/O points. For me, the biggest draw of Eventlet
besides its maturity, is how well it integrates with standard Python code. Any code that uses the built-in
`socket` module can be "monkey-patched" (i.e. modified at runtime) to use the "green" version of the socket
module which allows Eventlet to turn regular ol' Python into code with asynchronous I/O.

The problem with using libraries like Eventlet, is that some Python code just **blocks**, meaning that
code will hit an I/O point and *not* yield but instead block the entire process until that network operation
completes.

In practical terms, imagine you have a web crawler that uses 10 "green threads", each crawling a
different site. The first greenthread (GT1) will send an HTTP request to the first site, then it will yield
to GT2 and so on. If each HTTP request blocks for 100ms, that means when crawling the 10 sites, you're going
to block the whole process, preventing anything from running, for a whole second. Doesn't sound too terrible,
but imagine you've got 1000 greenthreads, instead of everything smoothly yielding from one thread to another
the process will lock up very often resulting in painful slowdowns.


Starting with Eventlet 0.9.10 "blocking detection" code has been incorporated into Eventlet to make
it far easier for developers to find these portions of code that can block the entire process.
<code type="python">
    import eventlet.debug
    eventlet.debug.hub_blocking_detection(True)
</code>

While using the blocking detection is fairly simple, its implementation is a bit "magical" in that
it's not entirely obvious how it works. The detector is built around signals, inside of Eventlet a signal
handler is set up prior to firing some code and then after said code has executed, if a certain time-threshhold
has passed, an alarm is raised dumping a stack trace to the console. I'm not entirely convinced I'm explaining this
appropriately so here's some pseudo-code:

<code type="python">
    def runloop():
        while True:
            signal.alarm(handler, 1)
            execute_next_block()
            if (time.time() - start) < resolution:
                clear_signal() # Clear the signal if we're less than a second, otherwise it will alarm
</code>

The blocking detection is a bit crude and can raise false positives if you have bits of code that churn
the CPU for longer than a second but it has been instrumental in incorporating **non-blocking DNS** support
into Eventlet, which was also introduced in 0.9.10 (ported over from Slide's [gogreen](http://github.com/slideinc/gogreen)
package).



If you are using Eventlet, I highly recommend running your code periodically with blocking detection enabled,
it is an invaluable tool for determining whether you're running as fast and as asynchronous as possible. In my
case, it has been the difference between web services that are fast in development but slow under heavy stress,
and web services that are fast **always** regardless of load.
