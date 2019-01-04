---
layout: post
title: "Even with external issue trackers, leave GitHub Issues enabled"
tags:
- opensource
- freesoftware
- opinion
---

[Jenkins](https://jenkins.io) is a _large_ open source project. Well over two
thousand repositories, almost two thousand committers, four or five GitHub
Organizations, and many thousands of opened, in progress, and closed issues.
Part of the reason we're called Jenkins is because of GitHub and yet many of
our repositories do _not_ use GitHub Issues. We eschew GitHub Issues in favor
of [Jira](https://issues.jenkins.io/) for a number of reasons, perhaps most
importantly is that GitHub Issues are incredibly difficult to scale across
repositories and teams. What might be considered a shining example of scaling
GitHub Issues would be the [Kubernetes](https://kubernetes.io) ecosystem which
has concocted a rather complex workflow using automated bots, labels, and
comments on Issues. As such, it's not _impossible_, but vanilla out-of-the-box
GitHub Issues are tricky to grow with large free and open source projects.

As Jenkins has matured, my own opinions on the time and place for GitHub Issues
has evolved. Unlike the uncompromising opinion that we should simply
disable Issues on our repositories, like we tend to do with Wiki and Projects,
which I do genuinely find mostly useless even for my personal projects, I have
started to think that Issues should be left _enabled_ by default, even if the
"main development" of tickets is handled elsewhere. As a maintainer it's not
terribly difficult, and dare I say automatable, to triage and move tickets from
GitHub Issues into Jira. What is **not automatable** is getting the issues
filed in the first place by new users and contributors.

Stated simply, the barrier to entry of GitHub Issues is so low that I would
rather have redundant tickets in two systems than to leave potential bug
reports with no place to go. With newer tools like
[Probot](https://probot.github.io/) I believe the opportunities for
exfiltrating information from GitHub into a better system of record, such as
Jira, is so much more attainable than it once was.


Should you find yourself worried about drowning in the torrent of GitHub
Issues, I will refer you to [The Art of
Closing](https://blog.jessfraz.com/post/the-art-of-closing/). You needn't spend
too much time in GitHub Issues, and you don't owe anybody any more time than
you want to spend on Issues; practice good hygiene and close unnecessary Issues
early and often!


That said, I suggest erring on the side of enabling easier feedback than not.
Filing Issues is typically the first step on the road to contribution.
