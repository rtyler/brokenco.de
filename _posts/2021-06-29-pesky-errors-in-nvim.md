---
layout: post
title: "Finally figured out those inline Rust errors"
tags:
- vim
- rust
---


Vim can be used as an IDE of sorts for Rust by using a variety of plugins, that don't always play nicely together. A few weeks ago while I was hacking on some Rust and these errors started showing up inline. Blaring red text basically as soon as I was done typing half-finished thoughts.

![Failure in vim](/images/post-images/2021-rust-nvim/fail.png)


At the time, I spent a while trying to figure out which plugin and what configuration setting was causing these to show up. I even went to far as to play plugin whack-a-mole by removing some plugins, editing code, and then toggling things back and forth.

Only recently as I was preparing a laptop for some Rust hacking did I _finally_
discover what combination of tools was resulting in these annoying inline
warnings.

THe culprit up being
[LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim)
which integrates with the [Rust Language
Server](https://github.com/rust-lang/rls) to provide inline code hinting, error
checking, and documentation. I believe I saw the behavior intermittently before
since Language Client _must_ be made aware of where the `rls` binary exists, in
order for the subprocess to be launched while editing. On the laptop I was
configuring, I managed to get the right configuration and paths set up, and
started seeing the errors. Because I had only just added the
LanguageServer-neovim plugin, I was certain that was the source of the
behavior.

Scanning through the documentation I discovered the following:

```
2.10 g:LanguageClient_diagnosticsEnable    *g:LanguageClient_diagnosticsEnable*

Whether to handle diagnostic messages, including gutter, highlight and
quickfix/location list.

Default: 1
Valid options: 1 | 0
```

The mention of "gutter" made me suspect this was my culprit, so I updated my `init.vim` with the following:

```vim
let g:LanguageClient_diagnosticsEnable = 0
```

Voila! No more annoying inline errors showing up when I'm happily hacking away! With LanguageClient configured properly, I can have really great hover documentation on symbols (mapped with `Shift+k`) without bright red errors interrupting my flow:

![Hover documentation](/images/post-images/2021-rust-nvim/hover.png)


