---
layout: post
title: "Hashicorp Nomad, almost but not quite good"
tags:
- opinion
- nomad
---

My home office has grown in size and for the first time in decades I believe I
have a _surplus_ of compute power at my disposal. These computational resources
are not in the form of some big beefy machine but a number of smaller machines
all tied together by a gigabit network hiding away in a server cabinet. The big
problem has become how to effectively utilize all that computational power, I
turned to [Nomad](https://developer.hashicorp.com/nomad) to orchestrate
arbitrary workloads on static and ephemeral (netboot) machines. As the title
would suggest, it's almost good but it still falls frustratingly short for my
use-cases.

I started investigating Nomad because Hashicorp pulled out a big licensing
foot-gun and pulled the trigger, changing to a non-open source license for all
of their projects, Nomad included. Unlike it's friend Terraform, whose
community rightfully revolted and created [OpenTofu](https://opentofu.org/), no
such community seems to exist for Nomad. Extension and integration points are
the raw materials necessary to build a blossoming third-party community, and
without something akin to Terraform's providers and modules, there simply isn't
a common way for Nomad users to share patterns. Nomad has equivalent to [Helm
charts](https://helm.sh), and the user community is worse off for it.

While Nomad does technically have a plugin architecture, it is poorly
documented and seems to only exist for task drivers (e.g. `docker`, `exec`,
`pot`). The vast majority of users are not going to need to write new task
drivers, but I can imagine a ripe opportunity for something akin to Terraform
modules for shared workload definitions in Nomad. It just doesn't seem to have
ever materialized.

The roughness around the edges are many, but some of the ones bugging me this week are:

* A glitchy web UI that rivals old [Jenkins](https://jenkins.io) in its ability
  to hide the common user flows behind a too many clicks.
* A description language that doesn't "cascade" properly. Some blocks can be
  configured at the `job`, `group`, and `task` level. Others can be configured
  at the task level, like `env`, leading to redundant definitions across every
  `task` in a job.
* Secrets integration is through Hashicorp Vault or ... nothing. Which means I
  guess I'll just shove things into environment variables and hope nobody notices.

I do _kind of_ like Nomad though, which makes this all the more frustrating.
Most of what I need to do are ad-hoc on-premise compute workloads, some of
those workloads fit "cleanly" into Docker containers, others do not. Nomad does
meet that lovely middle ground of allowing me to orchestrate both. The support
for `service` (run a web server), `batch` (run a nightly job), and `sysbatch` (run a
management task on a slice of nodes) task types also covers a very useful
spectrum of my needs.

Despite all the really interesting qualities of Nomad it is a perhaps overly
complex piece of software which never lent itself to strong open source
contributions or community engagement. With the change in its
[license](https://helm.sh/docs/topics/charts/) I fear it's going to fall
further behind and ultimately be forgotten in a sea of ambitious but ultimately
mismanaged software projects.


Returning to the needs that led me to adopt Nomad in the first place, they're
still not entirely met but I'm a bit lost on options to orchestrate workloads that _could_ fit in Nomad really well.

Yes, the rough edges of Nomad are frustrating. What is much more frustrating is
that I can see how Nomad could be a _great_ piece of software, but because of
social factors rather than technical ones, will never actually get there.


