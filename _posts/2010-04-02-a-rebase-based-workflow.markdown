--- 
layout: post
title: A rebase-based workflow
tags: 
- software development
- git
created: 1270213200
---
<a href="http://agentdero.cachefly.net/unethicalblogger.com/images/branch_madness.jpeg" target="_blank"><img src="http://agentdero.cachefly.net/unethicalblogger.com/images/branch_madness.jpeg"width="200" align="right"/></a>When I first started working with Git in [mid 2008](http://unethicalblogger.com/posts/2008/07/experimenting_with_git_slide_part_13) I was blissfully oblivious to the concept of a "rebase" and why somebody might ever use it. While at Slide we were **crazy** for merging (*see diagram to the right*), everything pretty much revolved around merges between branches. To add insult to injury, development revolved around a single central repository which *everyone* had the ability to push to. Merges compounded upon merges led to a frustratingly complex merge history.

When I first arrived at Apture, we were still using Subversion, similar to Slide when I arrived (I have a Git-effect on companies). In order to work effectively, I *had* to use git-svn(1) in order to commit changes that weren't quite finished on a day-to-day basis. Rebasing is fundamental to the git-svn(1) workflow, as Subversion requires a linear revision history; I would typically work in the `master` branch and execute `git svn rebase` prior to `git svn dcommit` to ensure that my changes could be properly committed at the head of trunk.

When we finally switched from Subversion to Git we adopted an "integration-manager workflow" which is far more conducive to rebase being useful than the purely centralized repository workflow I had previously used at Slide.

<center><img src="http://agentdero.cachefly.net/unethicalblogger.com/images/integration_manager_workflow.png"/></center>
<center><small>From the [Pro Git](http://progit.org/book/ch5-1.html) site</small></center>

In addition to the publicly readable repositories for each developer, we use Gerrit religiously which I'll cover in a later post.

We use rebase heavily in this workflow to accomplish three main goals:

* Linear revision history
* Concise commits covering a logical change
* Reduction of merge conflicts

Creating a solid linear revision history, while not immediately important, is nicer in the longer term allowing developers (or new hires) to walk the history of a particular file or module and see a clear progression of changes. 

<img src="http://agentdero.cachefly.net/unethicalblogger.com/images/qgit_apture_graph.png" align="right" hspace="4" vspace="4"/>Creating concise commits is probably the **most** important reason to use rebase, when working in a topic branch I will typically commit every 20-40 minutes. In order to not break my flow, the commit messages will typically be brief and cover only a few lines of changes, atomic commits are great when writing code but they're lousy at informing other developers about the changes. To do this, an "interactive rebase" can be used, for example, collapsing the commits in a topic branch `ticket-1234` would look like:

* `git checkout ticket-1234`
* `git rebase -i master`

This will bring up an editor with a list of commits, where you can "squash" commits together and re-write the final commit message to be more informative.



### The Workflow

For the purposes of the example, let's use the topic branch from above (`ticket-1234`) which we'll assume has 3 commits unique to it.

1. Fetch the latest changes from the upstream "master" branch
   * `git fetch origin`
1. Rebase the topic branch, effectively piling the 3 commits on top of the latest tip of the upstream "master" branch
   * `git rebase origin/master`
1. Collapse the 3 commits in the topic branch down into one commit
   * `git rebase -i origin/master`
1. (*Later*) Bringing those commits down into the "master" branch
   * `git checkout master && git rebase ticket-1234`

With an interactive rebase, you can chop commits up, re-order them, squash them, etc, with the non-interactive rebase you can pile your commits on top of an upstream head making your changes apply cleanly to the latest code in the upstream repository.

[git ready](http://www.gitready.com/) has a few nice articles on the subject as well, such as an [intro to rebase](http://www.gitready.com/intermediate/2009/01/31/intro-to-rebase.html) and an article on [squashing commits with rebase](http://www.gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html)
