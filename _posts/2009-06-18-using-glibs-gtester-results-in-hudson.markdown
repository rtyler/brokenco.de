--- 
layout: post
title: Using Glib's gtester Results in Hudson
tags: 
- Miscellaneous
- Software Development
- Linux
- Hudson
created: 1245312122
---
For one of the projects I've been working on lately, I've been making use of [Glib's Testing](http://library.gnome.org/devel/glib/unstable/glib-Testing.html) functionality to write unit tests for a C-based project. I'm a fairly big fan of the [Hudson Continuous Integration Server](http://hudson-ci.org) and I wanted to run tests for my C-based project. 

Unfortunately, the `gtester` application generates XML in a custom format that Hudson cannot understand (i.e. JUnit formatted XML). In order to come up with some JUnit XML, I spent about an hour and a half toying with XSLT for transforming the XML `gtester` generates (see the snippet below).

I added a shell script build step to the end of the build process that runs:

    gtester test_app --keep-going -o=Tests.xml
    xsltproc -o tests.junit.xml gtester.xsl Tests.xml

Then I just specified "tests.junit.xml" in the **Publish JUnit test result report** section of the **Post-build Actions** and then Hudson would properly process and post the test results when the job was finished.

<script src="http://gist.github.com/131727.js"></script>
