---
layout: post
title: Modern Vim tags/autocomplete with Universal Ctags
tags:
- ctags
- unix
- ada
- vim
---

For years [Vim](http://vim.org) has been both my editor and "IDE" of choice
across all projects, spanning multiple platforms, toolkits and programming
languages.

![Omnicomplete](/images/post-images/universal-ctags/omnicomplete-ruby.png)

Two features that take Vim from a pleasant editor, to practically an IDE, which
I regularly use, are:

1. [Omni completion](http://vim.wikia.com/wiki/Omni_completion) (core)
1. [Tagbar](https://majutsushi.github.io/tagbar/) (plugin)

Both become infinitely more useful with the addition of
"[ctags](https://en.wikipedia.org/wiki/Ctags)". For almost as many years as I
have been using Vim , I have been relying on "[exuberant
ctags](http://ctags.sourceforge.net/)" which, although readily available for all
practical Linux distributions, is dead as a doornail.

Old, slow, and lacking in language support, I found trying out _alternative_
editors and even big scary IDEs!

Recently I discovered *[Universal CTags](http://ctags.io/)*, a continuation of
the dormant "exhuberant ctags" project, now located on GitHub with dozens of
[updates and fixes](http://docs.ctags.io/en/latest/news.html). While it's not
in the package repositories just yet, it's easy enough to [build and install
locally](http://docs.ctags.io/en/latest/building.html).

I recommend trying it out, along with some of the excellent ctags-related
functionality you can enable in Vim to make it more than just a text editor.



![Tagbar](/images/post-images/universal-ctags/tagbar-ruby.png)


*Note:* The colorscheme from the screenshots above is [xoria256](https://github.com/vim-scripts/xoria256.vim)
