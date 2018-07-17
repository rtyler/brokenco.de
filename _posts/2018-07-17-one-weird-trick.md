---
layout: post
title: "Navigating Linux/BSD in the newer Open File dialog"
tags:
- linux
---

With the latest (quantum!) releases of Firefox, a number of things changed for
the better but one of the few things that seemed to get _worse_ was the Open
File dialog. I tend to use the dialog quite frequently to open up HTML generated reports from test and coverage tooling, and with the newer Firefox versions I had become very frustrated with the mouse-heavy requirements to use the dialog.

![Open File Dialog Search](/images/post-images/open-file-dialog/open-file-search.png)

I have since learned that this is a Gtk+ 3.x dialog, which is changed the
default behavior for handling key strokes to use **search** rather than
entering in of a path. 

I abhor using the trackpad on my laptop, which makes me feel like an old
"hunt-and-peck" typist, and instead rely on a number of keyboard-heavy tools to
navigate quickly and efficiently around web pages, terminals, and editors.

While waiting for a build to complete earlier today, I was frustrated enough to scour the internet for a potential solution and happened upon [this blog post](https://winaero.com/blog/how-to-enter-file-location-manually-in-gtk-3-opensave-dialog) which contained a suitable workaround!

**Ctrl+L** in the Open File dialog will display a text field where the surly
keyboard-heavy user can simply type in a relative, or absolute, path followed
by _Enter_ and navigate immediately to that directory or file.

![Open File Dialog Search](/images/post-images/open-file-dialog/open-file-direct-navigate.png)


Much better!
