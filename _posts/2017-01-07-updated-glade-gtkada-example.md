---
layout: post
title: "Using Glade3 with GtkAda"
tags:
- ada
- gtk
- glade
- gtkada
---


I have been a hobby hacker for my entire adult life, and a bit before that too.
When your profession is making software, or even making open source software,
the joy from hobby-hacking can diminish or even disappear. One of the things I
learned from [burning out](/2015/11/10/choose-happiness.html) was that, if I am
going to continue to enjoy hacking as a personal hobby, I would need to pursue
"frivolous hacking."


*Frivolous hacking*:

> Hacking on something for no practical or otherwise useful reason.

Late last week I was struck with the desire to play around with
[GtkAda](https://libre.adacore.com/tools/gtkada/). Ada has [long been a hobby
language](/2010/12/06/ada-surely-you-jest-mr-pythonman.html) for me, but I have
never gotten the desire to make a GUI-based application. For this weekend's
_frivolous hacking_, I created [arun](https://github.com/berriedale/arun) a
simple Ada Command Runner with GtkAda and [Glade 3](https://glade.gnome.org/).

![Arun](https://github.com/berriedale/arun/blob/master/screenshot.png?raw=true)

---

The primary reason to use Glade, in my opinion, is that it's 2017 and
hand-coding interface components is beyond tedious. At a high level, Glade
provides a WYSIWYG approach for defining the various interface components a
program requires, exports that as an XML file which can later be loaded by the
program at runtime.

![Glade3 for arun](/images/post-images/glade3-gtkada/glade3-arun.png)

### Prerequisites

My first attempt relied on using the Glade3 and GtkAda packages which exist for
Debian-based systems. Unfortunately `libgtkada2.24.4-dev` binds to Gtk+ version
2, rather than Gtk+ version 3, which Glade3 targets.

Instead of native packages, you can also [download GtkAda from
AdaCore](http://libre.adacore.com) directly. Opting for this route I was
disappointed to learn that the file named `gtkada-gpl-2016-x86_64-linux-bin.tar.gz`
isn't actually a set of binaries but just a source tarball which must be built
and installed. At first, [that didn't work for me
either](https://github.com/AdaCore/gtkada/issues/7#issue-199381675)! A bug in
that source tarball leaves a user like me with one of two options:

1. Configure the installation with `./configure --with-GL=no`
1. Grab the latest (`fc8b2f9` at this time) from GitHub: `git://github.com/AdaCore/GtkAda.git`

I opted for the latter and within short order (`make -j4`!) I had fresh
installation of GtkAda on my system.

### Writing an app

Fortunately the [Ada DK wiki](http://wiki.ada-dk.org/start) has an example I
could start from, which covers the [basics of building a GUI with Glade3 in
GtkAda](http://wiki.ada-dk.org/building_gui_with_glade_3). After cribbing some
Ada code from the wiki page, I found another stumbling block, it wouldn't
compile.

Turns out some APIs had changed since the page was originally written, but as
luck would have it [Stack Overflow had the
answer](https://stackoverflow.com/a/17029228).


Without going into too much detail on how to use GtkAda,
[this
version](https://github.com/berriedale/arun/commit/35b17986d4adb45ed91f8ecfc94f37f846f5a59e#diff-84ad0731ead1a1baefde1c6df1194789)
of the `Arun.Main` procedure demonstrates a basic version of loading and
starting a Glade3-based GtkAda app:

```
Gtk.Main.Init;
Gtk_New (Builder);

-- Load `arun.glade` which contains the interface definition
Return_Code := Add_From_File (Builder  => Builder,
                              Filename => "arun.glade",
                              Error    => Error'Access);

if Error /= null then
   Put_Line ("Error : " & Get_Message (Error));
   Error_Free (Error);
   return;
end if;

-- Register a signal handler for when
-- the "Main_Quit" signal is fired
Register_Handler (Builder      => Builder,
                  Handler_Name => "Main_Quit",
                  Handler      => Arun.Handlers.Quit'Access);

Do_Connect (Builder);

-- Get the Gtk_Widget object from the Gtkada.Builder API
-- for our commandWindow so it will be shown.
Gtk.Widget.Show_All (
    Gtk_Widget (Gtkada.Builder.Get_Object (Builder, "commandWindow")));

Gtk.Main.Main;
Unref (Builder);
```

With the `arun` binary compiled, I decided to try it out:

```
obj % ./arun
Starting arun
Error : Failed to open file 'arun.glade': No such file or directory
obj %
```

As one might expect, there is a downside to loading files at executable
runtime.

Another [Stack Overflow answer](http://stackoverflow.com/a/28876764) introduced me
to the `glib-compile-resources` executable, which provides the solution
for loading the `.glade` file at runtime in a more portable way. Instead of
referring to a `.glade` file, `glib-compile-resources` creates a C file which
can be compiled and linked into the application. Of course, this adds some more
build-time complexity, as `glib-compile-resources` needs to be called, the C
file needs to be compiled, and then the object file must be linked into the
resulting binary.

With the Makefile put together, instead of `Add_From_File` the application uses
`Add_From_Resource` as is demonstrated in [this commit](https://github.com/berriedale/arun/commit/5bf248399355582af49e83e59199fcb985210137).
With a resource the binary can then be distributed without the `.glade` file:

```
obj % ./arun
Starting arun
Searching for x
Searching for xeye
Searching for xeyes
Looking for an executable in /home/tyler/.rvm/gems/ruby-2.1.5/bin
Looking for an executable in /home/tyler/.rvm/gems/ruby-2.1.5@global/bin
Looking for an executable in /home/tyler/.rvm/rubies/ruby-2.1.5/bin
Looking for an executable in /home/tyler/bin
Looking for an executable in /home/tyler/scratch/bin
Looking for an executable in /home/tyler/.rvm/bin
Looking for an executable in /home/tyler/scratch/node_modules/.bin
Looking for an executable in /home/tyler/scratch/ada/gnat-gpl-2016-x86_64-linux-bin/bin
Looking for an executable in /home/tyler/scratch/ada/spark-gpl-2016-x86_64-linux-bin/bin
Looking for an executable in /home/tyler/bin
Looking for an executable in /usr/local/bin
Looking for an executable in /usr/bin
Found executable at /usr/bin/xeyes
Should Execute: xeyes
Spawning /usr/bin/xeyes
obj %
```

Suffice it to say, using GtkAda isn't _difficult_ per se, it's only difficult
to use when there are toolchain specific idiosyncrasies that are hard to
Google. Aside from that challenge, I far prefer writing GtkAda rather than
"pure" Gtk+ with C or C++.

Of course I don't expect anybody else to find my code useful, nor do I have
lofty ambitions about it, thereby meeting my "frivolous hacking" requirement!


