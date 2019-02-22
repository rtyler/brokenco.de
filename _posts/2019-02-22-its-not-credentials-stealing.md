---
layout: post
title: "It's not stealing when you're giving them away"
tags:
- jenkins
- security
- otto
---

My exact words were "[I could have likely filled half a book with thoughts and
practices on good security for
Jenkins](/2019/02/02/codevalet-the-failed-experiment.html)" and were I to write
that book, my
colleague [Daniel](https://github.com/daniel-beck) would certainly be a guest
author of a few chapters, such as one on the [limitations of credentials
masking](https://jenkins.io/blog/2019/02/21/credentials-masking/). In that
linked post Daniel highlights some of the ways in which credentials can be
misused in Jenkins. As I [mentioned on
Twitter](https://twitter.com/agentdero/status/1098735822977650688), this is not
a unique problem to Jenkins, any system which allows user-defined build
processes _and_ allows the use of credentials in those build processes
**will** allow exposure of those credentials.


Both Jenkins and Travis CI for example, can expose credentials or
secrets as environment variables, which can then be used in the `Jenkinsfile` or
`.travis.yml` respectively. Of course, once those credentials are exposed in
_any form_ to the user-defined build process, an incompetent or malicious user
can leak those credentials.

Take this example from Daniel's blog post:

```groovy
withCredentials([usernamePassword(credentialsId: 'topSecretCredentials',
                               passwordVariable: 'PWD',
                               usernameVariable: 'USR')]) {
    echo 'Encrypting the password with base64, h4xx0r!'
    // will print e.g. dDBwczNjcjN0Cg=
    // which is trivially converted back to the top secret password
    sh 'echo $PWD | base64'
}
```

OH NOES HACKED! The only way to be certain credentials cannot be disclosed is
to never expose them to the user-defined build process in the first place.

### Mitigations

Of course, there are ways to reduce the surface area for possible credential
leakage. One approach which Daniel discusses in the blog post, is segmenting
where credentials are used:

> _Credentials can be defined in different scopes: Credentials defined on the root
> Jenkins store (the default) will be available to all jobs on the instance. The
> only exception are credentials with System scope, intended for the global
> configuration only, for example, to connect to agents. Credentials defined in a
> folder are only available within that folder (transitively, i.e. also in
> folders inside this folder)._
>
> _This allows defining sensitive credentials, such as deployment credentials, on
> specific folders whose contents only users trusted with those credentials are
> allowed to configure: Directly in Jenkins using Matrix Authorization Plugin and
> by limiting write access to repositories defining pipelines as code._


There are a couple other approaches which can help:


1. Utilize the built-in `Jenkinsfile` "Branch Source" configuration to allow
   only trusted contributors' Pull Requests/Branches to be evaluated. This
   extends a modicum of trust, basically that if somebody can write to the
   repository, we trust them not to be foolish with credentials.
1. Isolate the use of credentials to the `master` branch only. In many cases, I
   doubt that pull requests will need credentials for deployment. If the need
   for credentials is only once things land in master, for example, then we can
   use Jenkins Pipeline to further restrict where Pipelines might use credentials. Namely,
   only allowing the use once code has been merged, e.g.:
   ```groovy
   stages {
       /* .. snip .. */

       stage('Deploy') {
           when { branch 'master' }
           environment {
               SECRET_KEY = credentials('deploy-key')
           }
           steps {
               /* .. */
           }
       }
   }
   ```
   This only reduces the possible disclosure surface area, but does not remove
   it entirely.
1. Utilize a "deployment" environment, separate from the common "build"
   environment. This is more or less the approach we take in the Jenkins
   project. There is a non-public Jenkins instance which actually has deployment
   keys for a number of projects, and the `Jenkinsfile` for those projects is
   actually run in two different Jenkins environments. This _also_ only reduces
   the possible disclosure surface area, since it only prevents problematic
   disclosures via the Console Output or archived artifacts. It would still be
   possible to run a script which POSTed to a third party service with those
   credentials.
1. Utilize [dynamic secrets with a tool like HashiCorp
   Vault](https://learn.hashicorp.com/vault/secrets-management/sm-dynamic-secrets).
   This reduces the effect of disclosure, since disclosed secrets would be invalid
   after their use in the Pipeline. This is not always possible, since many of the
   things we need secrets for are out of our control, such as GitHub, Slack, or
   other third-party service secrets.

Fundamentally, exposing credentials to user-defined code **will always have the
possibility for disclosure**.


### The Only Solution

Both Jenkins and Travis CI have multiple ways in which to use credentials. The
simplest, the one which exposes those credentials to user-defined processes is
fundamentally flawed. In Jenkins, an administrator can define credentials
when configuring some plugins such as the [Slack Notification
plugin](https://plugins.jenkins.io/slack). In the case of Slack, the user
cannot access the Slack credentials, but _can_ invoke `slackSend` from within
their Jenkins Pipeline.  I strongly believe that variations on this pattern,
wherein an administrator defines a credential and only allows administrator-governed
code to utilize that credential, are the only ways in which credentials
exposure can be avoided (barring bugs in the code, etc).

Unfortunately, in Jenkins this approach only applies to plugins. There is no
way to expose credentials **only** to a Pipeline Shared Library, which would be 
administrator-approved code. This means there are some unfortunate limits to
the reduction in surface area that administrators can provide.

As I have been thinking about this problem and some [other design challenges in
Jenkins](/2019/02/02/codevalet-the-failed-experiment.html), and as a result
have been considering alternative system designs which would obviate many
classes of security challenges Jenkins and other CI/CD systems face. Balancing
user flexibility and security is among the harder problems in the space, and
with continuous delivery becoming the standard, I believe we need to find safer
ways to handle the _deployment_ end of the pipeline.
