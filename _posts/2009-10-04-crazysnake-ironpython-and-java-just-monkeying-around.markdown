--- 
layout: post
title: Crazysnake; IronPython and Java, just monkeying around
tags: 
- Mono
- Miscellaneous
created: 1254722459
---
This weekend I finally got around to downloading <a id="aptureLink_8B5qEjVCfb" href="http://en.wikipedia.org/wiki/IronPython">IronPython</a> 2.6rc1 to test it against the upcoming builds of <a id="aptureLink_fepi2zTpCR" href="http://en.wikipedia.org/wiki/Mono%20%28software%29">Mono</a> 2.6 preview 1 (the version numbers matched, it felt right). Additionally in the land of Mono, I've been toying around with the IKVM project as of late, as a means of bringing some legacy Java code that I'm familiar with onto the CLR. As I poked in one xterm (urxvt actually) with <a id="aptureLink_myJp30086o" href="http://en.wikipedia.org/wiki/IKVM">IKVM</a> and with IronPython in another, a lightbulb went off. What if I could mix *different* languages in the **same** runtime; wouldn't that just be cool as a cucumber? Turns out, **it is**.

After grabbing a recent release (0.40.0.1) of IKVM, I whipped up a simple Test.java file: 
<script src="http://gist.github.com/201908.js"><noscript>See <a href="http://gist.github.com/201908">gist #201908</a></noscript></script>

I compiled Test.java to Test.class then to Test.dll with ikvmc (note: this is using JDK 1.6); in short, Java was compiled to Java bytecode and *then* to <a id="aptureLink_jrzlVfjMcv" href="http://en.wikipedia.org/wiki/Common%20Intermediate%20Language">CIL</a>:

    javac Test.java
    mono ikvm-0.40.0.1/bin/ikvmc.exe -target:library -out:Test.dll Test.class

Once you have a DLL, it is fairly simple to import that into an IronPython script thanks to the `clr` module IronPython provides. It is important to note however, that IKVM generated DLLs *will* try to load other DLLs at runtime (`IKVM.Runtime.dll` for example) so these either need to be installed in the <a id="aptureLink_1XlShjCjqK" href="http://en.wikipedia.org/wiki/Global%20Assembly%20Cache">GAC</a> or available in the directory your IronPython script is running in.

Here's my sample test IronPython file, using the unittest module to verify that the compiled Java code is doing what I expect it to:
<script src="http://gist.github.com/201909.js"><noscript>See <a href="http://gist.github.com/201909">gist #201909</a></noscript></script>

When I run the IronPython script, everything "just works":

    % mono IronPython-2.6/ipy.exe IkvmTest.py  
    .
    ----------------------------------------------------------------------
    Ran 1 test in 0.040s

    OK
    % 

While my Test.java is a fairly tame example of what is going on here, the underlying lesson is an important one. Thanks to the Mono project's CLR and the advent of the DLR on top of that we are getting closer to where "language" and "runtime" are separated enough to not be interdependent (as it is with <a id="aptureLink_YUpwTYkk3D" href="http://en.wikipedia.org/wiki/CPython">CPython</a>), allowing me (or you) to compile or otherwise execute code written in multiple languages on a common (language) runtime.

That just feels good.
<!--break-->
