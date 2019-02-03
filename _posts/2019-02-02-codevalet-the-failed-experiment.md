---
layout: post
title: "Even a failed experiment teaches you something"
tags:
- jenkins
- codevalet
---

The [most recent Jenkins security
advisory](https://jenkins.io/security/advisory/2019-01-28/) contains a fix for
an issue in the [GitHub Authentication plugin](https://plugins.jenkins.io/github-auth). One
which I reported many moons ago, during an experiment I named "Code Valet."
Seeing the issue finally resolved brought fond memories back into my mind and I
realized that I have never really reflected and shared what it was and more
importantly: why it failed. At it's core, Code Valet was intended to solve two
fundamental problems: firstly, I wanted a [Jenkins
Pipeline](https://jenkins.io/doc/book/pipeline/) as a Service, since I find
Jenkins Pipeline to be a very useful tool, which I wanted for _all_ my open
source projects. Secondly, the Jenkins
project needed to shift its footing towards a continuous feedback and
continuous delivery model. Code Valet aimed to solve both of these problems.


Years ago, CloudBees had tried to run "Jenkins as a Service" with its now (finally!)
defunct "DEV@Cloud" service, or in a different manner with Kohsuke's "Buildhive" project. DEV@Cloud
provided users with a _full_ Jenkins installation, which I believe was part of
its undoing. The essential balancing act of developer tools is that we must
provide our customers with enough power and flexibility, but not so much that
they shoot themselves in the foot.  Providing a full Jenkins installation to
many people is not only giving them the gun, but loading it, pointing it at
their foot, and then daring them not to shoot. Jenkins is **powerful** but
unfortunately it can become unwieldy and a support nightmare.  "Jenkins
Pipeline as a Service" meant something different to me, Code Valet would allow
users to run Pipelines but not actually _administer_ the instance. In fact, I
made explicit design choices to prevent end-users from even seeing too much
behind the curtains of Code Valet. I consider myself an expert at configuring
and operating Jenkins, and everything in Code Valet was tuned appropriately for
the users already, nothing on an administrative level was necessary.  In fact,
the user experience was also intentionally locked into [Blue
Ocean](https://jenkins.io/projects/blueocean/), and it was actually impossible
to do anything but create Pipelines and run them. For my own open source
projects this was _perfect_, I could easily add a `Jenkinsfile` to my GitHub
repositories, and things just worked!


To address the second problem, Code Valet's Jenkins image was **bleeding
edge**. Not in the way [Jenkins
Evergreen](https://jenkins.io/projects/evergreen) is bleeding edge, but more
Gentoo Linux-style. Jenkins core was **built daily** from the `HEAD` of the master
branch. The batteries-included plugins were also **all built daily** from their
respective master branches. The Git plugin, Azure VM Agents plugin, Pipeline
plugins, _everything in the system_ was the absolute latest. As you may have
guessed, this resulted in dozens of interesting build and runtime failures,
all of which were reported upstream. For the first time, I had an environment which was
providing "real world" SaaS-style feedback, using [Sentry](https://sentry.io)
on _real_ Jenkins workloads.


Code Valet operated as an interesting experiment out of the CloudBees CTO
office for 4-5 months before I ultimately shut it down. There was nothing more
to learn, and it was clear Code Valet did not have any immediate future within
the CloudBees product roadmap.

### Lessons

For my taste, that bleeding edge turned out to be a little too
bloody. I filed two dozen tickets for various plugins, some of which were
addressed very quickly, and others remained open for weeks, some still remain open. Rapid feedback is
only useful with rapid(ish) iteration.  Like many large and federated open
source communities, the Jenkins project suffers a bit from uneven levels of
investment across the plugin ecosystem. For example, while Microsoft's
developers were very responsive to issues discovered in their Azure plugins,
another plugin integral to Code Valet was maintained by one person who might
address issues once in a while if work wasn't too hectic. By no means to I
fault maintainers for not being responsive for volunteer projects, but building
a complex system from components with disparate levels of maturity can be
painful. Fortunately, many of pains from release management with Code Valet
went on to inform and improve the design of what came after: [Jenkins
Evergreen](https://github.com/jenkins-infra/evergreen).


Before I built Code Valet, I could have likely filled half a book with thoughts
and practices on good security for Jenkins. Originally designed with
internal development teams in mind, running Jenkins on a hostile network like
the public internet is an uphill battle, updating default configuration
settings, disabling functionality to reduce the attack surface area, and
ensuring security best practices are being enforced and adhered to by the
users. In the case of Code Valet, everything got _far more challenging._.
Combine the existing lock down procedures for a Jenkins on the public internet,
and then add the requirement to lock down Jenkins far beyond what it natively
supports in order to provide users with that limited "Jenkins Pipeline as a
Service" experience. I ended up writing a significant amount of Groovy code to
configure and adjust settings throughout Jenkins, as [Configuration as
Code](https://jenkins.io/projects/jcasc/) didn't yet exist. At times
this still wasn't enough, and I resorted to clever container or nginx hacks to
disable, hide, or otherwise obfuscate certain aspects of Jenkins' behavior.
[All of these hacks](https://github.com/codevalet/master) I still consider to
be rather clever, but trying to reduce the surface area of Jenkins is an
endless struggle. The system yearns to be extended in new and different ways,
so it's a constant game of whack-a-mole trying to close things up. Locking down
Jenkins Pipeline alone is arguably an impossible task, something not even my
[silly Pipeline Shared
Library](/2017/08/03/overriding-builtin-steps-pipeline.html) hacks could
manage.


The cost model for Code Valet was never something I expected to be
net-positive. In discussions I would refer to it as a "loss leader", something
to drive adoption of Jenkins Pipeline with a calculated user acquisition cost.
Still, Code Valet was deployed onto Kubernetes (AKS) and very intentionally
restricted to reduce overhead and per-user cost wherever possible. Tightly
packing Jenkins master containers into Kubernetes, and then dynamically
provisioning Azure VM and container agents for workloads remain design patterns
I stand by for cheaply running Jenkins-as-a-Service, but Jenkins is
undoubtedly **huge**. I could not get decent performance in a low enough memory
and CPU footprint for Code Valet _not_ to be a loss leader. And while Kohsuke's
Buildhive project was, if I recall, running one big multi-tenant Jenkins
instance, Code Valet by design used per-user instances. The exact numbers I
cannot remember, but I spent my time thinking of more and more novel yet
non-invasive ways to reduce the monthly cost per user. Looking across the
market today, it is evident how punishing the race to the bottom for price on
CI-as-a-Service products has been. Most vendors spend a non-trivial amount of
time finding ingenious ways to arbitrage with AWS Spot Instances or other
means of shaving pennies off compute-hours where possible. This was all very
competitive even before GitHub Actions showed up on the scene and dropped the
bottom out of the market entirely. In my opinion, developer tools has always
been a challenging market to work in. Developers inherently undervalue their
tools, recognizing the importances of a $3000 laptop or a $1000 chair to daily
productivity, we still balk at $15/month services or licenses which would
otherwise improve our lives.


Early in 2018, CloudBees acquired [Code Ship](https://codeship.com), bringing
onboard a great product and engineering team, but also a pretty good
CI-as-a-Service offering. While Code Ship doesn't speak Jenkins Pipeline, it
was already quite a mature product with significant market traction, helping
close the book on the Code Valet experiment.


---


The CI/CD landscape in 2019 is littered with various forms of declarative and
turing-complete YAML. I still find myself wanting a Jenkins Pipeline as a
Service because I still fervently believe that Pipeline is a good tool. The
modelling capacity is better than anything else, and the extensibility options
are superb, whether with Shared Libraries, or a variant my pal [James
Dumay](https://github.com/i386) prototyped which never made it out
of the lab.  That said, running a large Jenkins infrastructure no longer
appeals to me. There's a very good reason why CloudBees builds and sells their
[CloudBees Core](https://www.cloudbees.com/products/cloudbees-core) product:
scaling Jenkins CI/CD as a service is **hard**. For something intended to be
generally available like Code Valet, I would now argue that it is
**impossible** to do with off-the-shelf Jenkins.


The direction Pipeline is heading, driven by one of the chief architects of
Jenkins Pipeline [Andrew Bayer](https://github.com/abayer) is looking more and
more _parseable_ which may leave the door open to alternative runtime engines
for Jenkins Pipeline in the future. To me that is key for a descendant of Code
Valet. With an execution engine designed for the needs of a
Pipeline-as-a-Service offering, Jenkins Pipeline would more easily be supported
from a security, maintainability, and cost standpoint.


Ultimately I think the biggest lesson I learned from Code Valet was to think
**bigger**. I started out using Jenkins as the runtime for Code Valet because
Blue Ocean already existed, Jenkins Pipeline already existed, all these things
were built already, albeit for a very different purpose. I intentionally
steered away from building a new engine because I figured it would be too
much work. Some months after I first created Code Valet, I ended up writing a
parser for Jenkins Pipeline's and a basic execution engine. While neither were
complete, I was surprised with how little effort it took to built a basic
Jenkins Pipeline from scratch, compared to the effort of reducing Jenkins to
something smaller.


Rather than trying to use a swiss-army knife as a sword, it may be a better
idea to melt it down and simply forge anew.
