---
layout: post
title: Considering object-orientedness from the Rust perspective
tags:
- opinion
- rust
- software
- deltalake
---

A very simple question in a community channel earlier this week sent me deep
into reflection on software design. I started writing software as is
classically understood as Object Oriented Programming (OOP), with Java, Python, Ruby,
Smalltalk. Design has been mostly about creating those little boxes that
encapsulate behavior and state: the object. [Rust](https://rust-lang.org) in
contrast I wouldn't describe as an object-oriented programming language, to be
honest I'm not sure what we call it. It's not functional programming and it's
not object-oriented programming as I understand it. It's something else which
is the key to why Rust is so enjoyable.

The simple question from [Mr Powers](https://github.com/mrpowers) was:

> Just noticed an interesting delta-rs / delta-spark difference.  Delta Spark doesn't let you instantiate a Delta Table with a specific table version, but delta-rs does.
>
> * delta-rs: `DeltaTable("../rust/tests/data/simple_table", version=2)`
> * delta-spark: `DeltaTable.forPath(spark, "/path/to/table")`  - no version argument available
>
> Are there any implications of this difference we should think about?

The difference may seem trivial, one appears to have an optional "constructor"
parameter and the other does not, who cares? But that's _not it_.

[Will](https://github.com/wjones127) responded correctly with:

> _I think the distinction to make is that `DeltaTable` represents a table at
some particular time, and not the table in general_


The thing is, I was there when the first API was written. I remember the design
discussions and considerations we evaluated. I didn't catch the subtle change
of thinking that was happening at the time.

When I am working in Ruby or Python, I find myself thinking about how to
represent state and behavior as this black box. "How would I represent this in
a diagram with boxes and arrows?"

Take a filter for example, a filter is almost always just _behavior_ but when I
might design something like that in Ruby or Python, `Filter` becomes a base
class which may or may not end up having state too. The base class becomes the
means for describing "things which behave like this" but the very nature of
defining class implies state.

Most object-oriented languages follow my beloved Smalltalk where everything is
an object which contains both behavior and state, even when that doesn't quite
make metaphorical sense.

Coming back to the question posed.

The reason this simple design difference seems so impactful to me is when I
consider the Spark (Scala) implementation, it's design _bugs me_. It bugs me in
a way that it wouldn't have, prior to starting to use Rust. Delta tables are
constantly evolving as new writes occur, as new transactions are being written
the idea of what the table _is_ also changes with the underlying data. This
is especially the case when a metadata change is committed to the transaction
log. Therefore making an _object_ encapsulate the concept of an ever-changing
Table itself presents this jarring conflict: if I have this object, what is the
actual nature of the object? How does (or does not) this object change over
time?

Writing and reasoning about this, I think I have a better sense of what makes
Rust so pleasing to work with. The ownership model and borrow checker _do_ make
things much easier, but the nature of a program is **not** object-oriented, nor
is it functional, but something else. It accommodates the current reality of
software development which is inherently multi-modal.

At our disposal we have:

* _Functions_ which do things, and can be grouped into modules, etc.
* _Structs_ which contain state, but like objects in other languages can have
associated behaviors. Unlike in those object-oriented languages these cannot be
_extended_. This forces the Rust developer to design structs around the state
first and foremost. We are encouraged to take this data first approach and when
combined with mutability and ownership rules, Rust programs tend to have fewer
large evolving objects or object hierarchies.
* _Traits_ which allow defining behaviors and grouping them in a hierarchy
separated from data and state. This separation allows us to consider behaviors
which might have slight variations but otherwise present a similar interface
such as the filters example that I mentioned above.

I could wax on and on about how important traits are from a design standpoint.
Being able to group and "inherit" behaviors separate from data is liberating.

The mental contortions I found myself doing in a more object-oriented world are
no more. Nor am I going down the "functional programming all the things" rabbit
hole. Rust has a lot of both to offer but I find that its structure has led me
to _better_ designs because it has just the right amount of multiple different
programming models thoughtfully mixed together.

