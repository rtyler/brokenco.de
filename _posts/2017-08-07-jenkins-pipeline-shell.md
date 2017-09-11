---
layout: post
title: "A genuinely terrible abuse of Jenkins Pipeline"
tags:
- pipeline
- jenkins
---


I consider myself one of the world's foremost experts in terrible ways to use
[Jenkins](https://jenkins.io/), partially because my brain is awash with awful
ideas, but also because I have been around the project long enough to see
hundreds of different "clever" (ab)uses of Jenkins. Today I thought I would
share something I came up with a few weeks ago which, to date, might be one of
my more deplorable creations.


**If you are responsible for a Jenkins instnce, please ensure your plugins are
upgraded in accordance with [this security
advisory](https://jenkins.io/security/advisory/2017-08-07) immediately**.

----

**DISCLAIMER**

> Jenkins, like many other CI/CD tools, runs code typically stored in a source
> control repository. If you cannot trust people to run "arbitrary" code in your
> CI/CD environment then you should reconsider whether you trust them to commit
> to the repository. This is especially important with pre-merge validation
> like that conventionally performed on pull requests. If running "arbitrary"
> code on your CI/CD infrastructure makes you queasy, I strongly recommend
> reconsidering your security model, particularly how long instances live, and
> where secrets are stored.

----


[Jenkins Pipeline](https://jenkins.io/doc/book/pipeline) is an incredibly
useful tool for codifying continuous delivery pipelines in code
(`Jenkinsfile`). Made popular with the Jenkins 2.0 release last year, I can
honestly say that I no longer allow "Freestyle projects" in the Jenkins
environments I manage. It's so fundamentally better than what preceded it, that
I do not wish to ever return to configuring jobs manually in Jenkins.

Jenkins Pipeline exists in two forms, Declarative and Scripted Pipeline, both
of which are, in essence, domain-specific languages. Also known as "code."

Since it is just "code", it can be abused! Lo and behold, Pipeline Shell:

    #!/usr/bin/env groovy

    def label = input(message: 'Pick an agent:', parameters: [string(defaultValue: '', description: 'Agent name or label', name: 'Agent')])

    node(label) {
        def lastCommand = 'ls'
        while (true) {
            lastCommand = input(message: 'Execute on the host:', ok: 'Run', parameters: [string(defaultValue: lastCommand, description: '', name: 'Command')])

            sh(returnStatus: true, script: lastCommand)
        }
    }

([click here for the terribad hosted on
GitHub](https://gist.github.com/rtyler/6f4993999c1ff03226abb22edcb9486a))

The Scripted Pipeline above (ab)uses the `input` step which blocks the
executing Pipeline until a user provides input. The `input` step is
fantastically useful for authorizing a deployment or providing some form of
user input mid-Pipeline. With some built-in semantics of Groovy, I can loop
over the `input` step, and naturally, this means I can run an infinite number
of commands. Additionally, as the screenshot below demonstrates with [Blue
Ocean](https://jenkins.io/projects/blueocean), execute the command and receive
the output from a machine in my Jenkins environment.

![Jenkins Pipeline Shell](/images/post-images/jenkins-pipeline-abuse/blueocean-shell.png)

How unabashedly awful. At the same time, I can think of a good half-dozen
ways in which this pattern can be very useful too! With great power comes
great... something or other.

For example, if you have ever had to debug issues on a long-lived Jenkins agent
hosted behind a firewall (or something which runs an agent but has no `sshd`),
this could be very helpful! Of course, if you're trusting a firewall to provide
some protection against the workloads running on a Jenkins agent, this coulde
be very terrifying (and, by the way, your security model would be incorrect if
you're relying purely on network security here).

Or perhaps the build takes an eternity, and something goes haywire, but only in
Jenkins, right in the middle of the Pipeline. Dropping in this little `input`
loop gives you a tool to investigate the agent's filesystem and state
mid-Pipeline run.

Or what about when you're bored, and you just want to watch the world burn?

----

**NOTE**: Don't ever run **any** CI/CD workload from a developer on a network
who you wouldn't trust to have direct access to said network.  You're running
"arbitrary" code for crying out loud.

----

Regardless of how you feel about this abuse of the Pipeline DSL, please consider
how you felt when your eyes scanned over the dozen or so lines of Scripted
Pipeline. If this made you feel nervous please remember that:

**all CI/CD systems run arbitrary code from source control.**

Your CI/CD environment should work with this assumption as a central part of
the security model. If you cannot trust the `Jenkinsfile` from the source
repository, why can you trust the `Makefile`?

I strongly recommend [this presentation from
Blackhat](https://www.blackhat.com/docs/eu-15/materials/eu-15-Mittal-Continuous-Intrusion-Why-CI-Tools-Are-An-Attackers-Best-Friend.pdf)
a few years ago. While some of the criticisms of Jenkins were
fixed as of Jenkins 2, the fundamental security concerns of running "arbitrary"
code on machines is still relevant to the discussion here.

People sometimes joke that Jenkins is "cron with a web UI", but I will
typically refer to it as "remote code execution as a service." A statement
which garners some uncomfortable laughs. If you're not thinking of
CI/CD systems like Jenkins, GoCD, Bamboo, GitLab, or buildbot as such, you
might be sticking your head in the proverbial sand, and not adequately
addressing some important security ramifications of the tool.
