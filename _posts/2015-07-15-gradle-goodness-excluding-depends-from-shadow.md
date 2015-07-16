---
layout: post
title: "Gradle Goodness: Excluding Shadow jar dependencies"
tags:
- gradle
- gradlegoodness
---


Over the past year, I've spent a lot of time [hacking in the Gradle
ecosysgtem](https://github.com/jruby-gradle) which, for better or worse, has
earned me a reputation of knowing Gradle-y things within
[Lookout](http://hackers.lookout.com). Recently, my colleague
[Ron](https://github.com/rkuris) approached me with a Gradle problem: using the
[shadow plugin](https://github.com/johnrengelman/shadow/) (a great plugin for
building fat jars), he was having trouble excluding some dependencies from the
produced jar artifact. I figured I would emulate Mr. Haki's [Gradle
Goodness](http://mrhaki.blogspot.com/search/label/Gradle%3AGoodness) series and
post one of my own.


### The Problem

The Shadow plugin will, by default, include runtime dependencies inside of the
produced artifact. The way that it handles this is by unzipping (effectively)
the `.jar` dependencies into the shadow jar's file tree.

In Ron's case, he's building an [Apache Storm](http://storm.apache.org)
topology which must compile against the "storm-core" dependency, but it
must not include that dependency in the resulting artifact. Otherwise the
deployment of the topology explodes with all kinds of classpath conflicts, as
Storm already has the "storm-core" code loaded at runtime.


His `build.gradle` originally looked something like this:

~~~
plugins {
    id 'java'
    id 'com.github.johnrengelman.shadow' version '1.2.1'
}

shadowJar {
    manifest {
        attributes 'Implementation-Title': 'Storm Health Check',
                'Implementation-Version': project.version,
                'Main-Class': 'com.github.lookout.storm.healthcheck.HealthCheckTopology'
    }
}

dependencies {
    compile group: 'org.apache.storm', name: 'storm-core', version: '0.9.4'
    testCompile group: 'junit', name: 'junit', version: '4.11'
}
~~~


### Attempt #1

Overly confident, as per usual, I say "[well there's your
problem](http://www.gagbay.com/images/2012/03/well_theres_your_problem-56537.jpg)"
and change the `dependencies { }` closure to:

~~~
dependencies {
    runtime group: 'org.apache.storm', name: 'storm-core', version: '0.9.4'
    testCompile group: 'junit', name: 'junit', version: '4.11'
}
~~~


This, of course, will fail to compile the Java code included in the project
since it needs the transitive dependencies of "storm-core" to compile properly.

Duh.

### Attempt #2

Reading through the docs again for the Shadow plugin, I noticed [this bit about
excluding
dependencies](https://github.com/johnrengelman/shadow#filtering-shadow-jar-contents-by-mavenproject-dependency) and figured  I would give that a try:


~~~
shadowJar {
    manifest {
        attributes 'Implementation-Title': 'Storm Health Check',
                'Implementation-Version': project.version,
                'Main-Class': 'com.github.lookout.storm.healthcheck.HealthCheckTopology'
    }

    dependencies {
        exclude(dependency('org.apache.storm:storm-core:0.9.4'))
    }
}
~~~


Unfortnuately this functionality provided by the Shadow plugin on excludes the
top-level dependency, and doesn't do anything different with transitive
dependencies.

So that doesn't work for us, trying again!


### Attempt #3

I've worked with the Shadow plugin a number of times before, and I'm aware of
the defaults that are applied to the default `shadowJar { }` task, so my next
attempt was to simply avoid that task


~~~
configurations {
    shadow
}

import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar

task stormTopology(type: ShadowJar) {
    manifest {
        attributes 'Implementation-Title': 'Storm Health Check',
                'Implementation-Version': project.version,
                'Main-Class': 'com.github.lookout.storm.healthcheck.HealthCheckTopology'
    }

    configurations = [project.configurations.shadow]
    from(project.sourceSets.main.output)
}
~~~

This introduces a new configuration called "shadow" which is assigned to the
new "stormTopology" task. So this technically *works*.

It's got some downsides:

* Introduction of a new task
* Introduction of a new, empty, configuration
* Additional code to get our `ShadowJar` task to be configured
  properly


This didn't feel right to me, so I tried one more time to make it cleaner


### Attempt #3 1/2


While re-reviewing the code for the default `shadowJar { }` task, I noticed
[this
line](https://github.com/johnrengelman/shadow/blob/master/src/main/groovy/com/github/jengelman/gradle/plugins/shadow/ShadowJavaPlugin.groovy#L58)
which configures the task to use the "runtime" configuration by default. The
Gradle [Java
plugin](https://docs.gradle.org/current/userguide/java_plugin.html) defines a
number of configurations, "compile" being one of them and another
notable one being "runtime." The latter is intended for runtime dependencies
for the application being built. The Java plugin *also* makes "runtime" extend
from "compile," turning it into a superset of dependency information.

This means that if you define a "compile" dependency, it will be present in the
"runtime" configuration automatically.


Recognizing this as part of a potential solution, I refactored the build.gradle one more time:


~~~
plugins {
    id 'com.github.johnrengelman.shadow' version '1.2.1'
}

shadowJar {
    manifest {
        attributes 'Implementation-Title': 'Storm Health Check',
                'Implementation-Version': project.version,
                'Main-Class': 'com.github.lookout.storm.healthcheck.HealthCheckTopology'
    }
}

dependencies {
    compile group: 'org.apache.storm', name: 'storm-core', version: '0.9.4'
    testCompile group: 'junit', name: 'junit', version: '4.11'
}

configurations {
    /* We don't want the storm-core dependency in our shadowJar */
    runtime.exclude module: 'storm-core'
}
~~~


Note the last `configurations { }` closure. This is using Gradle's built in
dependency management semantics to purge `storm-core` and its transitive
dependencies from the "runtime" configuration.


This is short, functional and doesn't require any special configuration, yay!
