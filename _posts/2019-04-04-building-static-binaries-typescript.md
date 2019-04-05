---
layout: post
title: "Building static binaries with TypeScript"
tags:
- typescript
- javascript
---

The ability to shamelessly ask stupid questions has has led me to numerous
interesting projects and in some case truly novel solutions. I'm certainly the
subject of this blog post at least fits into the first part of that equation. I
find the single static binaries produced by Rust and Golang to be compelling
for system utilities, at the same time however I am quite fond of writing
TypeScript. Why can't I mix chocolate with my peanut butter?

You kinda can! And it kinda works!

I first started tinkering with a tool I was aware of from goofy hacking months
ago: [nexe](https://github.com/nexe/nexe). Nexe helps turn Node applications
into single static binaries with an embedded runtime. I had issue with newer
style imports working properly with the system Nexe uses to build bundles, so I
went looking around for other options. Eventually I stumbled into [Pkg](https://github.com/zeit/pkg) which worked quite well!

Using `pkg` with TypeScript ended up working with the simple addition of a
`tsc` invocation before invoking `pkg` with the `build/` directory containing
the output JavaScript files.

I have suspicions that `pkg` won't work effectively with some Node packages
that include native code, but haven't yet walked into that minefield.

---

Are static binaries which embed Node possible, definitely! Are they a good idea
... maybe! I'm looking for more interesting projects to explore the concept in
the future, but for now it's filed under "interesting novelties."
