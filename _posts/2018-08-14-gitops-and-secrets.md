---
layout: post
title: "It's no secret where GitOps falls down"
tags:
- gitops
- infrastructure
- puppet
- jenkins
- kubernetes
---

This year I have started to see a new buzzword get thrown around, one which I
can feel especially hipstery about: GitOps. While the folks over [at
WeaveWorks](https://www.weave.works/blog/gitops-operations-by-pull-request)
have made the term fashionable in the Kubernetes ecosystem, stodgy old-timer
Puppet users might recognize the same practices they've used for a few years
now by combining [R10k and
Git](https://puppet.com/blog/git-workflows-puppet-and-r10k). In fact, I was
first introduced to the concept by [Gary
Larizza](http://garylarizza.com/blog/2014/08/31/r10k-plus-directory-environments/),
an absolutely loud, foul-mouthed, and wonderful hacker. The concepts Gary
blogged about I rapidly
introduced to the Jenkins project's [own Puppet-based
infrastructure](https://github.com/jenkins-infra/jenkins-infra). This blog post
isn't about how sunglasses-at-night cool all us Puppet users have been, but
instead I wished to clarify some areas where "GitOps" as a practice falls
short, and what is needed to compensate.


GitOps, in essence, is using Git as the source of truth to drive infrastructure
changes through environments using pull request and branches. Many
organizations dress it up with additional trappings which may benefit their
particular needs, but fundamentally it boils down to: infrastructure as code,
using Git for environment/pipeline management.

For example, with the Jenkins project's Puppet-based infrastructure, we follow
the following branching model sand workflow:

```
+----------------+
| pull-request-1 |
+-----------x----+
             \
              \ (review and merge, runs acceptance tests)
staging        \
|---------------o--x--x--x---------------->
                          \
                           \ (manual merge, auto-deploys to prod hosts)
production                  \
|----------------------------o------------->
```

This same model works rather well for Kubernetes resources where one might
progress an application deployment through a series of stages before reaching
production.

In addition to the hopefully obvious benefits of infrastructure as code, this
approach couples nicely with ephemeral environments, and strong automated test
practices which allow developers to validate their infrastructure changes in
pull requests before reaching production, which is only a merge away!


It is not all rainbows and `:tada:` emojis. "What they don't tell you" is how
to manage secrets effectively.

---


Consider a simple  web application, "Hiya!", wherein a user enters an email into a form
field, clicks a button, and receives a "Hello World!" email in their inbox.
"Hiya!" is effectively stateless, but requires a
[SendGrid](https://sendgrid.com) API token in order to send the user an email.
Naturally for our "staging" environment, the application should using a
SendGrid staging API token and URL, whereas for the "production" environment it
should be using a different token backed by a very big credit card for our
high-scale email sending application.

For most organizations, it would be reasonable for all the devs to have access
to the SendGrid staging API token for testing their applications, so that can
probably be checked into the `hiya.git` repository.

What about production credentials?

A couple options come to mind:

1. Check those credentials into `hiya.git` in an encrypted form, which the
   [Jenkins](https://jenkins.io/) Pipeline can properly decrypt and deploy into
   the Kubernetes, or other, production environment.
1. Use a separate "shadow" development and delivery flow strictly for secrets and
   credentials. This delivery pipeline would only be visible to a select few,
   typically operations staff.
1. Connect some external secrets management tool (Vault, Amazon Key Management
   Service, Azure Key Value)to remove any kind of "GitOps" development workflow
   for secrets.

Thus far, I have not found a consistently useful approach for managing secrets
across GitOps workflows between conventional and Kubernetes-based
infrastructure.

For the Jenkins project's infrastructure, we rely on a hybrid approach:
encrypting credentials _and_ managing them in a somewhat separate "shadow"
delivery pipeline using Puppet and
[hiera](https://puppet.com/docs/puppet/5.3/hiera_intro.html) (with
hiera-eyaml).

The trade-off with the approaches 2 & 3 above, and the hybrid model the Jenkins
project utilizes is that "ops" has to be informed and involved with changes
going to production. Our involvement is typically only to make sure that a
"shadow" pull request is being developed with the production credentials
alongside the actual application deployment code. More than once I've
inadvertently deployed an application to production, only later to realize that
that application was using staging credentials because a shadow pull request
hadn't yet been merged.

Using the example flow from above as a reference, our combined workflow might
look something like this:

```
+----------------------------------+
| pull-request-1 (requires secret) |
+--------------------------x-------+
                            \
                             \ (review and merge, runs acceptance tests)
               staging        \
               |---------------o--x--x--x---------------->
                                         \
                                          \ (manual merge, auto-deploys to prod hosts)
               production                  \
               |----------------------------o---O--------->
                                               /
                                              /
                            ------------------
                            production deploy
                            -----------------
secrets repository                  |
|-----------------o-----------------O--------------------->
                 / (merge ahead of pr#1)
                /
   +-----------x---------------------+
   | pull request for secret in pr#1 |
   +---------------------------------+
```


**Not ideal**. But unfortunately I have not found a better approach for
managing secrets with the "GitOps" development flow. That said, having two
Git-based flows is a reasonable middle ground, but typically cross-repository
traffic-policing challenges do apply

---

I'm very interested to learn about how other folks are solving the problem of
managing secrets with a Git-based infrastructure deployment flow. Whether we're
talking about secrets and certificates being delivered by a tool like Puppet,
or something uploading secrets into different namespaces in Kubernetes.


Some other challenges with Git-based infrastructure delivery approaches
(GITOPS!!1), particularly with Kubernetes, which I find interesting:

* Enforcing compliance with security standards.
* Preventing configuration/state drift, which is where Puppet excels.
* Blending pipelines from multiple repositories, such that different
  applications could reasonably maintain their own configurations, without
  needing to run fully separate deployment pipelines.

While these challenges exist, I still fundamentally agree that "GitOps" should
be the preferred approach for auditability and tracking of state as
infrastructure and application code moves towards production.

It's not all rainbows and `:tada:` emojis, but I think we're getting there.
