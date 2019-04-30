---
layout: post
title: "Thoughts about a secure enclave for Jenkins Pipeline"
tags:
- jenkins
- pipeline
- opinion
- otto
---

Continuous integration and continuous delivery (CI/CD) projects might just be
one of the hardest to lock down and secure. As system designers and
implementors we must enable developers to automate their builds, tests, and
deployments. And yet, in doing so, we also give those same developers the
ability to bypass many of the boundaries we may have set up to secure our
environments. If you give me the ability to automate my deployment with a
script, I can think of a number of ways in which that ability can lead to
information disclosure or other types of breaches. [Jenkins
Pipeline](https://jenkins.io/doc/book/pipeline) is filled with any number of
problematic examples here the same feature can be looked at as _empowering_ or
as _compromising_. I believe the immense flexibility of Jenkins Pipeline also gives us
a path to provide automation which is inherently more secure than some
competitors. In this post, I'll outline one such idea: a pipeline secure
enclave.

I have spent a lot of time thinking about how to properly secure CI/CD
workloads, and it's genuinely a tough problem, as you may have noticed from
some of my previously blog posts:

* [Jenkins should not be the only line of defense](/2019/04/15/trust-and-jenkins.html)
* [It's not stealing when you're giving them away](/2019/02/22/its-not-credentials-stealing.html)
* [Securely running Docker workloads in your CI/CD
  environment](/2019/02/14/untrusted-docker-workloads.html)
* [Enforcing administrative policy in Jenkins, the hard
  way](/2018/01/05/jenkins-policy-enforcement.html)
* [Do not disable the Groovy
  Sandbox](/2017/08/03/donut-disable-groovy-sandbox.html)

Many systems typically expose credentials to scripts via environment variables.
Many tools, Jenkins included make a good effort to mask these credentials
should some developer accidentally
or maliciously attempt ot log them to the console output. As I [have shown
before](/2019/02/22/its-not-credentials-stealing.html), this simply does not
adequately protect credentials. It's possible to leak credentials by: piping
them through some encoding before printing, archiving them as artifacts,
sending them to a remote service, along with numerous slight variations on
those three approaches. So long as a credential is exposed to code editable by
developers, it is trivial to leak.

Unlike some of its competitors, I believe Jenkins Pipeline has the tooling
necessary to provide a secure approach to utilizing credentials in the CI/CD
process. My "secure enclave" proposal revolves around a key feature: [Shared
Libraries](https://jenkins.io/doc/book/pipeline/shared-libraries). With shared
libraries, administrators can load common snippets of pipeline code into the
master, for easy re-use within multiple projects. To learn more about some of
the cool things you can do with shared libraries, I recommend [Alvin Huang's presentation from Jenkins World 2017](https://www.youtube.com/watch?v=lzzx59kLW9w&list=PLvBBnHmZuNQLqgKDFmGnUClw68qsQ9Hq5&index=46).

A secure enclave for Jenkins Pipeline would rest upon the foundation provided
by shared libraries, but require additional implementation to properly secure
credentials:

* An administrator would need to be able to bind credentials **solely** to the
  shared library. Right now there are system-level, and folder-level
  credentials in Jenkins. For system-level credentials, there is nothing which
  prevents my `Jenkinsfile` from utilizing a credential so long as I know the ID
  before hand.
  
  By allowing the credential to be bound solely to the shared library, then the
  credential would not be accessible to pipelines developed and used elsewhere in
  the master.
* Utilizing the credential within the shared library would need to be done in a
  manner which does _not_ allow arbitrary user code to be utilized. After all,
  if the shared library provides me a function to pass in code, which is then
  executed with access to the credentials, then we would have gained nothing.
  
  Invocations into the "secure enclave" methods would need to reject `Closure`
  types from being passed, and likely need to tag and track `String`/`GString`
  types to ensure those aren't inadvertently passed to the `sh` step or
  interpolated into other strings. Suggesting this is a little out of my
  comfort zone, since I don't fully understand how the `workflow-cps` engine
  underneath functions. I feel fairly certain that special-case tracking and handling of a
  `CredentialsString` would _not_ be the gnarliest bit of object-hacking going on
  in CPS.
* To further avoid inadvertent disclosure, Pipelines which attempt to use a
  secure enclave would need to use the Groovy sandbox, and should probably not
  be allowed any `@NonCPS` methods as well. Furthermore, a secure enclave
  must not be editable on Replay of a Pipeline except by a Jenkins
  administrator.

I believe this approach would provide a rigid set of constraints that would
provide increased security for the use of secrets in a Jenkins environment,
while still providing flexibility to developers and administrators.

That said, there is still a potential "escape" if an administrator is enabling
code in this secure enclave simply access the credentials and immediately
passes them into code defined by the repository:

```groovy
void deployit() {
    checkout scm

    withCredentialsthCredentials([string(credentialsId: 'aws-secret', variable: 'AWS_SECRET')]) {
        sh './deploy.sh'
    }
}
```

When thinking about this aspect of the problem, I was considering the potential
to lock down a workspace, or only allow code in the secure enclave to interact
with stashed or archived artifacts. These approaches still suffer from the same
type of circumventions, I am not convinced that the problem is 100% solvable
while still allowing developers to own the code running in their CI/CD
pipelines.

The secure enclave approach is just one potential improvement to the security of
Jenkins Pipeline. Perhaps a bit complex but I believe it would provide a more
comprehensive layer of security atop Jenkins Pipeline.

Another, far simpler, approach would allow the binding of credentials to
a Pipeline and some source control criteria. In my continuously delivered world, the
`master` branch indicates a pre-existing level of trust and validation. Code in
`master` often is trusted enough to be deployed to a staging or test
environment. Relying on that pre-existing system of trust and only binding a
credential, thereby making it available to the `Jenkinsfile` in the `master`
branch, would be a simple improvement to the security of Jenkins Pipelines.

There is certainly still be potential for disclosures, but if I am already
putting systems of trust around that merge to `master`, I likely have bigger
problems if untrusted/unvalidated code is finding its way to the master branch.


---

Any way we look at it, I think Jenkins Pipelines and their treatment of
credentials are quite lacking given the scope and severity of inadvertent
disclosures which have happened over the past couple years. Additionally, none of the
approaches I suggest above would be effective so long as the current system for
adding global credentials and accessing them in pipelines are the "default"
flow. Jenkins must make it more difficult to add and use credentials in
insecure ways.


