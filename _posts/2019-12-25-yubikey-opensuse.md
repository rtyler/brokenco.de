---
layout: post
title: "Getting started with a Yubikey on openSUSE"
tags:
- opensuse
- yubikey
- security
---


If the people I know tweet enough about something, eventually I'm bound to
breakdown and just buy the thing. It happened with the Intel NUC, and now it's
happened with [Yubikey](https://www.yubico.com). The Yubikey is a USB-based
security device that can do a _lot_ of things, but in my case I just need it to
act as a security key for a number of websites such as GitHub, Google, and
Twitter. Much to my dismay it did not work exactly as I expected right out of
the box on my openSUSE-based laptop.

With recent versions of Firefox Quantum, basically Firefox released over the
past couple years, Chrome/Chromium, and Opera (apparenlty) a Yubikey can be
used directly within web browsers as an external security key. In my case,
every time I tried to configure the device on sites loaded in either Chromium or Firefox, I simply couldn't make it work. The Yubikey would 
instead spit out a random string of garbage. This is one _valid_ mode of the Yubikey,
where it acts like a pretend keyboard and generates One-Time Passwords (OTP).
In my case, I wanted it to act like a Universal 2-Factor authentication device
(U2F).

First try was using the Yubikey manager to poke at the device. This application
can be installed with `zypper in yubikey-manager-qt`. The installed binary is
frustratingly **not** called `yubikey-manager` but instead is named
`ykman-gui`. With that hurdle overcome, I tried to inspect the "FIDO2"
application on the Yubikey but that consistently fail.

Utilizing a mixture of "opensuse" "yubikey" and "u2f" I stumbled into an
openSUSE Buildservice link for a promising package named `u2f-host`. As luck
would have it, the `u2f-host` package ended up being the missing link between
Firefox and my Yubikey. After executing `zypper in u2f-host` and restarting
Firefox, I was able to successfully register and use my Yubikey across a myriad
of websites!


A tiny (nano, actually) Christmas miracle! :)

