---
layout: post
title: "Struggling to learn Rust"
tags: 
- opinion
- rust
---

Building daemons and system-level utilities has always been something I have
enjoyed. While I have professionally written C code, I have always
found it a bit antiquated and unpleasant, like using a screwdriver while
everybody around you is using power tools and machines. It certainly still has
its place in the world, but there are more powerful options out there.
I have experimented with [Ada](/tag/ada.html) as a system level toolchain,
while an all around compelling language it suffers from a severe lack of
libraries and doesn't have a strong community of tooling. Recently I started
experimenting with Rust and despite it's promise, it has been one of the most
challenging languages to date for me to learn.

The syntax is not quite like anything else and is **nuanced**. There are
subtleties which are semantically very important. I'm still getting comfortable
with the error handling syntax, the importance of expressions with semi-colons
compared to those without, and the details of defining structs and their
separate implementations.

One of the biggest hurdles I have had is mapping code to documentation for
Rust. I remember when I learned Ruby, [figuring out how to make `ri`
useful](/2011/09/01/making-ri-useful.html) was a major step forward for my
ability to understand the code I was working with. I made a similar jump
forward when I started to get fluent with [Pry](https://pryrepl.org/) and the
Ruby debugger (the predecessor to byebug, whose name I've since forgotten).
This past weekend I got some pointers in the `#rust` IRC channel to
[LanguageClient](https://github.com/autozimu/LanguageClient-neovim) and
[Deoplete](https://github.com/Shougo/deoplete.nvim) which combined with
[RLS](https://github.com/rust-lang/rls) provide a lot more of the useful
in-editor documentation that I had been missing.

With that improved editing experience, I'm stumbling forward a bit more
efficiently, but I still find myself missing a REPL like that I have enjoyed in
Python and Ruby

I also find myself in need of "Rust as a Second Language" type examples and
tutorials. As a very experienced developer, I don't quite have the patience to
tip-toe through beginner tutorials, but would love documentation to discuss
building RPC servers, working with data stores, building parsers, or any other
of those more advanced but certainly real-world use cases.

I am confident that Rust will be beneficial, but the learning curve has been
steeper than I anticipated. :(
