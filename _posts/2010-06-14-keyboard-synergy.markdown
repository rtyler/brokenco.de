--- 
layout: post
title: Keyboard Synergy
tags: 
- miscellaneous
- linux
created: 1276533900
---
Over the past year or two I've become quite fond of tiled window managers, the jump to Awesome (which I've [since dropped](http://unethicalblogger.com/posts/2009/07/awesomely_bad)) to [XMonad](http://xmonad.org) was a logical one. My gratuitous use of GNU/screen and [Vim](http://vim.org)'s tabs and split window support, already provided a de-facto tiled window manager within each one of my many terminals. The tiled window manager on top of all those terminals has served to improve my heavily-terminal biased workflow.

One computer has never been enough for me, at the office my work spans three screens and two computers, I've not yet discovered a Thinkpad that can drive three screens alone; at home I typically span three screens and two laptops (let's conveniently ignore the question of *why* I feel I need so much screen real estate).  Tying these setups together I use [synergy](http://synergy2.sourceforge.net) to provide my "software KVM" switch. As long as I've used synergy, I've had to switch from one screen to the other with a mouse, which is one of the **few** reasons I still keep one on the desk.

Until I discovered a way around that, thanks to Jean Richard (a.k.a [geemoo](http://github.com/geemoo)) who posted [this little configuration change](http://geemoo.ca/blog/241/synergy-tricks-switch-screens-with-a-keyboard-shortcut) to `synergy.conf`:

<code type="bash">
section: options
     keystroke(control+alt+l) = switchInDirection(right)
     keystroke(control+alt+h) = switchInDirection(left)
end</code>

With this minor configuration change, combined with XMonad, [Vimium](http://github.com/philc/vimium) (Vim-bindings for Chromium) and my usual bunch of terminal-based applications, I can go *nearly* mouse-less for almost everything I need to do during the day.
