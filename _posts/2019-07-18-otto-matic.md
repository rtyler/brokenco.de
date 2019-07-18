---
layout: post
title: "Modeling continuous delivery"
tags:
- otto
- pipeline
---

I spend more time than I wish to admit thinking about how continuous delivery
(CD) processes should be modeled. The problem domain is one that affects every
single organization which distributes software, yet the approach each
organization takes is almost as unique as the software they develop. From my
perspective [Jenkins Pipeline](https://jenkins.io/doc/book/pipeline),
especially its declarative syntax, is the best available option for most
organizations to model their continuous delivery processes. That does not
mean however that I believe Jenkins Pipeline is the best _possible_ option.


In the small amount of "open source time" which isn't already committed to
maintaining Jenkins project infrastructure, I have been exploring some ideas in
a project named "[otto](https://github.com/rtyler/otto)". I have been trying to
learn from our collective experiences developing and adopting Jenkins Pipeline.
Trying to imagine what a good next step of "pipeline" development might look like.

---

A quick note about **YAML**: A lot of people have adopted YAML syntaxes because
they're "simpler." A premise which is fundamentally out of alignment with
reality. The YAML syntaxes which I have seen for representing branching logic, abstraction, or reuse are incredibly error-prone and confusing. Often times
relying on common strings to reference a conceptual graph which is itself
difficult to describe with YAML alone. YAML is not bad as a declarative
language for describing data, but modeling something as complex as
continuous delivery, I do not believe is passable with YAML.

---


When I consider the continuous delivery process, I think _all_ tools should
strive to meet the following requirements:

* **Deterministic ahead-of-time**. Without executing the full process, it must
  be possible to "explain" what will happen.
* **External interactions must be model-able.** Deferring control to an
  external system must be accounted for in a user-defined model. For example,
  submitting a deployment request, and then waiting for some external condition
  to be made to indicate that the deployment has completed and the service is now
  online. This should support both an evented model, wherein the external service
  "calls back" and a polling model, where the process waits until some external
  condition can be verified.
* **Describe/reference environments.** All applications have at least
  some concept of environments, whether it is a web application's concept of
  staging/production, or a compiled asset's concept of debug/release builds.
* **Branching logic**, a user must be able to easily define branching logic.
  For example, a web application's delivery may be different depending on
  whether this is a production or a staging deployment.
* **Safe credentials access**, credentials should not be exposed to in a way
  which might allow the user-defined code to inadvertently leak the credential.
* **Caching data between runs** must be describable in some form or fashion.
  Taking Maven projects as an example, where successive runs of `mvn` on a
  cold-cache will result in significant downloads of data, whereas caching
  `~/.m2` will result in more acceptable performance.
* **Refactor/extensibility support in-repo or externally.** Depending on
  whether the source repository is a monorepo, or something more modular.
  Common aspects of the process must be able to be templatized/parameterized in
  some form, and shared within the repository or via an external repository.
* **Scale down to near zero-configuration.** the simplest model possible should
  simply define what platform's conventions to use. With Rails applications,
  many applications are functionally in the same with their use of Bundler,
  Rake, and RSpec.


Quite the laundry list! The two biggest departures from what Jenkins Pipeline
would be the ability to model external interactions and determinism.

Modeling external interactions is something which I think _many_ approaches to
modeling continuous delivery simply fail to acknowledge. Every tool wants to
act as if it is the center of the universe, and they can't _all_ be the center!
In order to effectively model external interactions, the language alone is
insufficient, the runtime must participate. Imagine a scenario where
validation of a deployment occurs via an external system. The pipeline would
necessarily be paused, pending an external callback or something along those
lines. This means the language itself has to represent the callback in some
way, but the runtime has to allow for an event to continue the pipeline's
execution. All without consuming resources, like a VM or container in the meantime.

The approach for most current systems is:

 * provision VM
 * install dependencies
 * run user-provided scripts
 * check status
 * end, stop VM


Basically in order to do "anything", resources must be allocated and maintained
until the stage or entire pipeline completes. In order to "wait" for some
condition to be met by an external system, a busy loop must tie up an allocated
resource (VM) in this example.

The current syntax I'm playing with explicitly separates these logical gates
from the runtime allocation:


```
      stage {
        name = 'Production'
        environment -> production

        gates {
          enter {
            input 'Are you extra sure that staging looks good to you?'
          }

          exit {
            /*
            * The system must have some form of tagging of this specific run,
            * to allow an external system to call back and say "this is good and
            * finished"
            */
            webhook {
              description = 'Pingdom health check'
            }
          }
        }

        docker {
          image = 'ruby'
        }

        steps {
          // This is contrived and incorrect, but irrelevant to the example
          sh 'rake deploy-prod'
        }

        notify {
          failure {
            slack 'Failed to ship it'
          }
          complete {
            slack 'New changes are live in production'
          }
        }
      }
```


The mechanics still need some protoytping to figure out, but this is the gist
of what's bouncing around my brain at the moment. Gates must be separate from
the runtime by default to allow deferred control to another system.


---


I have also been thinking about how a CD process models the logical concept of
"environments". In most cases, I would have an environment constructed and
managed externally. The two most common examples I can think of are:

* Infrastructure environments are defined in a cloud provider, e.g. Azure, by
  some other infrastructure as code (or whatever), and my web application delivery process
  only needs to be aware of them.
* Mobile application development, e.g. Google Play Store, where an "alpha",
  "beta", and "general" channels are available for releasing an Android
  application into. These are out of the control of my mobile application
  pipeline, but still hugely relevant to the process.


In both scenarios, the commonalities that I see and feel warrant modeling would
be:

* Deployment credentials, different signing keys or API tokens.
* Compile flags
* Test/validation settings, e.g. different hostnames for where things will end
  up or be pushed to.


The big difference between the two examples of environments above is how one
progresses from on environment to the next. It could be a simple automated
check, an external set of synthetic transactions, feedback from a monitoring
tool, or a manual intervention by a developer/QE/etc. The latter is especially
common with mobile or desktop applications.

Imagining a single declarative `.otto` file with:

 * named environments for the application to progress through, complete with
   various settings and metadata defined for those environments.
 * a stage in the pipeline which describes the entry and exit gates necessary
   to being and complete the process.

I'm not sure modeling with environments _needs_ to be much more complex than
that. The way an operations team might conceive of an environment may be
different from an application team. They both conceive however when it comes to
hostnames, settings, and credentials.

I won't share a syntax snippet for environments at the moment since I'm not yet
happy with it. But I'm very interested in how other people think of modeling
environments, and what characteristics of those environments are important for
their continuous delivery process.

---


My work thus far includes a full grammar for the description language that I've
been exploring, and with each passing week the parser and runtime to support
it come a little bit closer to reality. I've got a clear model in my head of
how the different components fit together, how extensibility can be supported
without sacrificing determinism, and how to secure it.

The only _real_ challenge has been finding the time to build it.


