---
layout:
title: Creating CRUD applications in Rust
tags:
- rust
- tide
---

For some recent web application projects like
[dotdotvote](https://github.com/rtyler/dotdotvote) and
[riverbank](https://github.com/delta-incubator/riverbank) I reached for
[Tide](https://github.com/http-rs/tide) and built them in Rust. I have a lot of
reasons for liking Tide, not the least of which is that it is reminiscient of
[Sinatra](http://sinatrarb.com/) in the Ruby ecosystem.  Perusing the internet
today I noticed this really great blog series by [Javier
Viola](https://javierviola.com/) which will walk you through the full process
of developing a real application with Tide.

1. [Creating a basic CRUD app with Rust and Tide](https://javierviola.com/post/lets-create-a-basic-crud-with-rust-using-tide/)
2. [Refactoring](https://javierviola.com/post/basic-crud-with-rust-using-tide-refactoring/)
3. [Moving the data layer to a database](https://javierviola.com/post/03-basic-crud-with-rust-using-tide-move-to-db/)
4. [Improving with tests](https://javierviola.com/post/04-basic-crud-with-rust-using-tide-tests-improvements/)
5. [Adding a front-end](https://javierviola.com/post/05-basic-crud-with-rust-using-tide-front-end-with-tera/)
6. [Final refactoring and adding CI and CD](https://javierviola.com/post/06-basic-crud-with-rust-using-tide-final-refactor-and-complete-ci-cd/)

Rust can be a challenging language to get started with but once you get the
knack of it, you will likely find it's a joy to develop fast, stable, and
compact applications. For more Rust content, I recommend following [Javier on
Twitter](https://twitter.com/pepoviola) or subscribing to his [RSS
feed](https://javierviola.com/index.xml).
