---
layout: post
title: "Passing credentials to Otto steps"
tags:
- otto
- security
---

One of the major problems I want to solve with
[Otto](https://github.com/rtyler/otto) is that in many CI/CD tools secrets and
credentials can be inadvertently leaked. Finding a way to allow for the secure
use of credentials without giving developers direct access to the secrets is
something _most_ CI/CD systems fail at today. My hope is that Otto will succeed
because this is a problem being considered from the beginning.  In this post,
I'm going to share some of the thoughts I currently have on how Otto can pass
credentials around while removing or minimizing the possibility for them to be
leaked by user code.

In the course of my career I have spent a **lot** of time on this problem
already. In the [Jenkins project](https://jenkins.io) we have had to deal with
a number of "credential integrity" problems where plugins, or more frequently
users' pipelines end up leaking credentials. I have some thoughts about this
problem with Jenkins written down already in these posts:

* [Thoughts about a secure enclave for Jenkins Pipeline](/2019/04/30/pipeline-secure-enclave.html), musing on how Jenkins could improve or otherwise restrict credentials access.
* [Jenkins should not be the only line of defense](/2019/04/15/trust-and-jenkins.html), noting the importance of defense in depth and siloing "build" from "deploy" after a high profile breach via an open source project's CI system.
* [It's not stealing when you're giving them
  away](/2019/02/22/its-not-credentials-stealing.html), outlining the key
  problem with exposing credentials to user-defined code in a pipeline. Choice
  quote: "_fundamentally, exposing credentials to user-defined code will always
  have the possibility for disclosure._"
* [It's no secret where GitOps falls down](/2018/08/14/gitops-and-secrets.html), discussing the challenges of GitOps and secrets management when "everything is code."


Ultimately, the key challenge is drawing the boundary between "arbitrary
user-defined code" and credentials. Consider an open source project which
accepts pull requests and uses their CI system to validate proposed changes.
In this contrived example, pretend that the CI scripting for the project will:

* Build the package
* Run the tests
* Push a snapshot binary _somewhere_ for any manual testing that may be desired.

Presumably only the last step requires any type of credential. For
demonstration, I will use Jenkins Pipeline but the problem is present in many
other systems:

```groovy
sh 'make package'
sh 'make tests'
withCredentials([string(credentialsId: 'mytoken', variable: 'TOKEN')]) {
    sh 'make deploy'
}
```

There are various mechanisms to prevent a pull request from modifying the
`Jenkinsfile` (in this example), and also ways to prevent outputting the
`mytoken` credentials into the log stream. Ultimately however, since the
credential is being exposed as an _environment variable_ which is then being
made available to user-defined code, in this case a `Makefile`. The only two ways to prevent a malicious pull request from using the token would be to:

* Not run the `make deploy` script for pull requests
* Only use the `main` branch version of the `Makefile` when running the pull request. (_note_: Jenkins basically does a variant of this by default with the `Jenkinsfile`)


My thinking right now is that **Otto should never expose credentials as
environment variables**.

## How this could work

In [this blog post](/2019/02/22/its-not-credentials-stealing.html) I alluded to the solution I am thinking about for Otto:

> The simplest [pattern], the one which exposes those credentials to user-defined
> processes is fundamentally flawed. In Jenkins, an administrator can define
> credentials when configuring some plugins such as the Slack Notification
> plugin. In the case of Slack, the user cannot access the Slack credentials, but
> can invoke `slackSend` from within their Jenkins Pipeline. I strongly believe
> that variations on this pattern, wherein **an administrator defines a credential
> and only allows administrator-governed code to utilize that credential, are the
> only ways in which credentials exposure can be avoided** (barring bugs in the
> code, etc).

(_added emphasis_)

This is effectively _exactly_ what I am thinking for Otto: credentials can
never be accessed as environment variables or by user-defined steps. Instead
they can be accessed from within the context of an administrator approved step
library.

Otto's notion of [step libraries](/2020/10/18/otto-steps.html) means that there
is _plenty_ of room for both administrator and user-defined code, but Otto
should always know where a step comes from, and that coupled with a credential
access pattern _should_ provide sufficient safety.

Using the above example, imagine that `make deploy` is essentially just running:

```bash
curl -H "Token: $TOKEN" -X PUT -d @artifact-20201028-312.tar.gz https://example.com/api/archive
```

In Otto, that code would need to be wrapped in a step library of some form, for
example a `deploy-snapshot` step.

The step below is a sketch in Ruby for ease of understanding:

```ruby
#!/usr/bin/env ruby

require 'json'
require 'yaml'
# Imagine that this gem provides the agent control socket shim
require 'otto/control'

# Load the invocation file which defines where the control socket lives
invoke_data = YAML.load(File.read(ARGV.first))
control = invoke_data['configuration']['ipc']
artifact = invoke_data['parameters]['artifact']

# Send the HTTP request for the credential
response = Otto::Control::send(
                {:type => :RetrieveCredential,
                :name => 'mytoken'})

exit 1 unless response.ok?

# Grab the token to use
token = response['mytoken']['value']

# This could be done with Net::HTTP, but just for symmetry sake
# shell out to curl
system("curl -H 'Token: #{token}' -X PUT -d @#{artifact} https://example.com/api/archive")
```

The above would then be packaged as a `deploy-snapshot-<version>.tar.gz` and
uploaded to the wherever Otto stores its step libraries (yet to be defined).

In order for this step to work properly, an administrator would need to **explicitly**
state that the `deploy-snapshot` can access:

* Credentials of specific names, e.g. `mytoken`.
* All credentials.

In the above example, if `mytoken` was explicitly granted, any other credential
retrieval requests would be denied and the step would error out since it did
not receive the credential.

I can imagine somebody granting "all credentials" access to a standard library step such as `sh`. I believe in this case the credentials would still be safe so long as:

* User-defined code cannot locate the agent control socket.
* User-defined code cannot interact with the agent control socket. Right now
  there's not an authentication scheme applied to the agent/step control
  socket, but it is trivial to add a pre-shared secret that is given to each
  step's internal machinery to use for accessing the socket.

There may also be cases where an administrator is comfortable with allowing a
user-defined step, such as one that is located in the local source tree or at a
remote URL (e.g. on GitHub). For these cases, I think the initial behavior has
to be a "deny and record the request." The administrator should then be able to
approve a user-defined step for credentials access at a specified revision such
as `deploy-snapshot@main` or `deploy-snapshot@1ff9033`.

## How this could not work

The reason environment variables are frequently used for passing secrets around
is because it's _easy_. Well, not only that. Developers are _lazy_. The
forceful demarcation line between which code does and does not have credential
access hasn't been validated with lazy developers other than myself. I don't
yet know whether the bar I am setting is too high, or just high enough for
real-world usage.

If the barrier to entry is too high, I can easily imagine somebody writing a
`withSecrets` step which basically just takes whatever secrets you want and
dumps them into environment variables. This would still require an
administrator to approve the step, but the system would still allow the
`withSecrets` step code to retrieve credentials and then handle them in any
insecure manner they please.

---

I believe that the approach I describe above will prevent the easy and foolish
cases where credentials get leaked.  Ultimately, I don't think Otto can 100%
prevent credential leakage by somebody determined to shoot themselves in the
foot.

If you're a pipeline user or CI/CD systems administrator and have thoughts on
how you would want to use or lock-down credentials, please join `#otto` on
Freenode or [email me](/about) with your thoughts!
