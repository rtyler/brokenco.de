---
layout: post
title: Self-hosting Jenkins and Gitea
tags:
- jenkins
- software
---


I consider learning how to script or automate things among the most important
investments developers can make early in their career. The progression for a
lot of people was learning to write scripts and then learning how to run those
scripts with `cron`. **Go further**.

At least once a week I derive _some_ benefit from the investment in time
I had a few years ago in in my [Gitea](https://about.gitea.com/) and
[Jenkins](https://jenkins.io) home lab.

At the outset, I used the [mirror
repository](https://docs.gitea.com/usage/repository/repo-mirror/)
functionality of Gitea combined with the [Gitea
plugin](https://plugins.jenkins.io/gitea/) for Jenkins to make it trivial to
keep LAN-local copies of key dependencies 

As my needs evolved I ended up with numerous pipelines which do _things_.
Various automations when new tags are introduced in upstream repositories,
integration testing of my key tools, or validating correctness of my own
projects.

Many of the use-cases I have can be solved on a public forge like GitHub or GitLab _however_ the local nature of my setup affords a number of benefits:

* I am uninhibited in trying all sorts of wacky things because _nobody but me
  will see_.
* Task execution is as far as my local hardware (your mileage may vary).
* I don't need to consider public/private visibility, it's all personal until
  otherwise determined.

Despite all the hype around _agentic development_, many would be surprised at
how productivity gains that can be gained by the incremental compound interest
of investing in _personal automation_ with run of the mill scripting and CI.

I recommend learning the [Jenkins Pipeline
syntax](https://www.jenkins.io/doc/book/pipeline/syntax/), deploying a local
Gitea (or Forgejo), and starting to automate the many little things that will
benefit your day-to-day software development.
