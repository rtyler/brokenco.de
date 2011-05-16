--- 
layout: post
title: GNU/Parallel changed my life
tags: 
- Software Development
- Linux
created: 1289497712
---
<a href="http://www.flickr.com/photos/agentdero/5082431682/" title="The @Apture Elephants by agentdero, on Flickr"><img src="http://farm5.static.flickr.com/4025/5082431682_0fef51e059_m.jpg" width="240" height="180" alt="The @Apture Elephants" align="right" /></a>

Over the past month or so I've fallen in love with an incredibly simple command line tool: [GNU/Parallel](http://www.gnu.org/software/parallel/). Parallel has more or less replaced my use of [xargs](https://secure.wikimedia.org/wikipedia/en/wiki/xargs) when piping data around on the many machines that I use. 
Unlike `xargs` however, Parallel lets me make use of the **many** cores that I have access to, either on my laptop or the many quad and octocore machines we have lying around the [Apture](http://twitter.com/apture) office.


Using Parallel is *incredibly* easy, in fact the [docs](http://savannah.gnu.org/projects/parallel/) enumerate just about every possible incantation of Parallel you might want to use, but starting simple you can just pipe stuff to it:


> `cat listofthings.txt | parallel --max-procs=8 --group 'echo "Thing: {}"'`

The command above will run at most eight concurrent processes and group the output of each of the processes when the entire thing completes, simple and in this case not too much different than running with `xargs`


With some simple Python scripting, Parallel becomes infinitely more useful:

> `python generatelist.py | parallel --max-procs=8 --group 'wget "{}"  -O - | python processpage.py'`


There's not really a whole lot say about GNU/Parallel other than **you should use it**. I find myself increasingly impatient when a single process takes longer than a couple minutes to complete, so I've been using GNU/Parallel in more and more different ways across almost all the machines that I work on to make things *faster* and *faster*. So much so that I've started to pine for a quad-core notebook instead of this weak dual core Thinkpad of mine :)



### GNU/Parallel Demo

<center><object width="560" height="340"><param name="movie" value="http://www.youtube.com/v/OpaiGYxkSuQ?fs=1&amp;hl=en_US"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/OpaiGYxkSuQ?fs=1&amp;hl=en_US" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="560" height="340"></embed></object></center>
