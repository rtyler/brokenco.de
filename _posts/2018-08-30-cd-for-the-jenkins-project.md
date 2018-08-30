---
layout: post
title: Crawling towards continuous delivery for Jenkins
tags:
- jenkins
- maven
- continuousdelivery
- cicd
---


This year I've been working on an ambitious new project referred to as Jenkins
Evergreen. It is ambitious in that we're aiming to significantly alter the way
in which [Jenkins](https://jenkins.io/) is downloaded, updated, and used.
In most visible ways Evergreen is the same as a traditional Jenkins
installation, but the way it is assembled into a package and delivered is
radically different. Among the many challenges which the Evergreen project must tackle,
there is one problem in common with most other organizations:
**how do you take a big, complex system, and make it continuously deliverable**.

Long story short: very carefully.


## The Old Way

Jenkins follows a pretty typical development and release process,
we chat on mailing lists, open up loads of
pull requests, merge some of them, and then release binary packages at
prescribed intervals.
Users are then expected to know an update has occurred, run some program to check for
updates (`apt-get update`) and install the updates. From the user's
perspective, each release might contain a lot of relevant or important changes,
or it might contain completely trivial ones. Depending on the release line, a
bug identified and fixed may take anywhere from one to a few weeks before
it's made available. Then of course, the user must go through the update song
and dance once more. This common **release train model** sucks for users and, I
would argue, for developers too..

Jenkins has an additional complication: it is plugin-based, and all those
plugins are developed and released largely independently from one another.
Jenkins "core" by itself isn't very useful at all. It is those _plugins_ which
make Jenkins a joy (and sometimes a pain) to use. For all intents and purposes,
plugins _also_ follow the **release train model** (which sucks for users), but
with the bonus feature of requiring users to check for updates through the
built-in Update Center rather than through the same distribution mechanism as
Jenkins core.

Altogether, this leads to large numbers of Jenkins users never updating their
systems.

Nonetheless, the release train model has helped Jenkins grow to where it is
today. The times however, have changed.

Expectations around how we consume and operate our software have changed
radically in the past decade. It is my steadfast opinion that the **release
train model** is now a legacy which we should all be leaving behind.

## The New Way

The model for Jenkins Evergreen is completely different. Rather than a
time-based pull model (also known as the release train model), it provides an on-demand *push* model. As I described in the
design overview document,
[JEP-300](https://github.com/jenkinsci/jep/tree/master/jep/300):

> Jenkins Evergreen will be distributed as an automatically
> self-updating distribution, containing Jenkins core and a version-locked set
> of plugins considered "essential." Rather than attempting to mirror the
> existing Weekly and LTS release lines for core, plus some plugin version
> matrix, Jenkins Evergreen will update in a manner similar to Google Chrome.
>
> For Jenkins end users, this automatically updating distribution will mean
> that Jenkins Evergreen will require significantly less overhead to manage,
> receiving improvements and bug fixes without any user involvement.

Fundamentally, Jenkins Evergreen is about building the machinery to practice
Continuous Delivery with Jenkins itself. The argument for
Continuous Delivery is that smaller releases are **safer** than
big-bang releases. Risk is amortized, and the tooling and habits of
releasing often result in higher-quality software.

**Jenkins needs Continuous Delivery**.

---

How on earth do we get from the release train model (which sucks for
users), to something more continuously delivered?

Very carefully!

Like most transitions to continuous delivery, Jenkins Evergreen requires a
significant amount of ground work in our existing code bases before new code
adopts the Evergreen distribution model.

### Incremental Releases

My colleague Jesse wrote a pretty in-depth article on a new pattern we've
introduced into the Jenkins project, generally referred to as [incremental
releases](https://jenkins.io/blog/2018/05/15/incremental-deployment/).
Jenkins core and plugins are all Java projects which have rich
[Maven](https://maven.apache.org) metadata describing their interdependencies.

In the release train model the velocity of of changes, and version bumps,
required for any given plugin will be fairly minimal. In the release train
model, it is _okay_ to create a pull request to Plugin B, wait for that to be
released, then update Plugin A, to depend on that change, and then wait for
that to be released. In the release train model it is _okay_ to wait for weeks
on end before users see the effects of changes.

In 2018 however, that long cycle time is **not okay**.

Incremental releases allow for plugins to produces artifacts built from pull
requests, or branches, and for those artifacts to be published to a special
`incrementals` Maven repository. From that repository, incremental releases of
artifacts can be subsequently consumed by other tooling.

In the case of Jenkins Evergreen, this allows us to craft a distribution with
changes that are hot off the presses, using another foundational component: the
Bill of Materials.

If you're curious about the design of incremental releases, consult
[JEP-305](https://github.com/jenkinsci/jep/tree/master/jep/305) which outlines
their design.


### The Bill of Materials

Curation is a key component of any continuous delivery system. We do not
necessarily want any old commit to be released all the way through to
"production." Instead we want a means to describe what versions of which
components are safe to proceed through the pipeline.

As described in
[JEP-309](https://github.com/jenkinsci/jep/blob/master/jep/309), the Bill of
Materials gives us a means of describing a combination of Jenkins core and plugins, which should
be delivered together. This specification is currently being used by multiple
parts of the Jenkins project where we have a similar need to test across
multiple components and repositories. In Evergreen it is taken much further.

The Bill of Materials describes what code will be delivered to a Jenkins
Evergreen instance, and the Evergreen distribution system will attempt to
ensure that _all_ instances are at the same exact version of that Bill of
Materials.  The Evergreen distribution system treats all instances as if they
were part of as single fleet, similar to how SaaS applications are deployed.

This homogeneity addresses a fundamental problem with plugin-based ecosystems
like Jenkins's: an explosion of possible installed combinations of software
across all user installations. The large variety of plugin combinations
possible "in the wild" makes bug reporting and reproduction difficult, and
serious pre-release acceptance testing _practically impossible_. In many cases,
the first time certain combinations will ever be executed together will be on
the user's installation

### Feedback

The final logical piece of the puzzle which any continuous delivery pipeline
requires is _feedback_. Much as it pains me to say this, current releases of
Jenkins provide no automated feedback to the Jenkins project on whether they
are operating successfully. No automated crash reports. No error logs. No
analytics. Nothing. The _only_ two ways that a Jenkins contributor will ever
learn about a bug in their plugin or core is if:

1. They see it themselves.
1. A user actually takes the time to manually report it.

Regrettably, this is also the case for tons of free and open source software,
and it's an absolute shame.

With Jenkins Evergreen, basic error reporting is built in by default. We have
integrated with [Sentry](https://sentry.io) for collecting errors automatically
from Jenkins Evergreen installations without any required user involvement. In
the future I'm sure we'll add more advanced feedback mechanisms, but at the
moment a blurry picture of how Jenkins is running "in the real world" is tons
better than flying blind.

---

Jenkins, like any large piece of software which has grown over a long period of
time, has its flaws. After a couple beers, I could tell you about some of the
skeletons in its closet, but on the whole I don't believe Jenkins is inherently
broken, or a lost cause. In fact, I believe that Jenkins is likely now more
important than ever. With the practices of continuous integration and
continuous delivery becoming a core part of every software project, a flexible
and customizable open source tool like Jenkins is increasingly important.

[Jenkins Evergreen](https://github.com/jenkins-infra/evergreen) is my vision of
how we get to a better future with Jenkins. By continuously delivering Jenkins,
I believe we will be able to improve the user experience, alleviate troublesome
bugs, and make Jenkins even more accessible to new developers.
