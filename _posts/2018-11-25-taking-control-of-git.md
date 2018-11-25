---
layout: post
title: "Taking control of Git"
tags:
- sofware
- opinion
---

In the development of service-oriented applications we often will use the
phrase "source of truth" when referring to data and its ownership. The
expectation being that there is generally a _single_ source of truth in the
system. Take DNS for example, we generally trust that a nameserver somewhere
out there is acting as the single source of truth for a single domain, such as
`brokenco.de`. Without this guarantee, much of our experience on the internet
would break down. For the software we write, increasingly GitHub has become the
source of truth for the source code itself. So much so that systems have been
built on top of GitHub which further wed the software ecosystem to a single
source of truth, such as Golang's dependency definition conventions.

I have no fear of the GitHub acquisition by Microsoft, but I do concern myself
with increasingly large single points of failure. A single entity owning too
much of my interactions or data makes me feel uneasy. A little timer starts in
my brain: how long until the good vibes run out, and this ends up screwing me?

With our source code living in Git, switching up the source of truth has never
been easier.  I set out recently to take back *control* for the source of truth
for my own free and open source work. Using a server I have at my disposal, I
deployed [Gitea](https://gitea.io/). Based originally on Gogs, I have found
Gitea rather pleasant and simple to work with.

Fortunately, somebody else has written a tool: the [gitea-github-migrator](https://git.jonasfranz.software/JonasFranzDEV/gitea-github-migrator)
which made initializing the Gitea instance with my repositories quite simple.
Due to some GitHub rate limits and other weird transient network errors, I
ended up running the migrator over and over again until everything was
synchronized properly to my server.

A quick look at my [GitHub profile](https://github.com/rtyler) and you may
notice that nothing has been _deleted_. My objective is to own the source of
truth, not to reduce the redundancy for my source code. Unfortunately as of
today, Gitea cannot automatically push to another Git remote
([issue #3480](https://github.com/go-gitea/gitea/issues/3480)), but creating a script
which can be configured as a `post-receive` hook is easy enough:

```bash
#!/bin/sh

echo
echo "Mirroring changes to GitHub under ${GITEA_REPO_USER_NAME}/${GITEA_REPO_NAME}"
echo
git push --mirror git@github.com:${GITEA_REPO_USER_NAME}/${GITEA_REPO_NAME}.git
echo
```

To support this script I needed to set up a few of things:

1. A newly generated  SSH public/private key pair for Gitea to use.
1. The new SSH public key needed to be added to my GitHub account
1. The above script `gitea-github-mirror` installed on the server's filesystem
1. The repositories I wished to mirror needed to have a `post-receive` hook
   configured which executes `gitea-github-mirror`


Once the desired repositories have been set up, I only needed to change my
local repositories to point somewhere else for their `origin` remote.
Not-too-coincidentally, this is where my previous blog post about [transparently
switching SSH between Tor and the LAN](/2018/11/05/transparent-ssh-over-tor.html) comes in.

I can now treat GitHub like a public backup for these repositories, and
maintain control over the source of truth for each repository I own and
maintain.


### Mirroring other repositories

Gitea has another feature worth mentioning in this same vein, one which I am
only now starting to use: (pull-based) repository mirroring. Inevitably I find
myself relying on third-party repositories either as Git submodules, or for
source-builds of some piece of software. Rather than trust that those
repositories will exist in perpetuity in somebody else's GitHub organization or
user account, Gitea mirroring allows me to create an automatically-updated
mirror of the upstream repository. I've since found myself creating new
organizations in Gitea to house different collections of libraries and tools I
depend on, all automatically synchronized by Gitea.

---

Data provenance is an important subject to me and while not everything is as
easily decentralized as Git, I believe it's worth the effort to try to **own
your data** as much as possible. For those things which are easily added into
source control, Gitea and a modicum of extra disk space does the job nicely!


(Of course, this blog post was published to GitHub pages, after being mirrored
from my Gitea instance.)

