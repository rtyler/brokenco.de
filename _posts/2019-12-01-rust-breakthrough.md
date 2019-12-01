---
layout: post
title: "Finally understanding Rust"
tags:
- programming
- rust
---

This year I have been struggling to learn [Rust](https://rust-lang.org), but I am now pleased
to share that I'm _finally_ understanding the language. [Earlier](/2019/04/02/struggling-with-rust.html) I lamented the challenges of
adopting Rust. Between semantically important apostrophes and
angle-brackets a plenty, I was struggling to read and write basic Rust.
I can easily read Ada, C, Python, JavaScript, Java, and Ruby. Something about
the syntax of Rust remained difficult to process. The code looked jarring and
dissonant, I could read snippets but translating entire functions or modules
into a workable mental model was not feasible. Over the past month however, I
believe I have made some progress up the learning curve. I can now write
some Rust!

Getting over the hump required more effort than I had hoped, but after some small practice exercises I had the confidence and skills to move on to less trivial Rust.
I am not one for solving [Project
Euler](https://projecteuler.net/) problems but instead I focused on porting
little utilities which I regularly use in my local environment. The
main educational benefit of these utilities is that none of them required network I/O, which is
what always really interests me about writing software. Instead these utilities
have very fixed inputs and outputs.  A small well-understood problem domain
made it **much** easier for me to clear my head and focus on the reading and
writing of Rust.

I also purchased a paper copy of the [Rust Programming Language
book](https://doc.rust-lang.org/book/). I'm not one for reading programming books
cover-to-cover, but having a paper copy still turned out to be useful. Taking the
paper copy to another location, _away from the computer_, allowed me to focus
on a few key chapters which addressed key areas of my confusion. The book is
written quite well, plenty of strong narrative explaining concepts behind Rust
rather than solely focusing on code snippets and the explanation that surrounds
them. Among other things, the narrative helped me wrap my brain around the zen
and art of ownership, a key concept to Rust if you're to build anything
consequential with it.

Finally, I have started to read _more_ Rust, which also helped me up the
learning curve. The convention of an `examples/` directory in
[Crates](https://crates.io) has proven itself invaluable. Example snippets for
crates which do interesting things, or interface with systems that I am also
interested in working with, gave me a better feel of the syntax, structure, and
overall aesthetic of Rust.

I still struggle with the myriad of built-in modules in the standard library,
but I know that to be unavoidable from my time in the Java ecosystem. As one
writes more and more, slowly but surely the standard library seeps into the
muscle memory as if through osmosis. It just takes time.

Perhaps the learning curve would not have felt so steep if I had been able to
dedicate a week or two to the exercise of learning a new and structurally
different systems programming language. Once upon a time I could have
dedicated that much effort to such a hobby but those days are long gone now.
Instead I find myself picking up an hour here, thirty minutes there, and trying
to load mental context fast enough to make some progress with learning a new
skill. That approach might work for simple things, but Rust definitely was not
that to me.

If you are an experienced developer learning any new language of sufficient
newness, I would encourage you to think about how you learned to program in the
first place. Simple, small, almost embarrassingly basic exercises. The complex
systems you are capable of modeling will have to wait, you may have to go back
to the beginning. Back to the third, fourth, and fifth exercises after your
"Hello World." It is painful, but this time around it will go much faster
than the first.
