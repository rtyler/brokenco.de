---
layout: post
title: Choosing the right plugin dependencies
tags:
- jenkins
- evergreen
- opinion
---


For [Jenkins](https://jenkins.io/), the plugin ecosystem is one of its key
advantages over other tools offering some similar functionality. That power and
flexibility does not come without it's own set of problems for the project
itself. From an outsiders perspective, the challenges around dependency and
update management between Jenkins plugins is a substantial topic, worthy of at
least a couple of doctoral theses in computer science and sociology
respectively. For insiders within the Jenkins developer community, the
relations between plugins in the ecosystem makes a bizarre kind of sense. Like
the tax code, it's something you figure out how to work within, but never dare
dig in too deeply, for fear of your head exploding. In this blog post, I'd like
to share my philosophy on how we, the Jenkins project, _should_ think about
plugin dependencies and how that contrasts to the status quo.

---

**Note**: This may be a bit of "[inside
baseball](https://en.wikipedia.org/wiki/Inside_baseball_%28metaphor%29)" related to the [Jenkins
Evergreen](/2018/08/30/cd-for-the-jenkins-project.html) effort which I have blogged
about previously.

---


### How Jenkins plugin dependencies work

Jenkins plugins are primarily written in Java and use
[Apache Maven](https://maven.apache.org) to define their dependencies and build
process. By way of an example, imagine you were building a Taco Cat plugin which
depended on the `git-client` plugin's APIs and functionality. In order to even
compile your plugin referencing APIs provided by `git-client`, the `pom.xml`
for your plugin would need to specify the `git-client` plugin as a dependency.

Of course this build-time dependency implies a run-time dependency.
When the Taco Cat plugin you are developing is actually running in a Jenkins
master's JVM, it needs to invoke functionality provided by the `git-client`
plugin. Since the `git-client` dependency is not automatically "shaded", or statically
added into the `tacocat.hpi` artifact when it is built, Jenkins must be
instructed to fetch and install `git-client.hpi` when `tacocat.hpi` is
installed.

The Jenkins project has tooling to add special plugin dependency information to
the `tacocat.hpi` file, which is really a `.jar`, in the
`META-INF/MANIFEST.MF`. Additional tooling behind the scenes processes that
information from the released `tacocat.hpi` artifact, and generates the "Update
Center", which is itself a periodically updated `.json` file listing all the
latest released versions of plugins. Among other information, the Update Center references the dependencies by the plugin's name and version.
For example, the entry for `tacocat` might look something
like the following:

    "tacocat": {
      "buildDate": "Sep 27, 2018",
      "version": "0.2",
      "dependencies": [
        {
          "name": "git-client",
          "optional": false,
          "version": "1.0"
        },
      ]
    }

The `version` field is the version of the dependency specified way
back at the beginning in the `pom.xml` as a build-time dependency.
Unfortunately, the Update Center only includes the _latest_ versions of
all released plugins, not the history of plugins. This means that this same
`.json` file will contain the `git-client` entry, but only for the latest
(`2.7.3`) version.
 

While this has clearly worked for the Jenkins project for a long time, there
are a number of technological and cultural issues with this approach.


### The problems

#### Untested combinations

Perhaps the most notable problem is the "take the latest dependency" approach
Jenkins utilizes in the Update Center. In the `tacocat` example above, I
intentionally referenced `git-client` at version `1.0`. This means that when I
build and test `tacocat` locally, I will be grabbing the `1.0` version of
`git-client`.

The latest `git-client` in the Update Center is version `2.7.3`. This means
that when a new Jenkins user installs the Taco Cat plugin, they will be effectively
running an untested version combination of `git-client 2.7.3` and `tacocat 0.2`

If an existing Jenkins user, with `git-client 2.0.1` installs the Taco Cat
plugin, they too will be running an untested version combination with
`git-client 2.0.1` and `tacocat 0.2`. And so it goes for every possible version
of `git-client` which is used in the wild from version `1.0` to `2.7.3`.


#### Least possible dependency

Culturally the Jenkins project trends very conservative with dependency
management and upgrades. Many developers view plugin dependencies as a simply
**build-time** concern and apply a principle of taking the least possible
dependency. In practice this means that if the `git-client` plugin introduced
the API needed for the Taco Cat plugin in `1.0`, then the `pom.xml` for
`tacocat` should specify that version, regardless of what improvements, bug
fixes, or security issue have been addressed in the `git-client` plugin in the
interim.

Since build-time dependencies translate to **run-time** dependencies, this
means a user is _allowed_ to have `git-client 1.0` and install the newer Taco
Cat plugin, regardless of what critical fixes have been made in the subsequent
releases of the `git-client` plugin. Fortunately for that user however, they
would actually be running a tested version combination.

While I understand the build-time perspective regarding bumping dependency
versions, in my opinion this behavior betrays a serious lack of appreciation
for how Jenkins plugins are consumed as part of a greater system.

In a cursory examination of plugin dependency relationships, I found numerous
plugins which specified dependencies with versions containing [known security
issues](https://jenkins.io/security/advisories/). As much as I would hope that
all installations of Jenkins are applying the appropriate security updates, the
behavior of _allowing_ users to receive features and updates to some areas of
Jenkins such as Blue Ocean or Pipeline, without requiring the upgrade of
insecure dependencies, is not satisfactory.


#### Opportunity for destabilization

The most commonly encountered problem with the current approach to dependency
management is the sibling of "Untested combinations" wherein two plugins in the
environment depend on two incompatible versions of the same dependency. Jenkins
plugins are loaded in a manner similar to shared libraries such that only one
version of `git-client` will be loaded into the JVM at a time. Any plugins
which depend on `git-client`, must all be happy with whatever version is
loaded, regardless of what their `META-INF/MANIFEST.MF` declares.

For some users, this can lead to upgrades proving hazardous. There is no
guarantee that plugins follow Semantic Versioning, or any other sane versioning
scheme for that matter, it is entirely possible to see API incompatible changes
made in point-releases of some plugins. (Users of Docker Pipeline may recall
some unhappy changes to `ENTRYPOINT` behavior in 1.15).

Problems with incompatible plugins typically manifest in one of three
behaviors:

1. Jenkins is bricked and won't start up.
1. Jenkins logs an error that it cannot load one of the plugins, and continues
   to operate without that plugin's functionality present.
1. Some functionality at the seams between plugins, which previously worked, no longer works properly.


None of these is particularly desirable, and the burden of diagnosing what the
heck went wrong is left solely on the user's shoulders.

---

Jenkins is presently _developed_ as a series of components, some of which are
loosely coupled, others less so.

Jenkins is _used_ as a comprehensive system.

I believe that the current approach to plugin dependency management has led to
a subpar user experience, and though it has been part of why Jenkins
flourished organically over the past decade, in recent years the technological
and cultural infrastructure behind it is no longer sufficient to keep Jenkins
competitive.

### How Jenkins Evergreen works

[Jenkins Evergreen](https://jenkins.io/projects/evergreen) is a curated and
automatically updating distribution of Jenkins core and plugins. It is
important to highlight that Evergreen is _not_ something different from what
Jenkins is today, but rather new packaging with some nice auto-update
functionality to boot.

In its current implementation, Jenkins Evergreen is defined by a "[Bill of
Materials](https://github.com/jenkins-infra/evergreen/blob/master/services/essentials.yaml)"
which describes the exact version combination of core and plugins will be
installed in the Jenkins environment.

The Bill of Materials is described in a file called `essentials.yaml` which
contains two relevant sections `spec` and `status`.  In the `spec` block, we
describe the plugins which contain the features deemed necessary for Jenkins
Evergreen. The `status` block is then populated by our tooling based on the
plugin dependencies outlined in the `META-INF/MANIFEST.MF` file described
earlier. The tooling will resolve dependencies using the same "least possible
dependency" approach, meaning that if a plugin declares a dependency on
`git-client 1.0`, and no other plugin requires a later version, Evergreen will
ship `git-client 1.0` unless otherwise specified.

To further reduce potential incompatibilities or destabilization, Evergreen
currently **restricts the ability of a user to install additional plugins**.
This may strike some as a controversial approach, but in our early alpha
testing we found it far too easy for testers to destabilize their Jenkins
environment and are preferring a more curated approach for the moment.

One suggestion in the development of Evergreen's tooling was to unilaterally
pin our plugins to the latest released in the Update Center. This is similar to
an approach I used for a project in 2017 called "Code Valet." This sort of
bleeding-edge approach is in fact quite bloody, and I ended up identifying a
large number of low-severity bugs by being the first person to ever encounter
the combination of plugin versions Code Valet was shipping. Great to find the
bugs, but shifts a significant testing overhead to the integrator (me).



For better or worse, Evergreen is trusting the versions which plugin developers
are declaring to have been tested and built against.


### What would be better


Whether via Evergreen, or a traditional installation, Jenkins is used as a
coherent system, regardless of how it may be developed or delivered. To better
serve this end, I believe changes should be made in how this system is
developed.

Forgetting for a moment the technical complexity of any of these suggestions, I
think Jenkins would be much better with:

1. **Plugin isolation:** if my Taco Cat plugin really only ever says "give me
   `git-client 1.0`, then at runtime, that's exactly what should be provided.
   This would certainly bloat the memory footprint of Jenkins, but I can imagine a
   number of optimizations to lower that memory usage.

1. **Automatic upgrade of `pom.xml` for security fixes:** if the Taco Cat
   plugin depends on a known-vulnerable-version of a specific plugin, we should
   have GitHub-based automation to propose, and perhaps even merge, a change to
   the `pom.xml` bumping that dependency to a known-safe-version.

1. **Entire-system testing:** There has already been some work done by Oliver
   Gondza and others with the
   [acceptance-test-harness](https://github.com/jenkinsci/acceptance-test-harness)
   work, which should be broadened to be used for _plugins_ and their pull
   requests. A plugin like `git-client` is so fundamentally important to the
   usage of any Jenkins installation these days, that pull requests should be
   blocked if changes to `git-client` break the system. (_Note:_ `git-client` is
   typically very well tested and maintained, I'm only picking on it as an
   example).

1. **Shed the culture of least possible dependency:** Rather than thinking
   about dependencies in `pom.xml` files as build time dependencies, thinking
   about them as run-time dependencies, and of the user who will be running them.
   If the `git-client` plugin provides very useful features in version `2.0` or
   later, each maintainer of a plugin which depends on it, should strongly
   consider upgrading their `pom.xml` declarations. Not because their plugin
   necessarily requires newer APIs, but because users should be encouraged to
   adopt the latest bug fixes and features.

1. **Encourage plugin squashing:** A large amount of complexity stems from a culture of
   putting everything into its own plugin, as if Jenkins plugins must follow
   Unix-style idioms. Jenkins Pipeline is particularly troublesome in this
   regard. For many plugin suites, or sets of related plugins, there's not any
   user benefit from the fragmentation of functionality across multiple
   plugins where they may end up with untested combinations of related plugins.
   In many cases, a single plugin in the suite is functionally unusabe without the
   others also present.  These suites of plugins should be squashed together
   wherever possible.

1. **Report and receive plugin health metrics:** The Update Center is
   fundamentally static today, but users would be much better served if the
   updates interaction between a Jenkins instance and the project's services were
   more "live." By reporting plugin health, or installation success, associated
   with the versions installed in the Jenkins instance, we would be able to
   surface useful information to users. Showing users whether a certain plugin
   version is known to break in their version of Jenkins, or perhaps conflicts
   with existing versions of other plugins, would help avoid numerous users
   falling into the same broken-plugin tar pits.


I am by no means zealous about fixing the plugin issues in the Jenkins
ecosystem specifically. It is not the area of the project which I love to hack
on. I am zealous however about fixing the experience users encounter with
Jenkins overall. As of today, I see the plugin ecosystem as the biggest
double-edged sword we have to contend with in the project. Through our plugin
ecosystem users can extend Jenkins to meet all sorts of disparate needs.
Through our plugin ecosystem users can also easily find themselves with broken
environments.

That is not a "user error", that is a "Jenkins error." And one we **must** fix.
