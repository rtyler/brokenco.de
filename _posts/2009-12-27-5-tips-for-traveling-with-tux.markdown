--- 
layout: post
title: 5 tips for traveling with Tux
tags: 
- opinion
- linux
created: 1261912781
---
After running a <a id="aptureLink_WzTQaeWnm6" href="http://en.wikipedia.org/wiki/Linux%20%28kernel%29">Linux</a> laptop for a number of years and 
having mostly negative travel experiences from messing something up 
along the way, this holiday season I think I've finally figured 
out how to optimally travel with a Linux notebook. The following tips
are some of the lessons I've had to learn the hard way through trial and 
error over the course of countless flights spanning a few years.

### Purchase a small laptop or netbook 

Far and away the best thing I've done for my travel experience thus far 
has been the purchase of my new <a id="aptureLink_uIjthatTxd" href="http://www.amazon.com/gp/product/B002SG7LX8?tag=apture-20">Thinkpad X200</a> (12.1"). My previous laptops include
a <a id="aptureLink_s6vu8e48ui" href="http://en.wikipedia.org/wiki/MacBook%20Pro">MacBook Pro</a> (15"), a <a id="aptureLink_dnFWnkUnhf" href="http://www.youtube.com/watch?v=3jW1LrmqelA">Thinkpad T43</a> (14") and a Thinkpad T64 (14"). Invariably I have
the same problems with all larger laptops, their size is unwieldy in economy class 
and their power consumption usually allows me very little time to get anything done
while up in the air. Being 6'4" and consistently cheap, I'm always in coach, quite 
often on redeye flights where the passenger in front of me invariably leans their 
seat back drastically reducing my ability to open a larger laptop and see the screen. 
With a 12" laptop or a netbook (I've traveled with an <a id="aptureLink_mU2JeNLHtG" href="http://en.wikipedia.org/wiki/ASUS%20Eee%20PC">Eee PC</a> in the past as well) I'm able 
to open the screen enough to see it clearly and actually type comfortbaly on it. Additionally, 
the smaller screen and size of the laptop means less power consumption, allowing me to 
use it for extended periods of time. 


### Use a basic window manager 

Personally, I prefer <a id="aptureLink_M4NdgfWBrW" href="http://en.wikipedia.org/wiki/Xmonad">XMonad</a>, but I believe any simplistic window manager will save
a noticable number of cycles compared to the <a id="aptureLink_HQAAfwpj0K" href="http://en.wikipedia.org/wiki/GNOME">Gnome</a> and <a id="aptureLink_x1OYbfAPbc" href="http://en.wikipedia.org/wiki/KDE">KDE</a> "desktop environments." 
Unlike Gnome, for example, XMonad does not run a number of background daemons to help
provide a "nice" experience in the way of applets, widgets, panels and menus. 


### Disable unneeded services and hardware

Reducing power consumption is a pretty important goal for me while traveling with 
a Linux laptop, I love it when I have sufficient juice to keep myself entertained 
for an entire cross-country flight. Two of the first things I disable before boarding
a plane are Wireless and Bluetooth via the <a id="aptureLink_HGDfMqRe03" href="http://en.wikipedia.org/wiki/NetworkManager">NetworkManager</a> applet that I run. If I'm on a 
redeye, I'll also set my display as dark as possible which not only saves power but also
eye strain. It's also important to make sure your laptop is running its CPU in "power-save"
mode, which means the clockspeed of the chip is reduced, allowing you to save even more power.
Finally I typically take a look at <a id="aptureLink_OHiPMhRsuG" href="http://en.wikipedia.org/wiki/Htop%20%28Unix%29">htop(1)</a> to see if there are any unneeded processes taking 
up cycles/memory that I either don't need or don't intend to use for the flight. The flight
I'm currently on (Miami to San Francisco) I discovered that <a id="aptureLink_O2QBe4kx4C" href="http://en.wikipedia.org/wiki/Google%20Chrome">Chrome</a> was churning some 
unnecessary cycles and killed it (no web browsing on American Airlines).

### Use an external device for music/video

If you're like me, you travel with a good pair of headphones and a desire to not listen
to babies crying on the plane. I find a dedicated device purely for music can help avoid 
wasting power on music since most devices can play for 12-40 hours depending on the device.
It's generally better (in my opinion) to use your $100 iPod for music and your $2000 computer
for computing, that might just be personal bias though.


### Load applications you'll need ahead of time

I generally have an idea of what I want to do before I board a plane, I have a project
that I'd like to spend some time hacking on or something I want to write out or 
experiment with. Having a "game plan" before I get onto the plane means I can load up
any and all applications while plugged in at the airport. This might be a minor power 
saver but after I've lowered the CPU clockspeed and disabled some services, I certainly
don't want to wait around for applications to load up while I sit idly in coach.


**Update**: As [Etni3s](http://www.reddit.com/user/Etni3s) from reddit points out, <a id="aptureLink_i5FkxIYBZk" href="http://en.wikipedia.org/wiki/PowerTOP">powertop(1)</a> is a pretty handy utility for watching power consumption.


As I write this article, I'm probably an hour into my five and half hour flight and the 
battery monitor for my X200 is telling me I have an estimated **eight** hours of juice 
left. 

I'm proud to say, Tux is my copilot.
