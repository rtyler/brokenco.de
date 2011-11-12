---
layout: post
title: IO#popen can suck it
tags:
- ruby
- programming
- opinion
- wtf
---

[J&oslash;rgen](https://twitter.com/jorgenpt/) pointed out that there's no real
compelling reason to use `IO#popen` over a combo of `Open3#popen3` and
`IO#select`. That said, `Open3#popen3` is practically as brain-dead in 1.8 as
`IO#popen` is. Regardless, I'm not going to let that get in the way of a good cathartic rant (the changes in 1.9 are pretty sweet though).

----

For better or worse, [Lookout](http://www.mylookout.com/about/jobs) has
standardized on Ruby 1.8 in which I've discovered one absolutely *infuriating*
"quirk" with how `IO#popen` handles pipe redirection and spawning processes. A
"quirk" that has managed to screw me in more than two projects thus far. While
the issue affects both Ruby 1.8 and Ruby 1.9, there is no work-around in Ruby
1.8, which is especially frustrating.


When you execute `IO#popen`, you receive an `IO` object which implements some
methods which allow you to read `stdout` from the child process. Pretty
reasonable, sort of I guess, except that the new child process inherits the
parent's `stderr` pipe. From the process table point of view, you will see
exactly what you expect:

    3046 pts/7    Ss     0:00 ruby demo.rb
    9521 pts/7    R+     0:00  \_ run_daemon -f some.conf --verbose


Naturally you might want to redirect _all_ the pipes in order to segment
the output of the spawned child process from the parent process. If you want to
separate them, i.e. a `child_stdout` and a `child_stderr` pipe, then the
[Open3#popen3](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/open3/rdoc/Open3.html#method-c-popen3)
has you covered.

What if you want to *combine* the two pipes (!) for reading inside of your
parent process? If for example, you're wrapping a process and running
particular code depending on the collective output of the subprocess.

`IO#popen` can do this with the magical "2>&1" token in your
command, e.g.:

    def spawn_and_watch
      @child = IO.popen("run_daemon -f some.conf --verbose 2>&1")

      Thread.new do
        while @child.gets |line| do
          # do magic
        end
      end
    end

So that's pretty disgusting just from the code standpoint. What's even **more**
disgusting about this is what happens underneath the hood when you add the
"2>&1" token into the command:

    3046 pts/7    Ss     0:00 ruby demo.rb
    9521 pts/7    R+     0:00  \_ sh -c run_daemon -f some.conf --verbose 2>&1
    9522 pts/7    R+     0:00      \_ run_daemon -f some.conf --verbose


Subtle isn't it?

<center><img
src="http://agentdero.cachefly.net/unethicalblogger.com/images/ohshit.jpg"
alt="oh shit"/></center>


This has wide-reaching consequences for the caller of
`IO#popen`, the returned `IO` object inside of my make believe
`spawn_and_watch` method has the `pid` of the `sh` executable. On top of that,
to the best of my knowledge there is no way to actually get a handle on the
`run_daemon` process ID that is now a grand-child process of `ruby demo.rb`. If
I do something as foolish as call: `Process.kill("TERM", @child.pid)` then I
will orphan my *actual process* and not get anything close to my desired
behavior.

Basically, using "2>&1" with `IO#popen` is only good if you want to orphan
processes, and prevent yourself from ever being able to send any signals to the
process you want. This handling of commands passed to `IO#popen` with the
"2>&1" token is consistent(ly bad) in both Ruby 1.8 and Ruby 1.9.

Fortunately for those using Ruby 1.9, you can work-around this behavior by
changing the above method to look like this:

    def spawn_and_watch
      @child = IO.popen(["run_daemon", "-f", "some.conf", "--verbose",
                                    :err => [:child, :out]])
      # ...
    end

It is because of this behavior alone that I have switched some personal
projects to default to Ruby 1.9.2 and above, which is nuts.

