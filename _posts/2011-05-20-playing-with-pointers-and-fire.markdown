---
layout: post
title: Playing with pointers, and fire
tags:
- software development
- lookout
- c
- ada
---


It is a little (unknown) fact that my first job as a software developer was
writing C code, for the [network group](http://nis.tamu.edu/) at [Texas A&M
University](http://www.tamu.edu). Like most student developers, my work never
saw the light of day, mostly because I never finished it, but I did learn an
incredible amount working on my little project made for one.

I had never expected that 6 years later in my career, I'd somehow still be
dealing with some of the same issues, in the same crusty 30 year old language:
C. I feel I should note that every job that I've ever had, except *one*,
involved writing C code at some point, odd.

<img src="/images/kitty_failure.jpg" alt="Lolcat smashes heap" title="Lolcat
smashes heap" align="right" width="170"/>
To be honest I'm both surprised and irritated by C's longevity as a systems
language.  When I scan the landscape for the titans of modern web software I
see it *everywhere*. [Redis](http://www.redis.io),
[Nginx](http://www.nginx.org), [Python](http://www.python.org),
[Ruby](http://www.ruby-lang.org), [MySQL](http://dev.mysql.com),
[Apache](http://httpd.apache.org), [HAProxy](http://haproxy.1wt.eu/) and the
list goes on and on. Don't get me wrong, C is a very fast and suitable tool to
build all these services, it's just so damn ***dangerous*** that I'm shocked
how much it's still used.

My mind immediately goes to [this
study](http://archive.adaic.com/intro/ada-vs-c/cada_art.html) that I had read
at some point regarding comparisons of development costs and defect rates
between *very* similar C and Ada projects. While the study is almost as old as
I am, it strikes a chord with me every time I am working on some C-based
projects.

Take [this code](https://github.com/antirez/redis/blob/unstable/src/sds.c) from
the Redis code base for
example, which I recently had the pleasure of working with. I am aware that
[Salvatore](https://github.com/antirez) is a brilliant hacker but this is
*madness*. If you cannot easily grok the code, I'll clarify what this tiny
library does: in order to provide dynamically sizable strings in C, this code
will allocate a block of memory for a string that looks like this:

    0               9           N
    +---------------------------+
    | struct sdshdr |  char *   |
    +---------------------------+

A little goofy, but easy to understand and deal with. *Except* for the fact that
the pointer that is passed around is to address `9` instead of `0`, meaning all
operations that work with the entire block perform pointer arithmetic to
calculate the appropriate starting address for the block. For example, here's
the `sdsfree` implementation:

{% highlight c %}
   void sdsfree(sds s) { /* sds == char * */
        free(s - sizeof(struct sdshdr));
   }
{% endhighlight %}

I have two reasons for picking on this specific code, and they were both in the
form of gnarly core dumps I've spent resolving the past couple days. If at
**any point** in your program you or anybody else accidentally passes a `char*`
into *any* of these SDS functions, your program will crash and there's nothing
your compiler can do to save you from this. Since the `sds` is a `typedef` of
`char*` not only will you never see any compiler warnings, you won't see any
warnings from static analysis tools either.


I've heard people say that one of the problems with C++ is that it gives you
too much rope with which to hang yourself. If that's the case, C not only gives
the the rope but double-dog dares you to try to hang yourself with it.

Perhaps in another post I'll detail how pointers and types are handled in Ada,
which I think is a major improvement of the C model without sacrificing speed.
I don't mean to imply that everything that is written in C should *really* be
written in Ada, I just find the language's solution to this problem to be
interesting. Instead of Ada, pick Java, Python, Scala, Ruby, D or any other
language that's been developed in the post-K&R world, they all have built on
top of the lessons learned from C's short-comings.

It's been almost 40 years since C was first introduced; that's over two or three
generations of programmers hanging themselves.


---
*Disclaimer:* I actually *like* working on projects in C, it's always an
interesting challenge, like starting arguments with my wife I have no chance of
winning.

---

