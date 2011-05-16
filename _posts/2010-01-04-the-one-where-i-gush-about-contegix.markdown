--- 
layout: post
title: The one where I gush about Contegix.
tags: 
- opinion
created: 1262676580
---
Since joining <a id="aptureLink_qcOCk4yKQf" href="http://twitter.com/apture">Apture</a>, I've primarily concerned myself with lower-level backend code and services, including the machines that our site runs on. While not a drastic departure from my role on the server team at <a id="aptureLink_hpa0Flz94r" href="http://twitter.com/slideinc">Slide</a>, there are a few notable changes, the largest of which being **root**. Given the size of Slide's operations team, a team separate from the "server team" (the latter being developers), my role did not necessitate server management only occasional monitoring. Apture is a different can of beans, we're simply too small for an operations team, so we work with <a id="aptureLink_YQWxfVXHgd" href="http://twitter.com/contegix">Contegix</a> to maintain a constant watchful eye on our production environment. Self-assigning myself the "backend guy" hat means server maintenance and operations are part of my concern (but not my focus) since the "goings on" of the physical machines will have a direct impact on the performance and level of service my work can ultimately provide to end users.

Last week while planning some changes we can make to our <a id="aptureLink_vcR6DUxFQW" href="http://en.wikipedia.org/wiki/Django%20%28web%20framework%29">Django</a>-based production environment that will help us grow more effectively, <a id="aptureLink_IES2CuBriY" href="http://twitter.com/kansteven">Steven</a> pointed out that we were going to see an influx of usage today (Jan. 4th) given the large number of users returning to the internet after their holiday vacation. Over the weekend I dreaded what Monday would bring, unable to enact any changes to stave off the inevitable in time.

This morning, waking up uncharacteristically early at 7 a.m. PST, bells were already ringing. A 9 a.m. EST spike angered one of our database machines, by the time I got in the office around 8:10 a.m. PST more bells were ringing as the second wave of users once again angered the <a id="aptureLink_rBdEmXeIf7" href="http://en.wikipedia.org/wiki/MySQL">MySQL</a> Dolphin Gods. With my morning interview candidate already on site, I furiously typed off a few emails to Contegix sounding the alarm, pleading for help, load balancer tweaks, configuration reviews, anything to help squeeze extra juice from the abnormally overloaded machines to keep our desired level of service up. Working with a few of the talented Contegix admins we quickly fixed some issues with the load balancer under utilizing certain machines in favor of others, isolated a few sources of leaked CPU cycles and discovered a few key places to add more caching with <a id="aptureLink_f7slXLd6zw" href="http://en.wikipedia.org/wiki/memcached">memcached(8)</a>.

As our normal peak (~9 a.m. PST to around lunchtime) passed, I started to breathe easier when alarms went of **again**. Once again, Contegix admins were right there to help us through one of our longest peak I've seen since joining Apture, 5:30 a.m. until around 4 p.m.

Survival was my primary objective waking up today but thanks to some initiative and good footwork by the folks at Contegix we not only survived but identified and corrected a number of issues detrimental to performance **and** discovered on of the key catalysts of cascading load: I/O strapped database servers (as MySQL servers starve for disk I/O, waiting requests in Apache drive the load on a machine through the roof).

I am admittedly quite smitten with Contegix's work today, I became quite accustomed to <a id="aptureLink_vi7LWqRoql" href="http://www.linkedin.com/pub/ken-brownfield/2/b0/b49">KB</a> and his ops team at Slide fixing whatever issues would arise in our production environment and it's comforting to know that we have that level of sysadmin talent at the ready.


*A picture is worth a thousand words; here's a cumulative load graph from our production <a id="aptureLink_K9W5xziPLP" href="http://ganglia.info/">Ganglia</a> instance:*
<img width="700"  src="http://agentdero.cachefly.net/unethicalblogger.com/images/todays_load.png"/>
