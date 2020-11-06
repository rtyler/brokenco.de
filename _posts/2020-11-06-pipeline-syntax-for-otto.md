---
layout: post
title: Sketches of syntax, a pipeline for Otto
tags:
- otto
- jenkins
- pipeline
- cicd
- ci
---

Defining a good continuous integration and delivery pipeline syntax for
[Otto](https://github.com/rtyler/otto) is one of the most important
challenges in the entire project. It is one which I struggled with early in
the project almost a year and a half ago. It is a challenge I continue to
struggle with today, even as the puzzles pieces start to interlock for the
multi-service system I originally imagined Otto to be. Now that I have started
writing the parser, the pressure to make some design decisions and play them
out to their logical ends is growing. The following snippet compiles to the
_current_ Otto intermediate representation and will execute on the _current_
prototype agent implementation:

```groovy
pipeline {
  stages {
    stage {
      name = 'Build'
      steps {
        echo '>> Building project'
        sh 'make all'
      }
    }
  }
}
```

"It works!"

The reaction upon sharing this with friends and colleagues on Twitter was
largely: "looks like Declarative [Pipeline]." The syntax above is just a simple
shim to get the basics working, but the similarities are no accident. [Jenkins
Pipeline](https://jenkins.io/doc/book/pipeline/syntax/) is the best publicly
available syntax for describing a CI/CD pipeline (in my not-so-humble opinion).
If I didn't believe that I wouldn't continue to advocate for its use at every
possible turn.

For Otto however, the goal is not to create a Jenkins Pipeline knock-off. In
this post I wanted to share some sketches of what I think Otto Pipelines should
look like and why. For starters, the README [has an incomplete
list](https://github.com/rtyler/otto/tree/3c2daa412ab091d827040c56f891ad0fdcd7cd2c#modeling-continuous-delivery)
which covers some high-level goals I have for modeling continuous delivery,
which is worth a look. The [examples/
directory](https://github.com/rtyler/otto/tree/3c2daa412ab091d827040c56f891ad0fdcd7cd2c/examples)
also has a few sample `.otto` files which I will use for reference throughout
this post.

It may also be worth reading My previous post describing [step
libraries](/2020/10/18/otto-steps.html) if you haven't already, since they play
an integral part in making this syntax "go."

With the pre-requisites out of the way, let's walk through some syntax.


## Defining the available tools

```groovy
use {
  stdlib
  './common/slack'
}
```

Sprinkled at the top of Otto Pipelines is the `use` block. A common problem
with Jenkins Pipeline is that the steps available in the `Jenkinsfile` is
completely dependent on what plugins have been installed on the controller _or_
what [Shared Libraries](https://jenkins.io/doc/book/pipeline/shared-libraries/)
have been configured. The `use` block effectively brings Otto Step Libraries
into scope for the given pipeline. Because Step Libraries require no
"controller-side" execution in Otto, each Otto Pipeline can use a completely
different sets of steps for users to leverage in their workflow.

**Open questions**:

* Versioning for step libraries seems like it is worth doing, but what's the right syntax for expressing it?
* Referring to step libraries by URL could be incredibly useful, but is it worth the complexity?


## Defining the execution environment

Next is declaring the execution environment for a stage/stages:

```groovy
/* snip */
stage {
  name = 'Build'

  runtime {
    docker {
      image = 'ruby:2.6'
    }
  }

  steps {
  }
}
```

Resource allocation is one of the areas I am most excited to explore with Otto,
but from a modeling standpoint and an execution standpoint. Jenkins was build
before "cloud" was a thing, and arguably before "containers", depending on
whether or not any rabid Solaris users are within earshot. As such it has some
pitfalls when mapping pipeline execution to these much more dynamic
environments. On the flip side, newer CI/CD systems seem to have all gravitated
towards container-all-the-things and typically don't consider non-container
workloads in any form, and will also usually require a Kubernetes clusters just
to get started.

```groovy
runtime {
  arch = 'amd64'
  linux {
    pkgconfig = ['openssl', 'libxml-2.0']
  }
  python {
    version = '~> 3.8.5'
    virtualenv = true
  }
}
```

For Otto I want to do *better* and started thinking about _capabilities_ rather
than fixed labels or names. In many cases, I don't particularly care where my
Rust project builds, just so long as it has `cargo` and an up-to-date stable
`rustc`. Similarly for Python projects, I might need an execution environment
with Python 3.x, `virtualenv`, and `libxml2` installed. In most systems that
precede Otto, administrators end up defining complex labels which users must
know. Another way to paper over this complexity is to say "just bring your own
container!" which pushes a lot of work back onto developers, typically leading
to one-off `Dockerfile`s which just take an upstream image and add one or two
dependencies.

With a capabilities-oriented model, the pipeline orchestration layer is no
longer looking for machines labeled "linux-pythoN" or and then hoping one is
available. Instead the orchestrator can be smarter and find any available
capacity to meet the capabilities request.  I believe this approach can improve
on overall system performance and scheduling. An idea which I have floating
around as [a draft
RFC](https://github.com/rtyler/otto/blob/main/rfc/0003-resource-auctioning.adoc)
right now is basically to "auction" pipeline tasks to the lowest bidder. When I
first started considering this idea, I found this paper titled [Efficient Nash
Equilibrium Resource Allocation Based on Game Theory Mechanism in Cloud
Computing by Using
Auction](https://www.scribd.com/document/439692166/Efficient-Nash-Equilibrium-Resource-Allocation-Based-on-Game-Theory-Mechanism-in-Cloud-Computing-by-Using-Auction),
which will likely guide the implementation of `auctioneer` quite a bit.

What remains to be seen is whether users are actually interested in
_expressing_ the capabilities that would be necessary to make a highly
efficient resource auction practical.


**Open questions:**

* Do most developers think about what their pipeline needs in the same way I think about capabilities?
* How would an administrator define capabilities of a cloud-based VM template?

## Caching

From an operational standpoint, I think the most common problem of _any_ CI
system is overuse of remote resources by pipelines. [This is not a niche
problem](https://twitter.com/technosophos/status/1324037674588463105), but
rather something that affects practically everybody. Some will say "you should
be caching and proxying all your remote resources!" which is simply not a
practical solution for the vast majority of the users in the ecosystem who are
not at large enough organizations to deploy such caching proxies.

```groovy
stage {
  name = 'Build'

  cache {
    // Create a cache named "gems", immutable for the rest of the Pipeline
    gems = ['vendor/']
    assets = ['dist/css/', 'dist/js/']
  }

  /* snip */
}
stage {
  name = 'Test'
  cache {
    use gems
  }
}
```

The `cache` block is intended to provide pipeline authors with a way to cache
arbitrary sections of the workspace for later re-use in the pipeline across
multiple agents. This is a pretty simple syntax addition, but something built
into the Otto infrastructure from the beginning.

On the implementation side, this requires that archiving and retrieving these
artifacts is relatively quick, which I don't believe will be a major challenge.

**Open questions:**

* Is it sufficient to cache a file subtree and simply restore it into the same
  location in another agent's workspace?
* Would this syntax accommodate the caching of Docker image layers?

## Composition and Re-use

Inevitably developers try to abstract common functionality and behaviors into
re-usable components. Step libraries can provide one flavor of this
re-usability, but I don't believe that it is sufficient. I once joked about
[the five stages of YAML](/2018/08/15/five-stages-of-yaml.html) wherein
developers end up turning a declarative syntax into templates and then just
another turing-complete language.

In Jenkins we have seen numerous tools for templatizing jobs, pipelines, or
other aspects of Jenkins configuration. Suffice it to say, there is a need to
compose and re-use various aspects of pipelines.

For Otto, I have been playing around with a context-aware `from` keyword, such as below:

```groovy
stage {
  name = 'Test'
  runtime {
    from 'Build'
  }
  steps {
    sh 'bundle exec rake spec'
  }
}
```

In the above example, `from` instructs the pipeline to re-use the contents of
the runtime block from the `Build` stage. My current thinking is that this
simple use of `from` allows for pipeline-internal re-use of pieces without the
need for setting variables or turning this into a scripting language.

That said, re-usability within the pipeline isn't where the main interest in
"templates" lies.

I have been exploring the concept of a "blueprint" which can act as an
re-usable unit of Otto Pipeline. I am imagining that these would be published
and managed similarly to Step Libraries. In order to provide maximum
flexibility, I think blueprints should be able to capture just about any
snippet of the Otto Pipeline syntax for re-use, consider the following example
to help make common Ruby gem build/test/publish pipelines cleaner:.

**rubygem.blueprint**
```groovy
use {
  stdlib
}

blueprint {
  parameters {
    rubyVersion {
      description = 'Specify the Ruby container'
      default = 'ruby'
      type = string
    }

    deploy {
      description = 'Push to rubygems.oorg'
      default = true
      type = boolean
    }
  }

  plan {
    stages {
      stage('Build') {
        runtime {
          docker {
            image = vars.rubyVersion
          }
        }

        steps {
          sh 'bundle install'
          sh 'bundle exec rake build'
        }
      }

      stage('Test') {
        runtime { from 'Build' }
        steps {
          sh 'bundle exec rake test'
        }
      }

      stage('Deploy') {
        gates { enter { vars.deploy } }
        runtime { from 'Build' }
        steps {
          sh 'bundle exec rake push'
        }
      }
    }
  }
}
```

This would then be later re-used within an Otto Pipeline by using the same `from` syntax as before:

```groovy
pipeline {
  from 'blueprints/rubygem'

  /*
   * Optionally I could add additional post-deployment configuration here,
   * which would be ordered after the blueprint's stages have completed
   */
}
```

Since `from` would be somewhat context-aware and would be able to pull all the
right stages "into place" within the pipeline. I'm optimistic that this
approach would allow the definition that includes just one stage for example,
or other blocks which can be defined within the `pipeline { }`.

I am not yet sure what the right mechanism for passing parameters into the
blueprint should be. Right now I am leaning towards keyword arguments on the
`from` directive: `from blueprint: 'blueprints/rubygem', rubyVersion: '2.6',
deploy: false`.I am not really sure what the implementation complexity of this
approach will bring however.

**Open Questions:**

* Will treating `from` almost like a preprocessor directive allow the parser to successfully handle blueprints for arbitrary blocks of pipeline?
* Does this amount of composition alleviate the pressure that templates tend to solve for other systmes?

## Gates

The final bit of syntax I wish to discuss at the moment are "gates." One of the
least appreciated parts of just about every CD pipeline, gates define how the
pipeline should behave differently under certain conditions, including pausing
for user input or an external event.

From one of the modeling goals I had set:

> **External interactions must be model-able.** Deferring control to an external
> system must be accounted for in a user-defined model. For example, submitting
> a deployment request, and then waiting for some external condition to be made
> to indicate that the deployment has completed and the service is now online.
> This should support both an evented model, wherein the external service
> "calls back" and a polling model, where the process waits until some external
> condition can be verified.

A contrived example of what this might look like for a pipeline which prepares
a deployment whenever changes land in the `main` branch:

```groovy
gates {
  enter { branch == 'main' }

  /*
  * The exit block is where external stimuli back into the system
  * should be modeled, providing some means of holding back the pipeline
  * until the condition has been met
  */
  exit {
    input 'Does staging look good to you?'
  }
}
```

Of anything discussed thus far, gates have the *most* runtime implementation requirements. In the primitive example above we have:

* A Git branch being referenced, which needs to be pulled into scope somehow/somewhere.
* An expression that needs to be evaluated in the service mesh before this stage of the pipeline is dispatched.
* An `input` step which should allow the agent which executed the stage to
  deallocate **and** pause further execution of the pipeline until some
  external event is provided.

The last item is the most challenging for me to think about from an
implementation and modeling standpoint. Somewhere within Otto a state machine
for each pipeline must be maintained, and once an `input`, `webhook`, or some
other step is encountered, the state machine must pause for external actions.
How those external actions should be wired in? Not sure! How those steps should
be defined? Not sure!

There are so many open questions at this point.

Gates leave me with the most discomfort of any of my ideas for Otto. Done well,
gates could provide a key component missing from many existing tools. The
challenge is going to be finding the space between the pipeline modeling
language and the execution engine which will accommodate them.


---

I still probably have more questions than answers at this point about how the
pipeline modeling syntax should be defined and how it should execute. The one
major lesson which I have learned from my time in the Jenkins project is that
the pipeline syntax cannot be improved in isolation from the execution
environment. There are many key design decisions which need to be made in both
domains which will have major repercussions in the other.

I think back to the word used by a developer who read my thoughts on what I
want to do with Otto:

"**Ambitious**."

---

As always, if you're curious to learn more, you're welcome to join `#otto` on the
[Freenode](https://freenode.net) IRC network, or follow along on
[GitHub](https://github.com/rtyler/otto)

