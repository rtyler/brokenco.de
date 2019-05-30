---
layout: post
title: "Solving CERTIFICATE_VERIFY_FAILED with Gmail and Offlineimap"
tags:
- offlineimap
---

[Offlineimap](http://www.offlineimap.org/) has been a major part of my desktop
computing environment for many years, indulging my use of mutt for all work and
personal email. My work email has unfortunately been stored in Gmail, which
_does_ support IMAP but tends to do a few wacky things with files and folders.

I recently started seeing certificate validation errors when syncing Gmail
accounts:


```
Establishing connection to imap.gmail.com:993 (GmailRemote)
ERROR: Unknown SSL protocol connecting to host 'imap.gmail.com' for repository 'GmailRemote'. OpenSSL responded:
[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:727)
```

I _think_ that either offlineimap or my
[distribution](/2019/02/24/welcome-back-opensuse.html)
has started be more strict with TLS versions. Some searching around didn't get
me very far until I stumbled [into this GitHub issue](https://github.com/LukeSmithxyz/mutt-wizard/issues/85) which suggested a version tweak for the "remote" configuration for Gmail:

```
[Repository GmailRemote]
type = Gmail
ssl = yes
# https://github.com/LukeSmithxyz/mutt-wizard/issues/85
ssl_version = tls1_2
remoteuser = xxx
```

With this change in place, the vacation is over and mail is flowing back into
my inbox, for better or worse! :)
