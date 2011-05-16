--- 
layout: post
title: "Pyrage: Static isn't just something on the radio"
tags: 
- opinion
- software development
- python
created: 1267191900
---
Dealing with statics in Python is something that has bitten me enough times that I have become quite pedantic about them when I see them. I'm sure you're thinking "But Dr. Tyler, Python is a *dynamic* language!", it is indeed, but that does not mean there aren't static variables.

The funny thing about static variables in Python, in my opinion, once you understand a bit about scoping and what you're dealing with, it makes far more sense. Let's take this static class variable for example:

<code lang="python">>>> class Foo(object):
...   my_list = []
... 
>>> f = Foo()
>>> b = Foo()</code>

You're trying to be clever, defining your class variables with their default variables outside of your `__init__` function, understandable, unless you ever intend on **mutating** that variable.
<code lang="python">>>> f.my_list.append('O HAI')
>>> print b.my_list
['O HAI']
>>> </code>

Still feeling clever? If that's what you *wanted*, I bet you do, but if you wanted each class to have its own internal list you've inadvertantly introduced a bug where *any* and *every* time something mutates `my_list`, it will change for every single instance of `Foo`. The reason that this occurs is because `my_list` is tied to the class object `Foo` and not the **instance** of the `Foo` object (`f` or `b`). In effect `f.__class__.my_list` and `b.__class__.my_list` are the same object, in fact, the `__class__` objects of both those instances is the same as well. <code lang="python">>>> id(f.__class__)
7680112
>>> id(b.__class__)
7680112</code>


<br clear="all"/>
When using default/optional parameters for methods you can also run afoul of statics in Python, for example:<code lang="python">>>> def somefunc(data=[]):
...    data.append(1)
...    print ('data', data)
... 
>>> somefunc()
('data', [1])
>>> somefunc()
('data', [1, 1])
>>> somefunc()
('data', [1, 1, 1])
>>> </code>

This comes down to a scoping issue as well, functions and methods in Python are first-class objects. In this case, you're adding the variable `data` to the `somefunc.func_defaults` tuple, which is being mutated when the function is being called. Bad programmer!


It all seems simple enough, but I still consistently see these mistakes in plenty of different Python projects (both pony-affiliated, and not). When these bugs strike they're difficult to spot, frustrating to deal with ("who the hell is changing my variable!") and most importantly, easily prevented with a little understanding of how Python scoping works.

PYRAGE!
<!--break-->
