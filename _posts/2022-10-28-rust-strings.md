---
layout: post
title: The fastest way to make Rust Strings
tags:
- rust
- software
- software development
---

A friend of mine learning how to code with Python was complaining about the
myth that "there's a Pythonic way" to do things. The "one true way" concept
wasn't ever taken seriously in Python, not even by the standard library.
Practically speaking, it's impossible _not_ to have multiple ways to accomplish
the same outcome in a robust programming language's standard library. This
_flexibility_ jumped out at me while hacking on some Rust code lately: how many
ways can you turn `str`
into `String`?

In Rust `"this thing"` is a [primitive `str`
type](https://doc.rust-lang.org/std/primitive.str.html#) and will have the
`&'static` lifetime. Without diving into lifetimes and how Rust ownership
works, this is basically read-only memory that exists for the duration of the
program. They're _static_ and you can't do much with it. In _most_ APIs you'll
need the [`String`
type](https://doc.rust-lang.org/std/string/struct.String.html), which will give
you an allocated bit of data you can play around with.

Without much effort I came up with five different ways that I have written Rust
code to perform this conversion:

1. `String::from("The boring way")`
2. `"Using a trait".into()`
3. `"This is actually a trait too".to_string()`
4. `"Lol, this is also a trait".to_owned()`
5. `format!("Wake up and choose violence")`

---
If you have some other nifty ways to create `String`s, let me know on
[Twitter](https://twitter.com) or via email (`rtyler@` this domain)!


---


But which is the most fastest?! I wrote the following very important, and very serious microbenchmarking code:

```rust
use microbench::{self, Options};

fn into_trait() {
    let _s: String = "Rust is cool!".into();
}

fn to_string() {
    let _s: String = "Rust is cool!".to_string();
}

fn format() {
    let _s: String = format!("Rust is cool!");
}

fn owned() {
    let _s: String = "Rust is cool!".to_owned();
}

fn string_from() {
    let _s: String = String::from("Rust is cool!");
}

fn main() {
    let options = Options::default();
    microbench::bench(&options, "String::from!", || string_from());
    microbench::bench(&options, "Into<String>", || into_trait());
    microbench::bench(&options, "ToString<str>", || to_string());
    microbench::bench(&options, "ToOwned<str>", || owned());
    microbench::bench(&options, "format!", || format());
}
```

I compiled the program with `rustc` version 1.63.0 and after running some truly
rigorous and scientific tests on my workstation, I am thrilled to share the results:

```
❯ cargo run
   Compiling rust-strings-are-silly v0.1.0 (/home/tyler/source/github/rtyler/rust-strings-are-silly)
    Finished dev [unoptimized + debuginfo] target(s) in 0.25s
     Running `target/debug/rust-strings-are-silly`
String::from! (5.0s) ...                 278.552 ns/iter (0.991 R²)
Into<String> (5.0s) ...                  286.293 ns/iter (0.983 R²)
ToString<str> (5.0s) ...                 292.736 ns/iter (0.987 R²)
ToOwned<str> (5.0s) ...                  290.276 ns/iter (0.985 R²)
format! (5.0s) ...                       300.144 ns/iter (0.995 R²)
```


**HOW INTERESTING!**

Well, not really.

Microbenchmarking like this has **lots** of flaws,
especially when sampling on a single machine running many other concurrent
processes. After executing the tool a few times, one common pattern that I did see was that
the `format!` macro is consistently the slowest way to create `String`s. In
fact `cargo clippy` will complain about you using in this way, not because it's
slow, but because it's a "useless use of `format!`", which I can agree with! :)


Choosing between the rest of them probably is nothing more than a style choice
of the developers working on any given Rust project. With these types of things
it's typically best to adopt one consistent way of doing things _within the
codebase_ to improve readability, but they're all functionally equivalent..

In Rust there's no "one true way" to create a `String`, but my personal
preference is `.into()` for no other reason than it is the fewest
characters to type!
