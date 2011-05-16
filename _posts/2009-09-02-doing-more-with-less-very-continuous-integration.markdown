--- 
layout: post
title: "Doing more with less; very continuous integration "
tags: 
- miscellaneous
- software development
- hudson
created: 1251880922
---
Once upon a time I was lucky enough to take an "Intro to C++" 
class taught by none other than 
[Bjarne Stroustrop](http://en.wikipedia.org/wiki/Bjarne_Stroustrup)
himself, while I learned a lot of things about what makes C++ good and sucky 
at the *same* time, he also taught a very important lesson: great engineers are lazy.
It's fairly easy to enumerate functionality in tens of hundreds of lines of poorly
organized, inefficient code, but (according to Bjarne) it's the great engineers
that are capable of distilling that functionality into it's most succinct 
form. I've since taken this notion of being "ultimately lazy" into my 
professional career, making it the root answer for a lot of my design decisions 
and choices: "Why bother writing unit tests?" I'm too lazy to fire up the whole 
application and click mouse buttons, and I can only do that so fast; "Why do you only
work with <a id="aptureLink_qYcERvYA4N" href="http://en.wikipedia.org/wiki/Vim%20%28text%20editor%29">Vim</a> in <a id="aptureLink_m0DuZkisMf" href="http://en.wikipedia.org/wiki/GNU%20Screen">GNU/screen</a>?" I can't be bothered to set up a new slew of terminals 
when I switch machines, and so on down the line.

Earlier this week I found another bit of manual work that **I** shouldn't 
be doing and should be lazy about: building. The local build is something 
that's common to every single software developer regardless of language, Slide being a <a id="aptureLink_dkAoFOcNyd" href="http://en.wikipedia.org/wiki/Python%20%28programming%20language%29">Python</a> shop, 
we have a bit more subtle of a "build", that is to say, developers implicitly 
run a "build" when they hit a page in <a id="aptureLink_FWKNbGJPnm" href="http://en.wikipedia.org/wiki/Apache%20HTTP%20Server">Apache</a> or a test/script. I found myself 
constantly switching between two terminal windows, one with my editor 
([Vim](http://www.vim.org)) and one for running tests and other scripts. 

Being an avid <a id="aptureLink_youtxiRCtA" href="http://twitter.com/hudsonci">Hudson</a> user, I decided I'd give 
the [File system SCM](http://wiki.hudson-ci.org/display/HUDSON/File+System+SCM) 
a try. Very quickly I was able to set up Hudson to poll my working directory and 
*watch* for files to change every minute, and then run a "build" with some tests 
to go with it. Now I can simply sit in Vim **all** day and write code, only 
context-switching to commit changes. 

Setting up Hudson for *local* continuous integration is quite simple, 
by visiting [hudson-ci.org](http://www.hudson-ci.org) you can download 
[hudson.war](http://hudson-ci.org/latest/hudson.war) which is a **fully self contained** 
runnable version of Hudson, you can start it up locally with `java -jar hudson.war`. 
Once it's started, visit [http://localhost:8080](http://localhost:8080) and you've find 
yourself smack-dab in the middle of a fresh installation of Hudson.


First things first, you'll need the File System SCM plugin from the Hudson Update
Center (left side bar, "Manage Hudson" > "Manage Plugins" > "Available" tab)

![Installing the plugin](http://agentdero.cachefly.net/unethicalblogger.com/images/fsscm_updatecenter.jpeg)

After installing the plugin, you'll need to restart Hudson, then you can create your 
job, configuring the File System SCM to poll your working directory:

![Configuring FS SCM](http://agentdero.cachefly.net/unethicalblogger.com/images/fsscm1.jpeg)

Of course, add the necessary build steps to build/test your software as well, and 
you should be set for some good local continuous integration. Once the job is saved, 
the job will
poll your working directory for files to be modified and then copy things over to 
the job's workspace for execution.

After the job is building, you can hook up the RSS feed 
([http://localhost:8080/rssLatest](http://localhost:8080/rssLatest)) to 
<a id="aptureLink_X0ly5HgFWB" href="http://growl.info/">Growl</a> or some 
other form of desktop notifier so you don't even have to move your eyes to know whether 
your local build succeeded or not (I use the "hudsonnotify" script for Linux/libnotify 
below).

By automating this part of my local workflow with Hudson I can take advantage of a few things:

* I no longer need to context switch to run my tests
* I can make use of Hudson's nice UI for visually inspecting test results as they change over time
* I have near-instant feedback on the validity of the changes I'm making

The only real downside I can think of is no longer having any excuse for checking 
in code that "breaks the build", but in the end that's probably a good thing. 

Instead of relying on commits, you can get near-instant feedback on your changes
before you even get things going far enough to check them in, tightening the feedback
loop on your changes even further, very-very continuous integration. Your mileage may 
vary of course, but I recommend giving it a try.


hudsonnotify.py
---------------
<script src="http://gist.github.com/179286.js"></script>

