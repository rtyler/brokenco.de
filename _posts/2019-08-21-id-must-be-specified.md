---
layout: post
title: The Configuration as Code plugin and "id must be specified" errors
tags:
- jenkins
- job-dsl
- casc
---

Yesterday we rebuilt and re-deployed one of the Jenkins containers we use at
work, and much to my chagrin the Jenkins environment no longer wanted to boot.
We use Jenkins on top of Kubernetes, integrated with [Hashicorp
Vault](https://www.vaultproject.io/),
configured with the [Configuration as Code
plugin](https://github.com/jenkinsci/configuration-as-code-plugin) and the [Job
DSL plugin](https://github.com/jenkinsci/job-dsl-plugin). While I am pleased
with this stack of tools, it is _not_ a "simple" set up.  It had been three
weeks since the last rebuild and redeploy, and the name of the game was: what
of the dozen changes that have happened in one of these tools over the last
three weeks was the culprit.

Any time Jenkins fails to boot, I immediately consult the daemon's log. The
[beginning of the
log](https://gist.github.com/rtyler/47233978223019cf5fa4714f8e8836d7) looked
mostly normal except for these sort of lines at the top:

    WARNING: Configuration import: Found unresolved variable GITLAB_TOKEN. Will default to empty string

Meanwhile at the _bottom_ of the logs were the [actual
stacktraces](https://gist.github.com/rtyler/ecc54a59cdb2ed17f8d46db3746c41bd)
which caused Jenkins to stop. The way I understood the stacktraces at the
bottom of the logs, was that they were relating to these warnings at the _top_
of the logs. The Job DSL script being used was referencing this credential
configured from the `GITLAB_TOKEN` variable.


My primitive monkey logic was: a warning that a secret variable is not present
must mean that Jenkins is not getting secrets from Vault, and therefore the
credential ID being referenced in the Job DSL script is empty causing a
problem.

Looking more seriously at Vault, my leading hypothesis was that we had recently
added secret strings which were tripping up the secret parsing in the Jenkins
Configuration as Code plugin. The plugin is what actually connects to Vault,
fetches secrets, and makes them available as variables for expansion in its
configuration YAML. My first step was to [make the log level much more
granular](https://gist.github.com/rtyler/55bf0a912287094deb2e55589e537911) to
see if Jenkins and Vault were still communicating properly. Sifting through 6MB
of logs, I confirmed that communication with Vault was in tact.

The build of our Docker container defaults to take the latest plugins at
build time. Some might consider this risky, but I believe that it's better to
risk upgrades, than to fall behind on Jenkins plugin versions which itself can
be a difficult hole to dig out of. I noticed in our build logs that the
Configuration as Code plugin upgraded from 1.24 to 1.27 between the two
built versions of the container. The [release
notes](https://github.com/jenkinsci/configuration-as-code-plugin/releases) for
1.25 looked suspicious as there were secrets related changes, but mostly in the
context of the "Export" functionality that the plugin supports. Either way, I
tried using the old version of the container and that _still_ didn't seem to
work for some reason!


It _had_ to be Vault, I concluded.


The next rock I looked under was whether the secrets were malformed in Vault.
With help from a member of our security team, we started spelunking around in
Vault and even tried deleting some secrets recently added. That didn't appear
to be the issue either!

At this point in the afternoon, I was pretty annoyed. Nothing made sense. I did
a little bit of a mental reset and decided to bring the Vault configuration to
my local machine and started testing out with a purely ephemeral version of the
container, e.g. `docker run --rm -ti myjenkins`.


In my local environment, I was able to boot the old version of the container,
but not the new version of the container. I was also unable to boot a newer
version of the container with an explicitly pinned 1.24 version of the
configuration as code plugin. Mysteries abound! In this local testing what I
noticed was that I was still seeing these warnings:

    WARNING: Configuration import: Found unresolved variable GITLAB_TOKEN. Will default to empty string

Yet, the credentials would still show up properly in the instance. The
Configuration as Code plugin was warning about secrets but they still managed
to show up anyways. This smelled quite fishy to me, and I posited in the
[configuration-as-code-plugin Gitter
room](https://gitter.im/jenkinsci/configuration-as-code-plugin) that there's a
race condition related to the fetching of secrets from Vault and the
configuration that the plugin is trying to set. With this hypothesis in place,
I returned to the bottom of the log where the Job DSL plugin stacktrace was:

    Caused by: javaposse.jobdsl.dsl.DslScriptException: (script, line 37) id must be specified

Between the old and new versions of the container, the Job DSL plugin went from
1.74 to 1.75. By pinning the Job DSL plugin back one version ended up resolving
the issue! Noticing and reading **[this migration note for 1.75 confirmed the
problem](https://github.com/jenkinsci/job-dsl-plugin/wiki/Migration#migrating-to-175)**.


In essence, the Configuration as Code plugin fetches secrets from Vault in an
asynchronous manner but it appears not to wait for results to come back before
it triggers the Job DSL seed job. With the release of Job DSL 1.75, the
referencing of credentials IDs went from unchecked/lazy to checked/strict. The
fact that the seed job was running before the credentials actually _existed_
became a fatal error which didn't previously exist.


Over the past decade I have become intimately familiar with many different
failure scenarios in Jenkins, more so than any other piece of software. It's
nice to know that there are still new things to explore in our relationship
together.
