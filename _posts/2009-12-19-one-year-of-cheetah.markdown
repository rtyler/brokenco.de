--- 
layout: post
title: One year of Cheetah
tags: 
- software development
- cheetah
- python
nodeid: 245
created: 1261271089
---
While working at <a id="aptureLink_yEeNgnHrmv" href="http://twitter.com/slideinc">Slide</a> I had a tendency to self-assign major projects, 
not content with things being "good-enough" I tended to push and over-extend 
myself to improve the state of Slide Engineering. Sometimes these projects 
would fail and I would get uncomfortably close to burning myself out, other times, 
such as the migration from <a id="aptureLink_RiTUKpPp5v" href="http://www.unethicalblogger.com/posts/2008/11/delightfully_wrong_about_git">Subversion to Git</a>, turned out to be incredibly rewarding 
and netted noticable improvements in our workflow as a company. 

One of my very first major projects was upgrading our installation of <a id="aptureLink_uxR2vwVN22" href="http://en.wikipedia.org/wiki/CheetahTemplate">Cheetah</a> from 1.0 to 
2.0, at the time I vigorously *hated* Cheetah. My distain of the templating system stemmed 
from using a three year old version (that sucked to begin with) and our usage of Cheetah which
bordered between "hackish" and "vomitable." At this point in Slide's history, the growth of 
the Facebook applications meant there was going to be far less focus on the Slide.com codebase 
which is where some of the more egregious Cheetah code lived; worth noting that I never "officially"
worked on the Slide.com codebase. When I successfully convinced <a id="aptureLink_hqxRXAFs0S" href="http://twitter.com/jerobi">Jeremiah</a> and <a id="aptureLink_MaZ97GDvZ4" href="http://www.linkedin.com/pub/ken-brownfield/2/b0/b49">KB</a> that it was worth 
my time and some of their time to upgrade to Cheetah 2.0 which offered a number of improvements 
that we could make use of, I still held some pretty vigorous hatred towards Cheetah. My attitude was 
simple though, temporary pain on my part would alleviate pain inflicted on the rest of the engineering
team further down the line. Thanks to fantastic QA by Ruben and Sunil, the Cheetah upgrade went down 
relatively issue free, things were looking fine in production and everybody went back to their 
regularly scheduled work.

Months went by without me thinking of Cheetah too much until late 2008, Slide continued to write
front-end code using Cheetah and developers continued to grumble about it. Frustrated by the 
lack of development on the project, I did the unthinkable, I started fixing it. Over the Christmas 
break, I used <a id="aptureLink_rIMU5Wn8T7" href="http://www.kernel.org/pub/software/scm/git/docs/git-cvsimport.html">git-cvsimport(1)</a> to create a git repository from the Cheetah CVS repo hosted with 
<a id="aptureLink_mPIIeTpoJW" href="http://www.crunchbase.com/company/sourceforge">SourceForge</a> and I started applying patches that had circulated on the mailing list. By mid-March 
I had a number of changes and improvements in my fork of Cheetah and I released "Community 
Cheetah". Without project administrator privileges on SourceForge, I didn't have much of a choice 
but to publish a fork on <a id="aptureLink_1h1STzYjMV" href="http://www.crunchbase.com/company/github">GitHub</a>. Eventually I was able to get a hold of <a id="aptureLink_295JgMxNNc" href="http://www.linkedin.com/pub/tavis-rudd/3/207/817">Tavis Rudd</a>, the original 
author of Cheetah who had no problem allowing me to become the maintainer of Cheetah proper, 
in a matter of months I had gone from hating Cheetah to fulfilling the oft touted saying "it's 
open source, fix it!" What was I thinking.

Thanks in part to git and GitHub's collaborative/distributed development model patches started to 
come in and the Cheetah community for all intents and purposes "woke up." Over the course of the 
past year, Cheetah has seen an amazing number of improvements, bugfixes and releases. Cheetah now 
properly supports unicode throughout the system, supports @staticmethod and @classmethod decorators, 
supports use with Django and now supports Windows as a "first-class citizen". While I committed
the majority of the fixes to Cheetah, five other developers contributed fixes:

* <a id="aptureLink_M6cwowbGDF" href="http://www.linkedin.com/in/jbquenot">Jean-Baptiste Quenot</a> (unicode fixes)
* <a id="aptureLink_wmWMUg3S3M" href="http://fedoraproject.org/wiki/MikeBonnet">Mike Bonnet</a> (unicode fixes, test fixes)
* <a id="aptureLink_rENnnWb3Pw" href="http://www.linkedin.com/pub/james-abbatiello/2/589/421">James Abbatiello</a> (Windows support)
* <a id="aptureLink_sQvNrSWDj6" href="http://github.com/arunk">Arun Kumar</a>
* Doug Knight (fixes for #raw directive)

In 2008, Cheetah saw 7 commits and 0 releases, while 2009 brought 342 commits and 10 releases; 
something I'm particularly proud of. Unforunately since I've left Slide, I no longer use Cheetah 
in a professional context but I still find it tremendously useful for some of my personal projects. 

I am looking forward to what 2010 will bring for the Cheetah project, which started in mid-2001 and has 
seen continued development since thanks to a number of contributors over the years. 
