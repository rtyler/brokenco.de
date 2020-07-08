---
layout: post
title: "Reading RSS feeds from wacky protocols with newsboat"
tags:
- rss
- newsboat
---

Much of the information I read during the day, not counting e-mail, comes from
my RSS reader: [Newsboat](https://newsboat.org). Whenever I see an interesting
blog post on Twitter or elsewhere, I habitually subscribe the author's RSS
feed. I recently stumbled across an interesting RSS feed which wasn't served
over HTTP, leading me to wonder: how can I subscribe?

After trying to find some way to make newsboat read a different protocol,
racking my brains thinking of different ways to set up a stub HTTP proxy, I
finally succumbed and read the manpage.

As my luck would have it, the `urls` file that newsboat stores its URLs
supports a special `exec` syntax for shelling out to run a command to fetch the feed,
for example:


`~/.newsboat/urls`

```
"exec:ssh shellhost 'cat /srv/www/rss.xml'"
"exec /usr/bin/torify curl ftp://someftp/rss.xml"
"exec:/usr/bin/torify curl gopher://example.com/0/news.atom.xml"
```

(_Side note:_ do you have any idea how many protocols `curl` supports? **Lots**! On my machine: `dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp`)


The `exec` syntax is certainly a novel feature. As I have been pondering it
more, I have been thinking about is using it to run
_arbitrary shell scripts_ which would generate reports for review. Some ideas that have come to mind:

* Reading the root's mbox on my local and remote machines to get better visibility into the status of cron jobs.
* Executing some `aws-cli` and `az` scripts to grab generate some daily cost reports.
* Retrieving error logs from remote machines to tabulate a daily error report.

There are other possibilities that come to mind, but it all basically boils
down to generating information dashboards which will help me keep tabs on more
and more things, all from within my feed reader.

I have only just started to experiment with this idea, but I'm looking forward
to poking around with this more.
