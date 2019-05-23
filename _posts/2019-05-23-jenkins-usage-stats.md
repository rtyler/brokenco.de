---
layout: post
title: "How Jenkins usage statistics work"
tags:
- jenkins
- cdf
---

For years the Jenkins project has published anonymous usage statistics to
[stats.jenkins.io](http://stats.jenkins.io).  Despite its warts, the system has
ultimately proven useful for determining which plugins are most frequently
installed, big coarse-grained changes in growth, and providing various
marketing departments with the validation they so desperately crave.  Like many
of the tucked away corners of the Jenkins project, being an infrastructure
maintainer affords me an understanding of how the system works, and sometimes
doesn't. As I promised to the [CDF](https://cd.foundation) Technical Oversight
Committee many weeks ago, in this post I will attempt to describe how this
system works.

Buckle up, it's about to get messy.


The party starts in Jenkins core, with
[UsageStatistics.java](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/hudson/model/UsageStatistics.java)
which is responsible for collecting and sending statistics, assuming the
administrator has not opted out. This data includes items like what the current
installed Jenkins core version is, how many executors have been configured, the
plugins installed, and a few other things. This information we don't consider
anonymized by default, and take efforts to encrypt the data before it is sent
to a backend server.  When this was first developed, daemons like Jenkins were
not expected to contact outside services for any reason and as such it was much
more common for corporate firewalls to block outgoing traffic from Jenkins
instances. The clever workaround put into place was to generate the usage
statistics payload, and then to periodically add it to a user's web page. The
presumption being that while the server might not be able to access
`jenkins-ci.org`, it was unlikely that a user's web browser would restrict the
HTTP request. For reasons that escape me, this was all done via an HTTP `GET`
request, which also means the encrypted statistics payload must be base-64
encoded in order to pass properly in the query string of the request.

As an aside, this "make the user's browser do the work" pattern was first
developed for the Update Center which distributes Jenkins plugins to users. We
found early on that Jenkins instances would not be able to update due to
overzealous firewalls. And so for many years, the Jenkins administrator's
browser session would download the `update-center.json` into their browser, and
then POST it back to Jenkins. Now Jenkins defaults to hitting the
Update Center directly, which is good because that `update-center.json` has
blossomed to over 1MB in size.

Where were we again?


Oh right, encrypting statistics, base-64 encoding them, and stuffing them into
a web page for an HTTP GET request to send them along to the backend server.


Much of Jenkins was developed in the era before BIG DATA was commonplace.
We don't use some sort of high performance data collector to receive all
of this statistics information, instead we use tried-and true Apache. "Huh, so
there's a service being reverse proxied by Apache?" you might be thinking. No.
We use Apache. The HTTP GET requests flow into Apache, which logs the HTTP GET
request to its access logs whose query string contains the base-64 encoded and
encrypted payload. Ta-da! Data collected.


At this point we have access logs sitting on a server somewhere with usage
statistics, which have been encrypted, and unless your big data toolbox is only
`grep`, they're largely unusable at this point.


On some interval, some machine somewhere in Kohsuke's basement downloads these
access logs and runs
[usage-log-decrypter](https://github.com/jenkins-infra/usage-log-decrypter) on
them. This process will decrypt the data, fuzz custom plugin names and a number
of other values to suitably anonymize the data, before uploading those logs
back to another Jenkins project server. Unfortunately usage statistics
processing is one of those community processes which still has a very thorny
single-point-of-failure sitting in Kohsuke's basement, but it's not important
enough for anybody to spend much time working on it.


The journey for these data points isn't over yet however!


The data processing which turns anonymized usage logs into blue SVGs and CSV
files was originally developed for funsies by a contributor who wanted to play with
the data some weekend many years ago. Like lots of other things in open source
projects, these weekend hobby projects have a tendency to survive despite all
odds. That code has evolved in the
[infra-statistics](https://github.com/jenkins-infra/infra-statistics)
repository. On a monthly basis, the scripting in that repo will load the
anonymized JSON usage statistics into a local MongoDB data store, then run a
bunch of different queries against it in order to produce the files for
[stats.jenkins.io](https://stats.jenkins.io) which are then committed to the
`gh-pages` branch and pushed, serving the site's static content via GitHub
Pages. As you might guess, loading bunches of data into an in-memory data store
has its limitations, namely with _the memory_. Last year, I believe, we
exceeded the amount of memory available for the Jenkins agents which
traditionally ran the monthly job. In the meantime,
[Andrew](https://github.com/abayer) has been running the statistics processing
manually on a local workstation.

To recap, usage statistics from every Jenkins instance which does not opt-out,
are generated in a JSON object, which is then encrypted, then base-64 encoded,
it is thereafter smuggled along an HTTP GET request to an Apache server which
logs the request to the access log, from which it is downloaded, fuzzed,
reconstituted and uploaded back to a Jenkins server, then on a monthly cadence
it is downloaded, loaded into MongoDB, queried, and then finally formatted into
various CSV, JSON, and SVG files which are uploaded to GitHub Pages.

---

Setting aside the obviously degraded state this aging system is currently in,
the right fix involves tearing the _entire_ thing down.

I don't think a new system is terribly difficult to design and build, but
similar to my work with on [Uplink](/2019/05/06/whats-uplink.html), it requires
Jenkins core and backend service changes to be made in concert, something we're
not very adept at doing in the project.

The original context in which I was asked about this system was as a reference
for the common problem affecting the other projects within the CDF: **how do
we measure success and adoption**.

I think this is a great problem to solve, and worth serious investment. I have
many thoughts on how to revisit the topic with what we now know from our
experiences in the Jenkins project. A better approach which delivers usable
data more rapidly and with greater focus on user privacy, but that's a topic
for another day, and perhaps another blog post.
