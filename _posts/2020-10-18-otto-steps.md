---
layout: post
title: "Moving again with Otto: Step Libraries"
tags:
- rust
- otto
- cicd
---

I have finally started to come back to [Otto](https://github.com/rtyler/otto),
an experimental playground for some of my thoughts on what an improved CI/CD
tool might look like. After setting the project aside for a number of months
and letting ideas marinate, I wanted to share some of my preliminary thoughts
on managing the trade-offs of extensibility. From my time in the [Jenkins](https://jenkins.io) project,
I can vouch for the merits of a robust extensibility model. For Otto however, I wanted to implement something that I would call "safer" or "more scalable", from the original goals of Otto:

> *Extensibility must not come at the expense of system integrity.* Systems which allow for administrator, or user-injected code at runtime cannot avoid system reliability and security problems. Extensibility is an important characteristic to support, but secondary to system integrity.
>
> *Usage cannot grow across an organization without user-defined extension.* The operators of the system will not be able to provide for every eventual requirement from users. Some mechanism for extending or consolidating aspects of a continuous delivery process must exist.


Starting with Jenkins and Jenkins Pipeline as a frame of reference. I do this
not only because I am intimately familiar with how it works, but also because
Jenkins Pipeline is the most successful and widely adopted pipeline modeling
language. Key to its success are "steps." There are a number of default steps
provided by the system and new plugins introduced on the controller provide new
steps for users. The "execution environment" for steps in Jenkins Pipeline is
however incredibly confusing. If I were to interview a Jenkins developer or
administrator, I would give them a sample `Jenkinsfile` and ask them to explain
to me what is executing _where_ as the pipeline progress. In essence, steps can
execute code on _both_ the controller and the agents, hopefully with users
never knowing about the quirks of the runtime dance between the two.

For Otto's pipeline language, I wanted steps to have a perfectly clear
execution environment: **agent only**. Along with this are a number of other requirements that I have in mind:

* Language-independent: I want steps to be implemented in whatever language a
  developer sees fit. Therefore the tooling needs remain flexible enough to
  distribute and execute Python-based steps as well as native compiled steps.
* Statically verifiable: A step invocation in a pipeline should be verifiable
  _without_ actually executing the step. That is to say, it should be known
  _before_ execution whether parameters and types are correct.
* Lowest necessary privilege: Steps shouldn't be able to "know" anything about
  the system, credentials, configuration, etc, without an administrator or user
  being aware. If a step needs to access a shared configuration variable, it
  must self-declare that requirement. Steps should never be allowed to simply
  poke around in global variables or configuration of the environment.


The approach I'm settling on with "step libraries" is that each step is a
package (`.tar.gz`) containing a [manifest
file](https://github.com/rtyler/otto/blob/d820a75ed5be8b1a400652ae518eae22db32d5d7/rfc/0011-step-library-format.adoc#manifest-file)
and whatever other assets it requires to execute. The manifest file contains
the description of the parameters, the entrypoint, and configuration values the
step may require.

At runtime, the step's `entrypoint` will always be invoked with a single
[invocation
file](https://github.com/rtyler/otto/blob/d820a75ed5be8b1a400652ae518eae22db32d5d7/rfc/0011-step-library-format.adoc#invocation-file)
that contains all the information necessary to execute the step correct. For
this I debated a couple different approaches: setting environment variables,
piping JSON data into the process, or even having the processes request a JSON
payload of data from a central server. I ultimately decided on the invocation
file approach since that requires the least system knowledge for the step to
actually be executed by an agent.

The role of the agent in this process remains fairly simple, regardless of which steps are being executed:

* Consider the steps which it should execute. (e.g. `echo`, `sh`, `junit`)
* Retrieve the appropriate step library artifacts, originally this is going to be from a centralized store but I can easily imagine an agent retrieving "remote step libraries" in a distant future.
* Unpack the step libraries
* Validate that the step libraries support the parameters specified by the user's pipeline.
* Iterate through the steps and execute the `entrypoint`.

In [this
commit](https://github.com/rtyler/otto/commit/a5de9294aa4cbd75d8ea1cc6be6c4471786c7eb4)
I managed to get something dumb and primitive working with this model. Excusing
the `STEPS_DIR` hack to avoid needing to reach out to fetch steps, the basic
test pipeline referenced in the commit contains the essence of how I believe
step libraries can provide a powerful and _safe_ extensibility model for Otto.


---

There are still a number of open questions I need to answer:

* How will credentials be accessed by a step in a secure manner?
* How will I balance the trade-off of "bring your own step libraries" with
  "don't leak credentials." Right now I'm thinking about "trusted" versus
  "untrusted" step libraries, and everything user-defined would be untrusted
  unless added to an "allow" list by an administrator.
* For more complex step parameters, like files, how well will the invocation file format hold up?
* How should steps affect the flow control of a pipeline? Conventionally a
  non-zero exit of a step will halt the pipeline in Jenkins, but is there a
  more granular flow control system that can be extended to steps which are
  defined in a step library?


---

Despite sparingly little free time, I am enjoying getting back into this part
of Otto. I had let myself fall into a tar pit of distributed systems problems
and stalled any progress with Otto. Bringing the focus back to the pipeline
model and extensibility has allowed me re-focus on some of the challenges
unique to the CI/CD space.


If you're curious to learn more, you're welcome to join `#otto` on the
[Freenode](https://freenode.net) IRC network, or follow along on
[GitHub](https://github.com/rtyler/otto)

