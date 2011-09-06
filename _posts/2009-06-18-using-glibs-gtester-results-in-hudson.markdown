---
layout: post
title: Using Glib's gtester Results in Jenkins
tags:
- miscellaneous
- software development
- linux
- hudson
- jenkins
nodeid: 218
created: 1245312122
---

**Update:** (*2011.09.06*) Fixed references to Hudson, which has since been
renamed to [Jenkins](http://www.jenkins-ci.org).

---

For one of the projects I've been working on lately, I've been making use of [Glib's Testing](http://library.gnome.org/devel/glib/unstable/glib-Testing.html) functionality to write unit tests for a C-based project. I'm a fairly big fan of the [Jenkins Continuous Integration Server](http://jenkins-ci.org) and I wanted to run tests for my C-based project. 

Unfortunately, the `gtester` application generates XML in a custom format that Jenkins cannot understand (i.e. JUnit formatted XML). In order to come up with some JUnit XML, I spent about an hour and a half toying with XSLT for transforming the XML `gtester` generates (see the snippet below).

I added a shell script build step to the end of the build process that runs:

    gtester test_app --keep-going -o=Tests.xml
    xsltproc -o tests.junit.xml gtester.xsl Tests.xml

Then I just specified "tests.junit.xml" in the **Publish JUnit test result report** section of the **Post-build Actions** and then Jenkins would properly process and post the test results when the job was finished.

<script src="http://gist.github.com/131727.js"></script>

