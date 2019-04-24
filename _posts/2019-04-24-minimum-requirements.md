---
layout: post
title: Minimum requirements to participate in a project
tags:
- opinion
- opensource
- jenkins
---

When waiting for containers to build, or dependencies to download, my mind
tends to wander. Yesterday it wandered to the plight of new contributors to
modern free and open source projects; how much they must do before even
attempting to collaborate! I started a [Twitter
poll](https://twitter.com/agentdero/status/1120713097986002944), asking: 

> *In order to participate in my open source project, you must have at
> minimum:*
>
> * *GitHub account*
> * *Google account*
> * *Slack account*
> * *signed CLA faxed to legal*

The results were overwhelmingly in favor of requiring, at minimum, a
[GitHub](https://github.com) account. This was the result I expected and
certainly matches the anecdotal experiences I have had in recent years.

Unfortunately Twitter polls doesn't allow multiple selections, as the reality
for most people is that they need _all_ of those, as [Felix
Frank](https://twitter.com/felis_rex/status/1120735653422075910) alluded to in
his response. When I think of the [Jenkins](https://jenkins.io) project in
particular, the "registration" process for new contributors might typically
include:

* A GitHub account.
* An LDAP account to access Jira, Confluence, and Jenkins-on-Jenkins.
* Connecting to IRC over Freenode, or a [Gitter](https://gitter.im) channel,
  depending on their focus area.
* Subscription to a mailing list operated by Google Groups.
* A Google account, if they want to participate in Hangouts or comment on
  Google Docs for various design documents.

As we have discussed newer services to incorporate into the community, I have
grown weary over the number of logins we would expect each contributor to
maintain.

I do not find myself reminiscing about the "good old days" of open source
software, when things were more oriented around Bugzilla, CVS/Subversion, mailing
lists, and IRC. There too we had account sprawl, it was perhaps a bit more
non-obvious.

For the Jenkins project, the ideal world would mean that everything linked to
our project's LDAP infrastructure. With services like GitHub, That is obviously
not possible, so the next best thing would be to use GitHub as the source of
identity for all our other development services. Yes this couples us more
closely with GitHub, but at least then we would stop pretending we're not
already intricately bound with GitHub as a service.


As many projects approach the summer, and Google Summer of Code kicks off, I
encourage you to consider the number of accounts, repositories, groups, and
other information a student or new-contributor must have in order to _start_
adding to the community.

Our goal as stewards of such projects, should be to push that number towards
zero.
