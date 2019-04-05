---
layout: post
title: "Building static binaries with TypeScript"
tags:
- typescript
- javascript
---

The ability to shamelessly ask stupid questions has led me to numerous
interesting projects and in some cases truly novel solutions. The
subject of this blog post fits into the first part of that equation at least. I
find the single static binaries produced by Rust and Golang to be quite compelling
for system utilities, at the same time however I am fond of writing
TypeScript. Why can't I mix chocolate with my peanut butter?

You kinda can! And it kinda works!

I first started tinkering with a tool which I discovered while goofy-hacking months
ago: [nexe](https://github.com/nexe/nexe). Nexe helps turn Node applications
into single static binaries with an embedded Node runtime. I had issues with
newer style imports, which weren't working properly with the system Nexe uses
to build its bundles. I went looking around for other options. Eventually I
stumbled into [Pkg](https://github.com/zeit/pkg) which worked quite well!

Combining `pkg` with TypeScript works with the simple addition of a `tsc`
invocation before calling `pkg`. Passing in the `build/` directory containing the
compiled JavaScript files, everything "just works" and a 30-ish megabyte single
static binary is generated. I have a suspicion that `pkg` won't work effectively
with Node packages that include native code, but haven't yet walked into that
minefield.

---

Are static binaries which embed Node possible, definitely! Are they a good idea
... maybe! I'm looking for more interesting projects to explore the concept in
the future, but for now it's filed under "interesting novelties."
