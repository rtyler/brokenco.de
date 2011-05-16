--- 
layout: post
title: Code Review with Gerrit, a mostly visual guide
tags: 
- Software Development
- Git
created: 1260254725
---
A while ago, when <a id="aptureLink_DCQGFvVLOq" href="http://twitter.com/pjthiel">Paul</a>, <a id="aptureLink_BbwdfFjMPz" href="http://twitter.com/jasonrubenstein">Jason</a> and I worked together, I became a big fan of code reviews before merging code. It was no surprise really, we were the first to adopt <a id="aptureLink_ySC1aL45rF" href="http://en.wikipedia.org/wiki/Git%20%28software%29">Git</a> at the company and our workflow was quite ad-hoc, the need to federate knowledge within the group meant code reviews were a pretty big deal. At the time, we mostly did code reviews in person by way of "hey, what's this you're doing here?" or by literally sending patch emails with <a id="aptureLink_NlYWR6qaQY" href="http://www.kernel.org/pub/software/scm/git/docs/git-format-patch.html">git-format-patch(1)</a> to the team mailing list so all could participate in the discussion about what merits "good code" exhibited versus "less good code." Now that I've left that company and joined another one, I've found myself in another small-team situation, where my teammates place high value on code review. Fortunately this time around better tools exist, namely: <a id="aptureLink_suzQh0OgeJ" href="http://code.google.com/p/gerrit/">Gerrit</a>.

The history behind Gerrit I'm a bit hazy on, what I do know is that it's primary developer Shawn Pearce (<a id="aptureLink_ZO1gp7ghRJ" href="http://www.linkedin.com/pub/shawn-pearce/0/a93/61">spearce</a>) is one of the Git "inner circle" who contributes heavily to Git itself as well as <a id="aptureLink_ORrreTOiql" href="http://www.jgit.org/">JGit</a>, a Git implementation in Java which sits underneath Gerrit's internals. What makes Gerrit unique in the land of code review systems is how tightly coupled Gerrit is with Git itself, so much so that you submit changes by **pushing** as if the Gerrit server were "just another Git repo."

I recommend building Gerrit from source for now, spearce is planning a proper release of the recent Gerrit developments shortly before Christmas, but who has that kind of patience! To build Gerrit you will need <a id="aptureLink_za0iMCBpFC" href="http://en.wikipedia.org/wiki/Apache%20Maven">Maven</a> and the Sun <a id="aptureLink_V99Bh9QLC8" href="http://en.wikipedia.org/wiki/Java%20Development%20Kit">JDK</a> 1.6. 


Setting up the Gerrit daemon
------------------------------

First you should clone one of Gerrit's dependencies, followed by Gerrit itself:

    banana% git clone git://android.git.kernel.org/tools/gwtexpui.git
    banana% git clone git://android.git.kernel.org/tools/gerrit.git

Once both clones are complete, you can start by building one and then the other (which might take a while, go grab yourself a coffee, you've earned it):

    banana% (cd gwtexpui && mvn install)
    banana% cd gerrit && mvn clean package

After Gerrit has finished building, you'll have a `.war` file ready to run Gerrit with (*note:* depending on when you read this article, your path to gerrit.war might have changed). First we'll initialize the directory "/srv/gerrit" as the location where the executing Gerrit daemon will store its logs, data, etc:

    banana% java -jar gerrit-war/target/gerrit-2.0.25-SNAPSHOT.war init -d /srv/gerrit
    *** Gerrit Code Review v2.0.24.2-72-g4c37167
    ***

    Initialize '/srv/gerrit' [y/n]? y

    *** Git Repositories
    ***

    Location of Git repositories   [git]:

    *** SQL Database
    ***

    Database server type           [H2/?]:

    *** User Authentication
    ***

    Authentication method          [OPENID/?]:

    *** Email Delivery
    ***

    SMTP server hostname           [localhost]:
    SMTP server port               [(default)]:
    SMTP encryption                [NONE/?]:
    SMTP username                  :

    *** SSH Daemon
    ***

    Gerrit SSH listens on address  [*]:
    Gerrit SSH listens on port     [29418]:

    Gerrit Code Review is not shipped with Bouncy Castle Crypto v144
      If available, Gerrit can take advantage of features
      in the library, but will also function without it.
    Download and install it now [y/n]? y
    Downloading http://www.bouncycastle.org/download/bcprov-jdk16-144.jar ... OK
    Checksum bcprov-jdk16-144.jar OK
    Generating SSH host key ... rsa... dsa... done

    *** HTTP Daemon
    ***

    Behind reverse HTTP proxy (e.g. Apache mod_proxy) [y/n]? n
    Use https:// (SSL)             [y/n]? n
    Gerrit HTTP listens on address [*]:
    Gerrit HTTP listens on port    [8080]: 

    Initialized /srv/gerrit

After running through Gerrit's brief wizard, you'll be ready to start Gerrit itself (*note:* this command will not detach from the terminal, so you might want to start it within screen for now):

    banana% java -jar gerrit-war/target/gerrit-2.0.25-SNAPSHOT.war daemon -d /srv/gerrit

Now that you've reached this point you'll have Gerrit running a web application on port 8080, and listening for SSH connections on port 29418, congratulations! You're most of the way there :)


Creating users and groups
-----------------------------
Welcome to Gerrit
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_start.png" rel="lightbox"><img src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_start.png" width="550"/></a></center>
First thing you should do after starting Gerrit up is log in to make sure your user is the administrator, you can do so by clicking the "Register" link in the top right corner which should present you with an openID login dialog
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_openid.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_openid.png"/></a></center>
After logging in with your favorite openID provider, Gerrit will allow you to enter in information about you (SSH key, email address, etc). It's worth noting that the email address is **very** important as Gerrit uses the email address to match your commits to your Gerrit account
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_account_create.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_account_create.png"/></a></center>
When you create your SSH key for Gerrit, it's recommended that you give it a custom entry in `~/.ssh/config` along the lines of:

    Host gerrithost
        User <you>
        Port 29418
        Hostname <gerrithost>
        IdentityFile <path/to/private/key>

After you click "Continue" at the bottom of the user information page, you will be taken to your dashboard which is where your changes waiting to be reviewed as well as changes waiting to be reviewed *by* you will be waiting
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_mydashboard.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_mydashboard.png"/></a></center>

Now that your account is all set up, let's create a group for "integrators", integrators in Git parlance are those that are responsible for reviewing code and integrating it into the "official" repository (typically integrators are project maintainers or core developers). Be sure to add yourself to the "Integrators" group, we'll use this "Integrators" group later to create more granular permissions on a particular project:
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_creategroup.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_creategroup.png"/></a></center>


Projects in Gerrit
---------------------
Creating a new project in Gerrit is fairly easy but a little *different* insofar that there isn't a web UI for doing so but there is a command line one:

    banana% ssh gerrithost gerrit create-project -n <project-name>

For the purposes of my examples moving forward, we'll use a project created in Gerrit for one of the Python modules I maintain, <a id="aptureLink_B0WQyZCJVK" href="http://search.twitter.com/search?q=py-yajl">py-yajl</a>. After creating the "py-yajl" project with the command line, I can visit Admin > Projects and select "py-yajl" and edited some of its permissions. Here we'll give "Integrators" the ability to **Verify** changes as well as **Push Branch**.
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_integratoraccess.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_integratoraccess.png"/></a></center>

With the py-yajl project all set up in Gerrit, I can return to my Git repository and add a "remote" for Gerrit, and push my master branch to it

    banana% git checkout master
    banana% git remote add gerritrhost ssh://gerrithost/py-yajl.git
    banana% git push gerrithost master

This will give Gerrit a baseline for reviewing changes against and allow it to determine when a change has been merged down. Before getting down to business and starting to commit changes, it's recommended that you install the <a href="http://gerrit.googlecode.com/svn/documentation/2.0/user-changeid.html#creation" target="_blank"><strong>Gerrit Change-Id commit-msg hook documented here</strong></a> which will help Gerrit track changes through rebasing; once that's taken care of, have at it!

    banana% git checkout -b topic-branch
    banana% <work>
    banana% git commit 
    banana% git push gerrithost HEAD:refs/for/master

The last command will push my commit to Gerrit, the command is kind of weird looking so feel free to put it behind a <a id="aptureLink_4QD4sdoRxy" href="http://git.or.cz/gitwiki/Aliases">git-alias(1)</a>. After the push is complete however, my changes will be awaiting review in Gerrit
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_openchanges.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_openchanges.png"/></a></center>

<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_changeoverview.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_changeoverview.png"/></a></center>

At this point, you'd likely wait for another reviewer to come along and either comment your code inline in the side-by-side viewer or otherwise approve the commit bu clicking "Publish Comments"
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_publishcomments.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_publishcomments.png"/></a></center>

After comments have been published, the view in My Dashboard has changed to indicate that the change has not only been reviewed but also verified:
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_mydashboard_changesreviewed.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_mydashboard_changesreviewed.png"/></a></center>

Upon seeing this, I can return back to my Git repository and feel comfortable merging my code to the master branch:

    banana% git checkout master
    banana% git merge topic-branch
    banana% git push origin master
    banana% git push gerrithost master

The last command is significant again, by pushing the updated master branch to Gerrit, we indicate that the change has been merged, which is also reflected in My Dashboard 
<center><a href="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_mydashboard_changesmerged.png" rel="lightbox"><img width="550" src="http://agentdero.cachefly.net/unethicalblogger.com/images/gerrit_mydashboard_changesmerged.png"/></a></center>

Tada! You've just had your code reviewed and subsequently integrated into the upstream tree, pat yourself on the back. It's worth noting that while Gerrit is under steady development it *is* being used by the likes of the Android team, JGit/EGit team and countless others. Gerrit contains a number of nice subtle features, like double-clicking a line inside the side-by-side diff to add a comment to that line specifically, the ability to "star" changes (similar to bookmarking) and a too many others to go into detail in this post. 

While it may seem like this was a fair amount of set-up to get code reviews going, the payoff can be tremendous, Gerrit facilitates a solid Git-oriented code review process that scales very well with the number of committers and changes. I hope you enjoy it :)
