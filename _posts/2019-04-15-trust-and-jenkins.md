---
layout: post
title: "Jenkins should not be the only line of defense"
tags:
- opinion
- jenkins
- cicd
- otto
---

This past week a missed security update contributed to a [compromise at
Matrix.org](https://matrix.org/blog/2019/04/11/security-incident/). As I have
[said](/2017/08/07/jenkins-pipeline-shell.html)
[before](/2019/02/14/untrusted-docker-workloads.html), for purposes of
infrastructure design, it is prudent to consider CI/CD tools like Jenkins as
"remote code execution as a service." In the [Continuous Delivery
world](https://cd.foundation), I think we have a serious problem with user
education around securely running CI/CD tools; anything which can touch
production represents a potential liability.

While these thoughts were bubbling around in my mind, I saw [this
tweet](https://twitter.com/mukherjee_mk/status/1117585756095012864) from
[Mrinal Mukherjee](https://mobile.twitter.com/mukherjee_mk):


> *Many organisations tend to have separate non-production and production
> instances of a deployment orchestrator
> ([@jenkinsci](https://twitter.com/jenkinsci)) to manage non-production
> and production deployments respectively.  This, as opposed to a single instance
> which handles both use-cases. Thoughts?*


In this post, I wanted to expand on [my
response](https://twitter.com/agentdero/status/1117602907052888064):

> *I tend to prefer two systems because it is rather difficult to totally and
> completely secure credentials for production systems, when you give
> developers "Pipeline as code" :)*
>
> *The "production" instance of Jenkins would typically just handle the last mile
> of delivery.*


The unending trade-off infrastructure and tools developers must make is one of
flexibility versus reliability. While it would be nice to live in a world where
our automated systems allow code from individuals to fail in ways which do not
adversely impact customers, for the most part we have to draw the line in the
sand somewhere. Whether that is restricting access to networks, reducing the
scopes of credentials, or by segmenting systems entirely. I do not view this as
a problem, but a realistic approach to systems of safety. 


My approach to this when structuring Jenkins infrastructure is to segment along
"non-production" and "production" systems. The non-production system has
non-production credentials, which have a low consequence if disclosed or
misused by developers who author a `Jenkinsfile`. The production system
however maintains production credentials, which are scoped to specific Folders
or Pipelines in Jenkins, and does not process pull requests or any code not
deemed fit for production, such as that in the `master` branch.

If you step back from Jenkins itself and consider an application which stores
highly valuable secrets, what would your [defense in
depth](https://en.wikipedia.org/wiki/Defence_in_depth) strategy look like?
Running any app on a hostile network requires this kind of thinking. A
critical credential or bit of data living in an application which is a single
bug away from being exposed is simply bad design.  We take this approach
seriously in the Jenkins project, because we run a Jenkins environment on a
hostile network, also known as "the internet." 

In our case, there are Jenkins environments on the public internet, but the
Jenkins environments which hold deployment or production credentials are simply
_unroutable_ on the public internet. By requiring a jump host or a VPN to
access the environment, it is simply impossible for an attacker who might be
scanning cloud provider's address space to find and compromise the environment.
There are certainly other problematic avenues, but that's where the "defense in
depth" comes in again. I've wrote some more tips on managing credentials in
Jenkins specifically in a previous blog post:
[It's not stealing when you're giving them
away](/2019/02/22/its-not-credentials-stealing.html). One of my favorite approaches is using tools like Hashicorp Vault which can
[generate secrets
dynamically](https://learn.hashicorp.com/vault/secrets-management/sm-dynamic-secrets),
making the leakage of credentials less impactful.

Regardless, it is absolutely critical to put services which have production
credentials, or keys which can lead to secondary levels of compromise behind
VPNs or other encrypted gateways. The public internet is a scary place, and if
you launch a Jenkins instance into AWS, Google Cloud, or Azure, I guarantee it
will be scanned within 10-15 minutes by script kiddies.

CI/CD tools represent an ideal attack vector not only for credentials, but for
other supply-chain attacks that could further compromise your end users.
Designing a layered and secure approach to running any CI/CD tool is incredibly
important for everybody shipping software today.  But generally, please don't
let any single application be the sole line of defense between credentials or
user data, and the goblins running around on public networks.
