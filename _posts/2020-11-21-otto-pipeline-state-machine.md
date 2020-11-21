---
layout: post
title: "Noodling on Otto's pipeline state machine"
tags:
- otto
- cicd
- rust
---


Recently I have been making good progress with
[Otto](https://github.com/rtyler/otto) such that I seem to be unearthing one
challenging design problem per week. The [sketches of Otto pipeline
syntax](/2020/11/06/pipeline-syntax-for-otto.html) necessitated some internal
data structure
[changes](https://github.com/rtyler/otto/commit/d92a72ec7dd78968df863d9d90f553c98871c625#diff-0118f6d77d9de58413a5a5c50e6eaa7015c344e025a1d16d86cc54f661713d0f)
to ensure that to right level of flexibility was present for execution.  Otto
is designed as a services-oriented architecture, and I have the parser service
and the agent daemon which will execute steps from a pipeline.  I must now
implement the service(s) between the parsing of a pipeline and the execution of
said pipeline. My current thinking is that two services are needed: the
Orchestrator and the Pipeline State Machine.

For this blog post I discuss much of what the Orchestrator should do other than
to mention that I intend Orchestrators to exist to provision resources and
launch agents for executing pipelines.

The Pipeline State Machine (PSM) is where the real fun starts. Somewhere inside
Otto, something **must** keep track of the progression of a pipeline from one
state to another, ensuring that the right actions are being triggered when
certain state transitions occur.

## States

The current structure of the internal pipeline model informs the potential
states in the state machine: 


```yaml
---
uuid: 'some'
batches:
  - mode: Linear
    contexts:
      - uuid: 'uuid-context'
        properties:
          name: 'Build'
        environment: {}
        steps:
          - symbol: 'sh'
            uuid: 'uuid-step'
            context: 'uuid-context'
            parameters:
              - 'pwd'
  - mode: Linear
    contexts:
      - uuid: 'uuid2-context'
        properties:
          name: 'Test'
        environment: {}
        steps:
          - symbol: 'sh'
            uuid: 'uuid2-step'
            context: 'uuid2-context'
            parameters:
              - 'make test'
```

"Batches" are a concept which will exist
internally to Otto to help handle parallel stages and other novel groupings of
steps. Referring back to the "sketches of syntax" post, a `parallel` or
`fanout` block would result in a single Batch. Inside that Batch would be a
Context for each `stage` declared, allowing some flexibility between the
internal representation of a Pipeline and the user-visible declaration.



I believe that each Pipeline will largely
need to progress through the states defined below. 

* **Pending**: requires full model and uuid, basically the output from the Parser.
* `for batch in batches`
  * **Auction Started**: with list of contexts that have been auctioned
  * **Auction Completed**: with list of contexts and the winning Orchestrator for each context.
  * **Provisioning**: mapping each context to an Orchestrator who should be provisioning the resource(s) necessary to execute that context.
  * **Execution(context)**: each context has its own state of: Pending/Running/Failed/Aborted/Unstable/Success
  * **Batch Complete**
* **Pipeline Complete(status)**

"Auctions" refer to the planned [resource
auctioning](https://github.com/rtyler/otto/blob/main/rfc/0003-resource-auctioning.adoc)
work I wish to explore at a later date; the first version of PSM will likely
omit these states.


The requirements for PSM I have in mind are:

* It should receive and store the entire pipeline model (YAML above). I am not
  yet should what the exact interplay between source control and PSM should be.
  I have [an issue](https://github.com/rtyler/otto/issues/11) which mentions
  the service which will ingest GitHub Webhook payloads. My current thinking is
  that this service should perhaps be responsible for handling the webhook
  payload _and_ fetching the `Ottofile` in order to send a request to the
  Parser and then PSM.
* It should hold the mapping between a given pipeline `uuid` and the states listed above.
* It should fire events for each state transition.


Some requirements I am not yet certain of are:

* Does it need to know which orchestrator or who is actually executing on a
  context or batch?
* Should PSM contain a mapping of a commit revision to pipeline uuid to help
  with de-duplication of pipelines for identical commits? 

Looking at the shape of PSM is like a inspecting a building in the distance. I
have a general idea of its dimensions and key characteristics, but the details
remain blurry no matter how hard I squint.


---

This phase of Otto's development has certainly been the most frustrating in
months. I'm pushing towards enough service integration to allow for a Otto to
perform basic self-hosted CI. To accomplish this I will need:

* A service ingesting webhooks and fishing the `Ottofile` out of the latest commit on a given branch.
* ☑ The Parser service, which turns an `Ottofile` into a usable internal model.
* A Pipeline State Machine to manage the execution of the pipeline.
* A basic Orchestrator which can dispatch a local `otto-agent` with the appropriate arguments.
* ☑ An object store service to contain logs, artifacts, and step libraries.
* ☑ An agent capable of executing steps.
* ☑ Defined steps to check out a source repo.

For the most basic self-hosted implementation, I don't even think I need a
GUI/dashboard or an eventbus, both of which are in the "grand vision."

Much of what remains requires "big think" time however, which is in short
supply. Every time I sit down to the problem, I spend a non-trivial amount of
time debating whether I am over-complicating this before I am able to
re-convince myself of the approach I am taking here.

The curse of working in [Jenkins](https://jenkins.io) for so long is that I
know how so many CI system design decisions ultimately run into limitations for
certain use-cases.

Regardless of how challenging the path ahead appears, I will inch along, slowly
but surely. :)

---

As always, if you're curious to learn more, you're welcome to join `#otto` on the
[Freenode](https://freenode.net) IRC network, or follow along on
[GitHub](https://github.com/rtyler/otto)

