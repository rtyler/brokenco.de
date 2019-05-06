---
layout: post
title: "What's Uplink"
tags:
- jenkins
---

Making changes safely to an application like [Jenkins](https://jenkins.io) is
_incredibly_ tricky. Jenkins is distributed to hundreds of thousands of
independently owned and operated servers and is used in a myriad of ways.
Our changes with the best intentions, can still result in confounding bugs and errors
for users with different configurations, or different combinations of plugins.  Over on
the [Jenkins project](https://jenkins.io/) blog, Daniel wrote about the [first
use of "telemetry" by Jenkins
core](https://jenkins.io/blog/2019/05/05/telemetry-success), a project on which
we collaborated. I ended up building the backend service for receiving this
telemetry, [Uplink](https://github.com/jenkins-infra/uplink), and I hope it
paves the way for making smarter changes across Jenkins core in the future.

Many developers within the Jenkins community know about the [Jenkins Enhancement
Proposal](http://github.com/jenkinsci/jep), but few will know each proposal by
number _except_ for [JEP-200](https://jenkins.io/blog/2018/01/13/jep-200/).
While JEP-200 described an important security design improvement, its rollout
to the Jenkins userbase left a large number of problems in its wake. We simply
didn't know enough about how plugins were using some features and how they
might break.

The `SECURITY` ticket which inspired this telemetry-oriented approach was
another one of those tickets everybody seems to know only by its number. The
problem was, as Daniel describes in his blog post:

> *Jenkins uses the Stapler web framework for HTTP request handling. Stapler’s
> basic premise is that it uses reflective access to code elements matching its
> naming conventions. [..] As these naming conventions closely match common code
> patterns in Java, accessing crafted URLs could invoke methods never intended to
> be invoked this way. [..] We identified a number of URLs that could be abused
> to access otherwise inaccessible jobs, or even invoke internal methods in the
> web application server to invalidate all sessions.*

Some ideas for fixing the problem had been discussed over many months, but we
kept getting stuck on one big detail: how can we possibly make a major change
without causing a major breakage, like we had inadvertently done with JEP-200.
The exact chronology I do not recall, but I believe that I eventually
convinced Daniel that we could cheaply and easily stand up a telemetry service.
One which would allow Jenkins instances to give the security team the answers
they needed to move forward with a fix. In doing so, I volunteered to write and
deploy the backend service ([Uplink](https://github.com/jenkins-infra/uplink))
which would receive the data.

The entirety of the telemetry system is described in
[JEP-214](https://github.com/jenkinsci/jep/blob/master/jep/214/README.adoc),
but I want to highlight some specific characteristics of the system.

**Privacy** is an important trait to both Daniel and I, and we designed this
telemetry system with that in mind. In Jenkins core, telemetry is captured and
sent as part of "trials." These trials must have a pre-defined start and end
date, which ensures that the Jenkins project **stops** collecting data after a
certain point in time. The trials are supposed to answer questions which drive
decision making, not provide behavioral or user-analytics. Instances which
opt-out of reporting anonymous usage statistics, naturally will not report
telemetry either.

Inside of the payloads sent to Uplink, we send an instance ID. The instance ID
allows us to de-duplicate, or observe how data changes within a given trial.
For additional privacy, we enhanced this system to generate a **different**
instance ID for each trial, preventing the ability to correlate behavior of a
single instance across different trials. I will also note that this enhancement
was added after telemetry had been initially released, but we went back after
the fact and transformed the instance IDs already in the database to apply our
privacy principles evenly.

On the server-side we have designed Uplink to make it easy to _delete_ data.
None our trials are old enough yet to warrant it, but since instances stop
sending data at a certain point, we can truncate tables once we're finished
implementing the fix which inspired the trial. Uplink also restricts access to
telemetry data to a very select group of people. Since this data could be
valuable for a developer working to improve Jenkins, Uplink allows for
trial-based access control. Should a developer create a new
`scripted-noncps-pipeline-usage` trial, we would be able to grant that
developer access to _only_ those events in the Uplink dashboard.

---

As an aside, I should mention that Uplink is the second [Feathers
JS](https://feathersjs.com) service which I have developed. The backend for
[Jenkins Evergreen](https://github.com/jenkins-infra/evergreen) being the
first. The framework has been enjoyable to use, and I would recommend it for
building simple little Node-based microservices.

---


For just about any piece of software, without information about how the
software runs in a real user's environment, it can be tricky to deliver changes
safely. Many people are familiar with this requirement for web applications
they own and control, but those distributing software don't tend to apply the
same principles of monitoring and continuous feedback. Adding feedback
mechanisms to software running on a user's machine can be done, but must be
done in a way that strives to protect their privacy and allows them to disable
it entirely.

With the Jenkins Telemetry system, and the Uplink backend service, I am
particularly proud of how we have balanced these concerns while enabling
developers to build a better Jenkins!
