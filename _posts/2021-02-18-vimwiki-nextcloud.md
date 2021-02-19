---
layout: post
title: Synchronizing notes with Nextcloud and Vimwiki
tags:
- nextcloud
- vim
---

The quantity of things I need to keep track of or be responsible for has
_exploded_ in the past few years, so much so that I have had to really focus on
organizing my "personal knowledgebase." When I originally tried to spend some
time improving my information management system, I found numerous different
services offering to improve my productivity and to help me keep track of
everything. Invariably many of these tools were web apps. In order to quickly and
productively work with information, a `<textarea/>` in a web page is the choice
of just about last resort. I recently revisited
[Vimwiki](https://vimwiki.github.io/) and have been _quite_ satisfied both by
my productivity boost and the benefits that come with having **raw
text** to work with. The best benefit: easy synchronization of notes with [Nextcloud](https://nextcloud.com/).


By itself, Nextcloud is a great piece of software that I cannot recommend
highly enough. The [Nextcloud Notes](https://apps.nextcloud.com/apps/notes)
application is a wonderful addon that has made a lot of good decisions. Notes
are text files (`.txt` or `.md`) which are stored in the `Notes/` folder for
the user, and the mobile and web versions of notes are just working with
_text_. No special syntaxes to learn, no awkward file formats, just notes.


With my Nextcloud instance and the [desktop
client](https://nextcloud.com/clients/) auto-synchronizing folders in my
`~/Nextcloud` directory, the little snippet of `.vimrc` that is required to
have Vimwiki sync to Nextcloud is below:

```
" vimwiki set up
let g:vimwiki_list = [{'path': '~/Nextcloud/Notes/',
                       \ 'syntax': 'markdown', 'auto_toc' : 1,
                       \ 'ext': '.md'}]
```

Rather than using the `.vimwiki` extension, this is instructing to write my
Vimwiki files out as Markdown. Once files are written or updated to
`~/Nextcloud/Notes`, the desktop client will sync those automatically. When I
edited notes on my phone, those are also synchronized back to my workstation
where I can continue editing them in Vimwiki.

The Nextcloud Notes web and mobile application doesn't really understand the
inter-page links used by Vimwiki, but that has not been a problem for me thus
far. My "mobile" or non-Vimwiki workflow is typically centered around a single
note, whereas my local Vimwiki-based workflow has me rapidly navigating through
different documents linked together from within Vim.

If you're looking to get into Vimwiki, I found [this
cheatsheet](http://thedarnedestthing.com/vimwiki%20cheatsheet) helpful. After a
couple months of steady usage,my personal knowledgebase has been growing
rapidly to include work related notes, runbooks, project plans, shopping lists,
and all manner of information. This approach might not be for everybody, but if like me you find yourself using vi keybindings in every app that provides it, Vimwiki might be for you! :)
