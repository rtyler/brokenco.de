---
layout: post
title: "Taking inspiration from Smalltalk for Otto steps"
tags:
- otto
- smalltalk
---


I have recently been spending more time thinking about how
[Otto](https://github.com/rtyler/otto) should handle "steps" in a CI/CD
pipeline. As I mentioned in my previous post on the [step libraries
concept](/2020/10/18/otto-steps.html), one of the big unanswered questions with
the prototype has been managing flow-control of the pipeline from a step. To
recap, a "step" is currently being defined as an artifact (`.tar.gz`) which
self-describes its parameters, an entrypoint, and contains all the code/assets
necessary to execute the step. The execution flow is fairly linear in this
concept: an agent iterates through a sequence of steps, executing each along
the way, end. In order for a step to change the state of the pipeline, this
direction of flow control must be reversed. Allowing steps to communicate changes
to the agent which spawned them requires a **control socket**.


The agent control socket will allow steps to send a fixed number of message
types _back_ to the agent during their execution. My current thinking is that
the control socket should speak [Nanomsg](https://nanomsg.org/), which puts a
little bit more system level requirements on the steps to be able to
communicate with that protocol. My first thought was just lines of JSON encoded
over the wire, but there are a number of practical problems with trying to send
JSON over a unix socket, for example.

For the first implementation, I am planning to have a single long-lived socket
for the duration of a pipeline's execution by the agent. By adding the `ipc`
field to the invocation file (below), I should have the flexibility to allow an
agent to create a single IPC socket for _each_ step to avoid any accidental
overlap.

```yaml
---
configuration:
  ipc: 'ipc:///tmp/agent-5171.ipc'
parameters:
  script: 'ls -lah'
```

The types of messages that come to mind are:

* Terminate the pipeline
* Change the pipeline's running status (e.g. `unstable`)
* Capture a variable

The last item really struck me as **necessary** but I have been struggling with
it quite a bit. In a declarative `Jenkinsfile` there is no provision for
setting variables. It wouldn't otherwise be very _declarative_! This
restriction leads to some confusing hacks in real-world pipelines. The most
common hack is to use the `script {}` block as an escape hatch, such as:

```groovy
stage('Build') {
    steps {
        sh 'make'

        script {
            def output = readYaml file: 'output.yml'
            sh "./deploy.sh ${output.stage}"
        }
    }
}
```

There are numerous legitimate reasons to capture and utilize variables inside
of a CI/CD pipeline. I _want_ to support variables in some fashion without
building a full-on interpreter _or_ sacrificing clarity in the pipeline
modeling language.

As I wrestled with the concept, I noticed that my pseudo-code I was writing for
how variables might be used looked familiar:

```bash
prompt msg: 'What is the best color for a bike shed?', into: 'color'
```

To me, this looks a _lot_ like Smalltalk. Mmmm
[Smalltalk](https://en.wikipedia.org/wiki/Smalltalk). If you have some spare
time, and haven't yet experienced Smalltalk, you should go download
[Pharo](https://pharo.org/) and explore! It's a wonderful language and
development environment and worth experimenting in your career.

Anyways, back to Otto.

The syntax above would be the `prompt` step saving some user-provided string
(hand-waves right now on how that would manifest in a GUI) and capturing it
into the `color` variable.

Storing is one part of the problem, _using_ is the other more interesting part
of the problem. I knew I didn't want `if color == 'red' { }` type blocks
littering the code, lest a user think that this pipeline language is a
programming language for them to build application in! (This is a very real
problem with Scripted Jenkins Pipelines).

A related problem I had set aside the day prior was how to handle "block-scoped
steps", such as the following in Jenkins:

```groovy
stage('Build') {
    steps {
        sh 'make'
        dir('deploy') {
            echo 'Deploying from the deploy/ directory'
            sh './shipit.sh'
        }
    }
}
```

All steps executed within the `dir` block are executed with a current working
directory of `deploy/`.

Variable use and block-scoped steps both lead me to a _very_ Smalltalk syntax,
which honestly has me quite excited to explore! In Smalltalk there is no control
structures in the traditional sense. No `if`, no `for`, etc. Instead one can
send the `ifTrue`/`ifFalse` message to a `Boolean`:

```smalltalk
color = 'red'
    ifTrue: [
        "Great choice!"
    ]
    ifFalse: [
        "Why did you chose wrong?!"
    ]
```


Fully embracing this Smalltalk-inspired concept I believe would be convenient
to implement, since anything that isn't a defined step can be looked at like a
variable, using a pattern similar to `#method_missing` in Ruby (which is
actually just Smalltalk striking again! It's called the `doesNotUnderstand`
message in Smalltalk).

Exploring what this would look like in a pipeline syntax:

```bash
sh 'ls -lah'
prompt msg: 'Which file should I dump?', into: 'filename'

filename equals: '/etc/password',
    then: [
        echo 'Stop trying to pwn me!'
    ],
    else: [
        # Not sure on this yet, I _think_ I want to avoid raw string interpolation syntax
        format pattern: 'cat {}', with: [filename], into: 'dumpcmd'
        sh script: dumpcmd
    ]

dir 'deploy' [
    echo 'Deploying from the deploy/ directory'
    sh './shipit.sh'
]

# Intentionally drop the `filename` variable, which would go out of scope
# at the end of the stage anyways
drop 'filename'
```

A couple notes on the above pseudo-code:

* I'm not yet sold on the syntax. The benefit of this approach rather than
  copying Smalltalk directly is that this syntax will make it easier support
  more robust string operations in the future. The other benefit of
  this syntax is that it makes _everything_ behave step-like, insofar as a
  `stringvariable` internal/hidden step could use the parameters, including the
  two blocks, and just execute the block scoped steps like any other step.
* The block syntax is intentionally _different_ from the directive syntax (to use Jenkins
  terminology) of curly braces I _think_ will help make the code more readable.
* I don't want to actually implement a full Smalltalk interpreter here, but I am
  liking that the syntax does keep things (subjectively) simple.


In order to implement block-scope steps, I am planning to refactor some of the
step execution code into an `agent` crate which will allow steps to re-use the
logic for executing steps. From a data structure standpoint the invocation file
for the `dir` in the example might look like:

```yaml
---
configuration:
  ipc: 'ipc:///tmp/foo.ipc'
parameters:
  directory: 'deploy'
  block:
    - symbol: echo
      parameters:
        msg: 'Deploying from the deploy/ directory'
    - symbol: sh
      parameters:
        script: './shipit.sh'
```

At runtime the process tree on the agent machine would look something like:

```
.
└── agent
    └── dir
        └── echo
```


Despite the state of these ideas right now I haven't actually implemented them!
I typically like to sketch out syntax and run through use-cases before I go
running into Rust code.

---

Part of why I am sharing these early thoughts is because I want to make sure my
love of Smalltalk is not blinding me to usability issues with this approach. I
_think_ this pattern will allow some non-declarative functionality in the
pipeline without requiring an actual interpreted language to be used, but these
thoughts are still fresh. If you've got some thoughts on what could be
improved, or pitfalls to be aware of, feel free to join `#otto` on Freenode, or
email me ([about](/about))!
