---
layout: post
title: "On running containers in production"
tags:
- docker
- openinfra
- jenkins
---

As part of [SCaLE 15x](https://www.socallinuxexpo.org), I took part in the
first [Open Source Infra Day](http://scale.opensourceinfra.org) where a number
of other sysadmins and I shared stories and patterns which have helped us
maintain open source infrastructure. As part of the "unconference" tracks, I
suggested and then led the session "Running containers in production." As my
luck would have it, in a group of roughly 10 people representing various
groups, Jenkins was the only project running production services in
containers. I thought I should share what it's like, and why you should stop
standing on the sidelines and give containers in production a try.


Containers have suffered from an unreasonable amount of hype.  Which has caused
many people, myself included, to be exceptionally skeptical of their maturity
and utility in a modern infrastructure. Here's what containers, _by
themselves_, do **not** solve:

* Containers do not make your applications more secure.
* Containers do not make your applications more scalable.
* Containers do not make your applications more portable.

However, here is what containers can and **do** solve for:

* Containers make your applications "look" the same (mostly) to the underlying
  infrastructure.
* Containers make the application runtime dependencies the developers's
  responsibility.
* Containers require the application developers to consider application
  state and persistence.
* Containers, once built, provide a (mostly) consistent behavior between dev,
  staging, and production environments.


At this point, I won't _not_ use containers anymore. Their benefits far
outweigh their flaws, even in production environments. But there are flaws.


### Pros

The advantages of using containers are fairly well-documented across various
presentations, blog posts, and gushy tweets. For my usage, which is partly
personal and partly for the Jenkins project, the benefits are as follows.

#### Faster and easier application delivery

By using containers I enjoy much faster and easier application deployment,
without needing to change any existing infrastructure. In essence,
infrastructure which already exists and is capable of running a Docker
container is capable of running a JavaScript, Python, or Java applications
without any modifications.

For a mostly mixed infrastructure like that of the Jenkins project, this can be
hugely beneficial. For some applications newer, bleeding edge Java Runtime
Environments have been required, whilst others might need whatever basic JRE is
available. With the container including that form of system dependency within
it, the virtual machines running the containers don't need to know, or care,
about the mixed application runtime requirements and dependencies.

#### Defined "handoff" between developers and operators

Despite hype to the contrary, Operations is still a necessary specialization in
most organizations, the same as design, quality engineering, or product
management. That doesn't necessitate Ops "ownership" of applications, or their
implementations. The more freedom, and responsibility, which can be granted to
application developers the faster they will be able to build, test, and deploy
their applications.

In the case of an open source project like Jenkins, this is especially true.
Very few contributors have the experience, and trust, necessary to act as
infrastructure administrators. Those contributors do not have the time to
tend to, or "own", each application.

Containers provide a very logical, and realistic, "meeting ground" between
application developers and infrastructure admins. The most recent application
deployed for the Jenkins project,
[plugins.jenkins.io](https://plugins.jenkins.io) was developed as a Java/Jetty
backend and JavaScript frontend application. The "requirement" defined, by me,
was that it be delivered as a Docker container which, once created, could be
readily deployed to production.

This defined hand-off point gave the application developer a tangible
achievable goal, which is within his reach, to meet in order for his
application to be deployed.

As much as I would like to teach more people how to use Puppet, or Chef, most
developers have enough to cram into their brains without adding configuration
management to the mix.

#### Local development benefits

By endeavouring to build the application into a container, the application
developer can, for the most part, run the container _locally_ just as it would
run in the production environment. Not only does this make local development
easier, but it also empowers developers to take responsibility for and modify
the runtime environment to a greater degree than if the application ran
differently locally versus in production.

**NOTE**: By constructing hellish webs of inter-container dependencies, or
containers which require excessive amounts of environment variables, etc, this
advantage will be lost. A poorly designed or implemented application is still
going to be difficult to run, regardless of whether it's packaged in a
container or not.

#### Immutable delivery mechanism for Continuous Delivery

Continuous delivery of containers is most certainly a topic for a blog post
unto itself, but suffice it to say, it's amazingly easy with Jenkins these
days. The key benefit containers provide to a continuous delivery process is
**immutability**. Building a container provides an immutable object which can
progress through a pipeline towards production.

While this is also feasible with a `.war` file, or other application archive,
the inclusion of the runtime environment within the package ensures that the
runtime characteristics between a "testing", "staging", and "production"
environments are all the same.

In the `Jenkinsfile` for the [application referenced
above](https://github.com/jenkins-infra/plugin-site-api), one stage of the
defined [Jenkins Pipeline](https://jenkins.io/doc/book/pipeline) builds the
container, then the next stage _runs_ the container and performs some
rudimentary acceptance tests against that container. On at least one occasion
this has prevented the deployment of a genuinely broken application.


#### A growing ecosystem

The momentum behind the container ecosystem continues to grow, which means a
beleagured infrastructure administrator, like yours truly, can take advantage
of a myriad of tools and technologies to make life easier.  Technologies like
Kubernetes, especially on Azure or Google Container Engine (GKE), abstract a
*lot* away, in a good way, to where you can think of the service as opposed to
the specific implementation details of the application

For the Jenkins project's next major iteration of infrastructure on Azure,
we're deploying a Kubernetes environment to deploy all applications into,
thereby dramatically reducing the runtime footprint, and cost, of the dozen
little apps floating around. As part of that migration, we're deploying Fluentd
for log aggregation, and Datadog's Kubernetes support for thorough monitoring
of applications as well. All of this tooling comes together to allow us to
describe services, rather than processes, which are necessary for the business
of the project.

----

I believe, and now have proof to back it up, that by supporting containers in
production we (the Jenkins project) are able to support more varied
applications, with faster and more automated release cycles, than without
containers. If speed and reliability are **not important** to you, then it's
probably safe to continue not running containers in production.

----

### Cons

There is no such thing as free lunch, and as much as I would like to say
everything in containers is sunshine and rainbows, there are definitely some
growing pains, and issues with containers in production.

#### Docker networking is a hellscape

I will generalize here, because there is no "one container networking"
mechanism. Host networks, overlay networks, weave networks, etc. There's a lot
of ways to network containers together, whether in a cluster like Kubernetes or
on a single machine. _All_ of them rely on what I will broadly categorize as
"awful kernel networking tricks."

In the pre-Kubernetes days for the Jenkins project we are still orchestrating
the deployment of containers with Puppet on individual virtual machines. This
means we're taking advantage of overlay networks and trusting that the Docker
daemon will configure the appropriate `iptables` rules to expose our containers
to the external network interfaces. To put a finer point on it, this means the
Docker container is creating **N**etwork **A**ddress **T**ranslation rules (aka
Masquerading in iptables parlance) on the machine to get traffic in and out.

NAT is bad, and it should feel bad.

What we have observed over time, is that the Docker daemon cannot be trusted to
cleanly flush `iptables` rules as the container lifecycle changes. What
intermittently happens is: a service goes offline after a new deployment, because
the kernel is still NATing traffic from the external port 8080 to port 8080 on
an _old_ virtual IP address (`172.2.0.2`) instead of the _new_ virtual IP
address the new container was deployed with (`172.2.0.4`). When we look at the
`iptables -t nat -L` output, we see the `DOCKER` and `POSTROUTING` chains with
rules for **both** IPs, but the older one remains with a higher precedence.


Unfortunately this is "fucking impossible" (my words) to reproduce, so I
haven't been able to file a suitable bug report upstream.

This issue exposed a novel gap in our monitoring practices as well. Previously,
some applications had process checks, basically "is apache2 running? great,
everything is fine." When this issue manifests itself, the application
container is running properly, the process table will be correct, the issue
will hide in the `iptables` `nat` table and users will complain that the
application is unreachable.

The obvious take-away here is a known monitoring best practice: **monitor how
the user sees the application**, not how your infrastructure sees it.

Instead of checking that the process serving the web application is running,
running a `curl(1)` against the domain name, or external IP, actually validates
that the application is online and reachable, meeting the service contract for
your users.


#### Sometimes `dockerd` gives up

Running the Docker daemon, `dockerd`, for long periods of time is apparently
not a common practice, but we do it. As a result we have observed, on daemons
with heavy churn or high workloads, that `dockerd` periodically will
wedge/freeze/deadlock taking every container running on that daemon with it.
Running `strace(1)` shows the daemon waiting on a lock (`futex(2)`) which will
never resolve.

Unfortunately this also is "fucking impossible" (my words) to reproduce, so I
haven't been able to file a suitable bug report upstream.

This issue exposed another monitoring gap, checking that `dockerd` is running
is insufficient. Our docker monitoring must execute `docker` commands to see if
the daemon is responsive and doing what it should. While we haven't gone so far
as to automatically restart `dockerd` when this happens, it would be relatively
straight-forward to implement.


#### Disk space is finite

Containers typically will have some ephemeral and mapped storage, backed by a
storage backend configured in the daemon. I have tried both `overlayfs` and
`aufs` and seen similar behaviors of ever increasing disk usage, regardless of
what the application is doing. The behavior I have observed, but not dug too
deeply into, is that disk space allocated for the `aufs` backend, for example,
will only ever grow. It will not shrink, regardless of whether the application
is actually using the space or not. This seems to "reset" when the container is
stopped and removed however.

I believe we notice this acutely because we have long-running containers which
live on long-running virtual machines.


#### Orchestration and secrets

I have seen a lot of skepticism from my peers about tools like Kubernetes and
the hype surrounding them. Some of this skepticism is fair, but let me make
this much clear: **if you do not use a tool like Kubernetes, you will end up
building a shittier version of it.**

Containers being lightweight allows for over-provisioning virtual machines with
multiple containers per instance, and of course it would be silly to run just
one instance of an application so you need replicas, and of course you will
want some form of persistent storage for your applications, and all of a sudden
you're staring at the domain Kubernetes aims to address.

Additionally, managing secrets can be challenging with containers. It would be
bone-headed to bake a container with production SSL certificates, or API keys,
within it. Instead you will need a mechanism for injecting environment-specific
(testing, staging, production) credentials into containers. Without a tool like
Kubernetes, you will most certainly hack something up yourself to get secrets
into your containers, and it will most certainly be ugly.


----

You should no longer be afraid of using contianers in production. There are
certainly caveats and challenges to address, but I assert those downsides are
far outweighed by the benefits to the organization. Astute readers might be
wondering at this point when I will talk about containers and security, but
frankly, I don't see anything novel about security with containers. Firstly, do
not assume containers provide you any additional layer of security.  Secondly,
the patch lifecycle, while differently managed compared to traditional package
management, is still more or less the same.

I recommend investigating Kubernetes on Azure or Google Container
Engine, don't waste your time with Amazon's Elastic Container Service, and
start by deploying small stateless applications and slowly work your way up to
beefier stateful monoliths.

But do remember, there are no silver bullets. There will be flaws and
challenges, but adopting containers in production will encourage more
automation and continuous delivery of applications, lead to broader
delegation of responsibilities, and allow infrastructure people to focus on
infrastructure rather than applications.
