---
layout: post
title: "A terminal in your editor in your terminal"
tags:
- vim
---

I discovered today that since version 8.1, Vim apparently supports spawning a
terminal from within the Vim editor. This is a handy little feature that could
make life easier for checking documentation, running tests, and so on.

From [box.matto.nl](https://box.matto.nl/):


>  With  ":terminal" you open a terminal in the current
>  window.
>
>  To create a vertical split, with a terminal  in  the
>  newly opened window, use ":vertical terminal".
>
>  With  some  easy  Vim  scripting  you  can  open the
>  external URL that  is  under  the  cursor  with  the
>  awesome  textmode  browser  w3m in a Vim terminal. I
>  liked to have that in a vertical split.


I have modified their function slightly to open horizontal, and automatically close the terminal when the `w3m` command exits:

```vim
function s:vertopen_url()
     normal! "uyiW
     let mycommand = "w3m " . @u
     execute "terminal++close " . mycommand
endfunction
```


I have utilized the use of `tmux` and its builtin `send-keys` commands to send
interactions between terminals in my development environment. Scripting and
integrating with a terminal from Vim is a different twist on the same use-case.
I have only started to play with this functionality, but I'm interested to see
what I can improve with `:terminal`.
