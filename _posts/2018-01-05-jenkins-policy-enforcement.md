---
layout: post
title: "Enforcing administrative policy in Jenkins, the hard way"
tags:
- cicd
- jenkins
- opinion
- pipeline
---

One foggy morning a few weeks ago, I received a disk usage alert courtesy of
the Jenkins project's infrastructure on-call rotation. In every infrastructure
ever, disk usage alerts seem to be the most common alert to crop up, something
_somewhere_ is not properly cleaning up after itself. This time, the alert was
from our own [Jenkins environment](https://ci.jenkins.io/). The logging
filesystem wasn't the problem, the filesystem hosting `JENKINS_HOME` was
perilously close to running out of space. The local time, about 6:20 in the
morning, and yours truly was quietly furious at the back of a bus headed into
San Francisco for the day.


To put it delicately, Jenkins has always been a pain for Systems
Administrators. What was originally a huge selling point, the WYSIWYG
configuration screens, over time, and thanks to the healthy adoption of
"infrastructure as code" tooling such as Puppet, has become a weakness. With the
introduction of "Pipeline as Code" as a core concept in Jenkins 2,
circa 2016, the problem was even further exacerbated  Empowering developers
with some level of code-driven autonomy is now a key aspect of any modern
development tool, but without corresponding tooling and controls for
administrators, such autonomy rapidly leads to chaos.


Back on the bus ride, the usage of `JENKINS_HOME` slowly inched towards 100%. A
quick analysis indicated that most of the disk space was being occupied by
what any capable Jenkins admin would expect:

* Old archived artifacts.
* Old test reports.
* Old console logs.

With Jenkins Pipeline, developers have control. To the detriment of
administrators like me, who have no (_simple_) means to systematically enforce
things like log rotation.

That doesn't mean administrators are left entirely out in the cold, but rather
we have to enforce administrative policy **the hard way**.

### Scripting Jenkins

Jenkins has support for built-in [Groovy](http://groovy-lang.org) scripting,
which is the usual solution for enforcing administrative policy in Jenkins.
In order to rectify the disk usage situation, I wrote a little snippet of
Groovy which will forcefully purge **all but the last 5 runs** of every
Pipeline in the "Plugins" folder on the system:

```groovy
Jenkins.instance.items.each { f ->
    if (f.name == 'Plugins') {
        f.items.each { p ->
            /* each  p is really a Multibranch Pipeline, which looks like a
             * folder, so need to iterate over its items */
            p.items.each { pipeline ->
                if (pipeline.builds.size() > 5) {
                    println "Deleting from ${p}"
                    /* Delete runs older than the last five */
                    pipeline.builds[5 .. -1].each { it.delete() }
                }
            }
        }
    }
}
```

Scary! Right now I have only added this little Groovy script to the
infrastructure team's runbooks. If I wanted to enforce this more
systematically, I would add file to the `init.groovy.d/` directory on the
Jenkins master.

#### init.groovy.d

Many administrators aren't aware of the `init.groovy.d/` directory, which can
be added to `JENKINS_HOME`. The _really really_ useful characteristic of Groovy
scripts added to `init.groovy.d/` is that they are executed after Jenkins
plugins are loaded, but before Jenkins is "ready" and starts accepting web
requests or executing workloads. These qualities make `init.groovy.d/` an ideal
place to insert scripts which:

* **Clean up the filesystem**, such as with my forceful log rotation script
  referenced above.
* **Enforce security policy**, like my Groovy scripts which [disable the
  Jenkins CLI](https://github.com/CodeValet/master/blob/master/init.groovy.d/disable-cli.groovy), or [configure GitHub OAuth-based authentication and authorization](https://github.com/CodeValet/master/blob/master/init.groovy.d/setup-github-oauth.groovy).
* **Configure monitoring tooling**, such as [the Datadog
  plugin](https://github.com/CodeValet/master/blob/master/init.groovy.d/configure-datadog.groovy)
* **Pre-configure Pipeline Libraries**, like those which should be [enabled
  globally for all Pipelines](https://github.com/CodeValet/master/blob/master/init.groovy.d/pipeline-global-configuration.groovy)


As I mentioned in my previous post [Developing Groovy Scripts to Automate
Jenkins](/2017/07/24/groovy-automation-for-jenkins.html), creating these
scripts requires a __lot__ of knowledge about how Jenkins works on the inside.
While this is definitely "the hard way," the end result is a much more
automated and manageable Jenkins environment.


To learn more about scripting Jenkins, I highly recommend the talk embedded
below, given by my pal Sam Gleske at Jenkins World 2017.

<center><iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/qaUPESDcsGg" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe><br/></center>

### Scripting Pipeline

In my previous post [Overriding steps in Pipeline with Shared Library sleight
of hand](/2017/08/03/overriding-builtin-steps-pipeline.html), I discussed another
option for enforcing administrative policy: overriding Pipeline steps. While I
won't repeat too much, I do wish to point out a very useful pattern to
consider: enforcing timeouts on built-in steps. Take the `sh` step as an
example, by default in Jenkins there is no built-in, configurable or otherwise,
way to constrain the time spent by a step. This means a malicious or
incompetent developer can run script which performs an infinite loop,
wastefully tying up resources in the Jenkins environment.

By overriding the `sh` step, I can wrap it with a 2 hour timeout safe-guard as
is implemented below. Once the Shared Library has been implicitly loaded in the
Global Pipeline Libraries configuration, developers won't notice any changes,
but the beleaguered administrator will sleep a bit easier at night.

```groovy
def call(Map params = [:]) {
    String script = params.script
    Boolean returnStatus = params.get('returnStatus', false)
    Boolean returnStdout = params.get('returnStdout', false)
    String encoding = params.get('encoding', null)

    timeout(time: 2, unit: HOURS) {
        /* invoke the built-in sh step */
        return steps.sh(script: script,
                    returnStatus: returnStatus,
                    returnStdout: returnStdout,
                        encoding: encoding)
    }
}
/* Convenience overload */
def call(String script) {
    return call(script: script)
}
```

### An easier way?

Work is currently being undertaken, spear-headed by [Ewelina
Wilkosz](https://github.com/ewelinawilkosz2) at Praqma
under [JEP-201](https://github.com/jenkinsci/jep/tree/master/jep/201) titled
"Configuration as Code."

> We want to introduce a simple way to define Jenkins configuration from a
> declarative document that would be accessible even to newcomers. Such a
> document should replicate the web UI user experience so the resulting structure
> looks natural to end user. Jenkins components have to be identified by
> convention or user-friendly names rather than by actual implementation class
> name.


While I haven't had the time to really dive deeper into what Ewelina and her
crew are proposing, they are certainly in the right ballpark for making Jenkins
easier to administer, and policies easier to enforce.

---


Once you come to terms with scripting Jenkins, there are a number of ways in
which policy can be enforced using those scripts. My current preferred method
is to use `init.groovy.d/`, but those only apply during boot/restarts. It's
also possible to execute those very same scripts via the Jenkins CLI, which I
have done in the past. Through a clever combination of shell, Groovy, and
Puppet scripting, it's possible to write idempotent scripts which Puppet can
run every time the Puppet Agent runs, ensuring on-going compliance.

Just because it isn't easy, doesn't mean it's impossible,
