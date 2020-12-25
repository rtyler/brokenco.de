---
layout: post
title: "Parsing Jenkins Pipeline without Jenkins"
tags:
- jenkins
- rust
- otto
- pipeline
---

Writing and locally verifying a CI/CD pipeline is a challenge thousands of
developers face, which I'm hoping to make a little bit easier with a new tool
named: [Jenkins Declarative Parser](https://github.com/rtyler/jdp) (`jdp`).
Jenkins Pipeline is one of the most important advancements made in the last 10
years for Jenkins, it can however behave like a frustrating black box for many
new and experienced Jenkins users. The goal with `jdp` is to provide a
lightweight and easy to run utility and library for validating declarative
Jenkinsfiles.

---

If you have `cargo` installed, you can get `jdp` right now by running `cargo
install jdp`, or you can download a Linux/amd64-based binary from the
[releases](https://github.com/rtyler/jdp/releases/tag/v0.2.2).

---

Within the Jenkins advocacy group, I think the biggest marketing coup we have
accomplished to date is making people think that "Declarative Pipeline" is
_actually_ declarative. For better or worse, it's really not. There is no
first-party grammar or parser for a declarative `Jenkinsfile`. The dirty little
secret is that Declarative Pipeline is just a [Groovy](https://groovy-lang.org)
domain specific language, one which tries to hide Groovy from the user, but in
many cases fails to do so. Personally, I still think Declarative is a *much*
better option than Scripted, with far more guardrails which  help keep users
working with best practices. As I have gotten deep into the supported syntax of
Declarative however, I have started to see numerous holes in the thin veneer
over Groovy.

As of now, `jdp` is at v0.2.2 and can support *lots* of Declarative Pipeline
syntax.

This parser is not a Groovy syntax parser and as such any advanced or wacky
groovy that is littered around a Jenkinsfile will be ignored. This
includes the `script` step which is basically checked to make sure that there is
a `script { }` block, but anything within it is explicitly ignored.

Here's an example of a non-trivial pipeline pulled from the Jenkins documentation:


```groovy
pipeline {
    agent any
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            when {
                branch 'production'
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

When `jdp check` is executed against this file, it let's me know that it's correct!

```
❯ jdp check data/valid/when-branch/Jenkinsfile
Looks valid! Great work!
```


The `jdp check` tries to be as helpful as possible with bad syntax or semantics
in an invalid `Jenkinsfile`. This is an area that I want to improve more, with
`rustc` as a good inspiration for how helpful a "compiler" or "linter" should
behave:


```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
        }
    }
}
```

The above pipeline doesn't have syntax errors, but does lack some important
semantics required by a Declarative Jenkinsfile:

```
jdp check data/invalid/no-steps-in-stage/Jenkinsfile 

data/invalid/no-steps-in-stage/Jenkinsfile
------------------------------------------
0: pipeline {
1:     agent any
2:     stages {
3:         stage('Build') {
  --------^

Fail: A stage must have either steps{}, parallel{}, or nested stages {}
```

---


There are still *tons* of things I want to do with `jdp`, which is written in
Rust. If you're keen on building a first-class `Jenkinsfile` grammar or
development tooling: check out the [issues
page](https://github.com/rtyler/jdp/issues) for some of the ideas I have in
mind for `jdp`.

As we enter 2021, Jenkins Pipeline will definitely continue to play a major
role in many of our CI/CD pipelines. With `jdp`, I'm hoping it becomes a bit
easier for us all to write high quality and correct Jenkinsfiles!
