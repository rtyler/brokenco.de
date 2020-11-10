---
layout: post
title: Orphan steps in Otto Pipeline
tags:
- otto
- rust
---

After [sketching out some Otto Pipeline
ideas](/2020/11/06/pipeline-syntax-for-otto.html) last week, I was fortunate
enough to talk to a couple peers in the Jenkins community about their pipeline
thoughts which led to a concept in Otto Pipelines: orphan steps. Similar to
Declarative jenkins Pipelines, my initial sketches mandated a series of `stage`
blocks to encapsulate behavior. [Steven
Terrana](https://github.com/steven-terrana), author of the [Jenkins Templating
Engine](https://www.jenkins.io/blog/2019/05/09/templating-engine/) made a
provocative suggestion: "**stages should be optional**."

It is always refreshing when somebody asks "but why have we always done it this
way?" and without a good answer, you find yourself asking the same question.

As best as I can remember, Declarative Pipeline requires the stages in order to
make rendering of pipelines prettier in [Blue
Ocean](https://www.jenkins.io/projects/blueocean/). The utility of stages for complex pipelines is pretty clear, but for the simpler pipelines, they end up adding unnecessary boilerplate. The following is the smallest possible Declarative Jenkins Pipeline needed to run `make`:

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'make'
            }
        }
    }
}
```

With the addition to orphan steps in Otto Pipelines, the smallest possible
invocation becomes:

```groovy
use stdlib
pipeline {
  steps {
    sh 'make'
  }
}
```

The more I thought about orphan steps, the more I liked them. A stage can provide scoped options like

* Environment variables
* Runtime environment
* Credentials
* Gates
* Post-stage conditions

If you don't need any of the trappings or other capabilities that a stage
provides, why bother with the extra boilerplate! The pipeline execution is
already sequential, orphan steps will execute linearly just like any sequence
of stages would. An example:

```groovy
use stdlib

pipeline {
  steps {
    sh 'bundle exec rake spec package'
    archive artifacts: 'pkg/*.gem', name: 'gems'
  }

  stage {
    name = 'Publish to rubygems'
    credentials = ['rubygems-token']
    steps {
      unarchive 'gems'
      gemupload gems: 'pkg/*.gem'
    }
  }

  steps {
    echo '>> Any cleanup?'
  }
}
```

Freeing my mind from the burden of considering "everything must be a stage"
allowed me to also consider other top level "verbs" that make sense within the
`pipeline [ }`. A rough list of what I am currently thinking would be:

* `steps`, orphan steps.
* `stage`, container of more configuration to execute steps.
* `fanout`, container of multiple stages to run in parallel, failing immediately if a branch fails.
* `parallel`, container of multiple stages to run in parallel.
* `confirm`, prompt a user to confirm that the pipeline can continue.
* `prompt`, prompt the user for a parameter(s) which can be saved into a variable.
* `rollback`, execute some `steps` if some event indicating a failure is fired in the Otto event system.

Quoting Steven again: "it's better to have different names for different
behaviors, rather than a bunch of configuration options." [This
gist](https://gist.github.com/rtyler/0f7878bb3116b28e74afaa72dc9fc0b1) contains
a rough sketch of what some of those verbs would look like. 

At this point I am quite excited by the aesthetics of the pipeline with these
rich descriptive blocks. This approach doesn't result in significantly more
parser and implementation work, but it does have the potential to make Otto
Pipelines more clear in their behavior, which is fantastic.

The syntax shared above is far from final, but I cannot wait to get some of
this implemented to try out with real workloads!
