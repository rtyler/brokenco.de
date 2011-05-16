--- 
layout: post
title: Pre-tested commits with Hudson and Git
tags: 
- Software Development
- Git
- Hudson
created: 1262301736
---
A few months ago <a id="aptureLink_yMRaEAQt6P" href="http://twitter.com/kohsukekawa">Kohsuke</a>, author of the <a id="aptureLink_gay9zt4yuf" href="http://twitter.com/hudsonci">Hudson continuous integration server</a>, 
introduced me to the concept of the "pre-tested commit", a feature of the <a id="aptureLink_h8ICO1PttT" href="http://en.wikipedia.org/wiki/TeamCity">TeamCity</a>
build management and continuous integration system. The concept is simple, the build
system stands as a roadblock between your commit entering trunk and only after the 
build system determines that your commit doesn't break things does it allow the commit
to be introduced into version control, where other developers will sync and integrate 
that change into their local working copies. The reasoning and workflow put forth by 
TeamCity for "pre-tested commits" is very dependent on a centralized version control
system, it is solving an issue <a id="aptureLink_IXcu5r11no" href="http://en.wikipedia.org/wiki/Git%20%28software%29">Git</a> or <a id="aptureLink_cPtvZ5XxiP" href="http://en.wikipedia.org/wiki/Mercurial%20%28software%29">Mercurial</a> users don't really run into. Those using 
Git can commit their hearts out all day long and it won't affect their colleagues until they
**merge** their commits with others.

In some cases, allowing buggy or broken code to be *merged* in from another developer's Git
repository can be worse than in a central version control system, since the recipient of the 
broken code might perform a knee-jerk <a id="aptureLink_N7GE0Q9soz" href="http://www.kernel.org/pub/software/scm/git/docs/git-revert.html">git-revert(1)</a> command on the merge! When you revert 
a merge commit in Git, what happens is you not only revert the merge, you revert the commits 
associated with that merge commit; in essence, you're reverting *everything* you just merged in 
when you likely just wanted to get the broken code out of your local tree so you could continue
working without interruption. To solve for this problem-case, I utilize a "pre-tested commit" or 
"pre-tested merge" workflow with Hudson.

My workflow with Hudson for pre-tested commits involves three separate Git repositories: my local
repo (local), the canonical/central repo (origin) and my "world-readable" (inside the firewall) repo (public). 
For pre-tested commits, I utilize a constantly changing branch called "pu" (potential updates) on the 
world-readable repo. Inside of Hudson I created a job that polls the world-readable repo (public) 
for changes in the "pu" branch and will kick off builds when updates are pushed. Since the content of 
`public/pu` is constantly changing, the <a id="aptureLink_O9LMHblU7c" href="http://www.kernel.org/pub/software/scm/git/docs/git-push.html">git-push(1)</a> commands to it must be "forced-updates" since I am 
effectively rewriting history every time I push to `public/pu`. 

To help forcefully pushing updates from my current local branch to `public/pu` I use the following <a id="aptureLink_jO9JAsy1Sm" href="http://git.or.cz/gitwiki/Aliases">git alias</a>:

    % git config alias.pup "\!f() { branch=\$(git symbolic-ref HEAD | sed 's/refs\\/heads\\///g');\
          git push -f \$1 +\${branch}:pu;}; f"

While a little obfuscated, thie `pup` alias forcefully pushes the contents of the current branch to the specified 
remote repository's `pu` branch. I find this is easier than constantly typing out: `git push -f public +topic:pu` 

In list form, my workflow for taking a change from inception to `origin` is:

* *hack, hack, hack*
* commit to `local/topic`
* `git pup public`
* Hudson polls `public/pu` 
* Hudson runs potential-updates job
* Tests fail?
   * **Yes**: Rework commit, try again
   * **No**: Continue
* Rebase onto `local/master`
* Push to `origin/master`

Using this pre-tested commit workflow I can offload the majority of my testing requirements to the build system's cluster of machines instead of running them locally, meaning I can spend the **majority** of my time writing code instead of waiting for tests to complete on my own machine in between coding iterations.
