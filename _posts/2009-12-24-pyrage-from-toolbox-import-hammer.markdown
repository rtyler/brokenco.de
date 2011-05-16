--- 
layout: post
title: "Pyrage: from toolbox import hammer"
tags: 
- Opinion
- Software Development
- Python
created: 1261643006
---
Those that have worked with my directly know I'm a *tad* 
obsessive when it comes to imports in <a id="aptureLink_leGNqOLSuI" href="http://en.wikipedia.org/wiki/Python%20%28programming%20language%29">Python</a>. Once upon a 
time I had to write some pretty disgusting import hooks 
to solve a problem and got to learn first-hand how gnarly 
Python's import subsystem can be. I have a couple coding 
conventions that I follow when I'm writing Python for my 
own personal projects that typically follows:

* "strict" system imports first (i.e. `import time`) 
* "from" system imports second (i.e. `from eventlet import api`)
* "local" imports (`import mymodule`)
* local "from" imports (`from mypackage import module`)

In all of these sections, I like to list things alphabetically 
as well, just to make sure that at no point are modules ever
doubley-imported. This results in code that looks clean (in 
my humblest of opinions):
<code type="python">
    #!/usr/bin/env python
    import os
    import sys
    from eventlet import api

    import app.util
    from app.models import account

    ## Etc.</code>

A module importing habit that absolutely drives me up the wall, 
I was introduced to and told "don't-do-that" by <a id="aptureLink_9aD3KAbJCx" href="http://twitter.com/stuffonfire">Dave</a>: importing 
symbols from modules; in effect: `from MySQLdb import IntegrityError`.
I have two major reasons for hating the importing of symbols, the 
first one is that it messes with your module's namespace. If the 
symbol import above were in a file called "foo.py", the `foo` module
would then have the member `foo.IntegrityError`. Additionally, it 
makes the code more difficult to understand when you flatten the module's
namespace out; 500 lines down in the file if you see `acct_m = AccountManager()` 
as a developer new to the file you'll have to go up to the top and figure 
out where the hell `AccountManager` is actually coming from to understand 
how it works.

As code with these sort of symbol-level imports ages, it becomes more and more 
frustrating to deal with, if I need `OperationalError` in my module now I have 
three options:

* Update the line to say: `from MySQLdb import IntegrityError, OperationalError`
* Add `import MySQLdb` and just refer to `IntegrityError` and `MySQLdb.OperationalError`
* Add `import MySQLdb` and update all references to `IntegrityError`

I've seen code in open source projects that have abused the symbol imports 
so badly that an import statement look like: `from mod import CONST1, CONST2, CONST3, SomeError, AnotherClass`
(ad infinium). 

I think poor import style is a good indicator of how one can expect the 
rest of the Python code to look, I cannot recall a single instance where I've
looked at a Python module with gross import statements and clean classes and functions.
<code type="python">
    from MySQLdb import IntegrityError, OperationalError, MySQLError, ProgrammingError, \
    NotSupportedError, InternalError</code>

PYRAGE!
<!--break-->
