---
layout: post
title: Documenting is hard
tags:
- opinion
- jenkins
- documentation
---


A non-trivial aspect of my job for the past year at
[CloudBees](http://cloudbees.com) has been *communication*. To claim that this
is a _new_ change in my career would be to fundamentally mis-attribute the vast
majority of what makes good Software Engineers and Engineering Managers _good_.
Communication in my job as a "Technical Evangelist" (or as my business card
states: "Community Concierge") is many orders of magnitude more involved than
it was an Engineering Manager, and what makes it very challenging is the size
of the *audience*. As an Engineering Manager the audience is typically less
than 20 people throughout an organization where the spoken-word is the primary
means of communication. By conservative estimates more than a million people
use and interact with Jenkins as part of their work, the primary way to reach
them being written English in some medium or another.


It is an embarrassing admission to say that I have never really spent much time
worrying about documentation for *any* of the software I have
worked on over the past lotsofyears. Considering one of my goals is to
communicate about common patterns, best practices, and new technologies to the
vast expanse of the Jenkins user-base, I care more now about documentation than
at any previous point in my career.

And writing documentation is **hard**.


(_it's no wonder Jenkins has been so poorly documented in the past!_)


I wouldn't consider myself much better than I was twelve months ago at writing
documentation, but I have improved, and want to share a few thoughts on how.

### Writing as a craft

Most of my "documentation" in the past has been code comments, class and method
annotations, for which my audience is typically a future version of myself who
is annoyed with the mistakes of a past version. Basically, if I consider myself
the typical developer who will be reading my documentation, I would write the
documentation for somebody like me, with all the understanding and mental model
that I possess.

> Always code as if the guy who ends up maintaining your code will be a violent
> psychopath who knows where you live. Code for readability
([John Woods](http://stackoverflow.com/a/878436))


High quality documentation cannot make those same assumptions of the audience.
It typically must address both novice and advanced readers within the same body
of work. The structure and style of the [FreeBSD
Handbook](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/) has been
a major source of inspiration for my own work on the [Jenkins
Handbook](https://jenkins.io/doc/book/). Having used FreeBSD for over a decade,
I still find myself periodically referring back to sections of the FreeBSD
Handbook as a reference guide, but I can still remember a time when I started
*at the beginning* and found it useful.

Having read back through the Handbook with an eye towards how one might write
such a practical set of documentation, a few general characteristics can be
identified:


#### User and Task-focused

The starting set of documents assume no prior knowledge or existing FreeBSD
installation and thoughtfully guide the user through the installation process.
As if targeted at a user who has sat down at an empty computer screen and
wishes to go from zero to a usable system, the Handbook then progresses through
the basics of configuring a FreeBSD system including installing third party
applications and setting up the X Windowing system. For a user who knows what
they're looking for, many of these sections will be ignored, but for the
beginner, they carefully guide the reader through progressively more complex
and important tasks. Which leads me to structure.

#### Structure

Most documentation I have seen written by developers tends to be one-off. A
developer adds Feature X, and updates the README or some other document with a
paragraph explaining Feature X. In doing so, usually ignores the forest for the
trees (to butcher a colloquialism). A colleague, who shall go unnamed,
referred to this resulting documentation as "info vomit." *Yes* there is
documentation here, but it has been spewed into an unordered, seemingly
un-curated, series of unrelated paragraphs which are eminently confusing wall
of text to read through.

The structure of high quality documentation, like the FreeBSD Handbook, is
thoughtful and incrementally builds upon previous sections. Compared to, for
example, the [Gradle User Guide](https://docs.gradle.org/current/userguide/userguide.html) which is also
*very* useful, but is structured more haphazardly. Its chapters and sections
don't cleanly build upon knowledge gained in the previous section which also
has an unfortunate side effect of forcing the reader who might just be starting
out with Gradle to hunt through the haystack for the appropriate sections to
start practically using Gradle.

#### Consistency

An easy to overlook characteristic of high quality documentation is also
consistency, which entails consistency of terms, formatting, and of course
style.

Leading up to the Jenkins 2.0 launch in early 2016, a few members of the
project like [Chris Orr](https://github.com/orrc) made efforts to stamp out
inconsistency verbiage in Jenkins, a crucial prerequisite to consistency in
documentation. As an experienced Jenkins user, I understand what somebody
_means_ when they interchangeably mix terms like "VM", "slave", "node",
"machine", and "agent." A beginner doesn't have that same built up mental
model, so mixed terms will cause confusion.

Consistent formatting is also an important, but odious, task. With any visual
presentation of content, differences in style and formatting between different
documents results in additional cognitive overhead, forcing the reader to
consider more of the document than they may need to. When all headings look
like so, each section can be expected to have a preamble, source code blocks
are consistently marked up, and tips/notes (admonitions) are consistently
formatted the reader can much more easily scan the document for the relevant
information.

I certainly have my own opinions of what the right formatting is for technical
documentation, but at the end of the day, so long as it is consistent across a
corpus of documentation, that suffices.

#### Well Written

This is deceptively obvious and not as subjective as I would have thought a
couple of years ago. There are numerous texts on writing well ("On Writing
Well", "The Elements of Style", and "Simple & Direct" are my recommendations)
which should be followed or taken into consideration when writing
documentation. Poorly written English documentation is still preferred to
unwritten documentation, but still makes the content difficult to read and
understand. A few guidelines that I consider important to keep in mind are:

* Don't be clever: nobody cares about your expansive vocabulary, most times
  your audience is both English-native and non-native speakers.  Strive for
  the simplest, most concise, sentence structure while still _flowing_ (it
  shouldn't read like it was written by a child).
* Avoid parenthetical statements: Developers seem to have stack-based thoughts
  and will tend to write deeply nested statements which can be confusing to
  parse and understand. Practically all parenthetical statements I have seen
  warrant a proper sentence.
* Use spell-check.
* Err on the side of proper nouns in place of pronouns: I seen this more often
  with documentation written by non-native speakers, but use of pronouns in
  statements should be avoided. For example "X is a tool which integrates with this, that,
  and the other. It runs on Linux." would be clearer with "X runs on Linux" to
  avoid any confusion, however temporary, as to what the "it" refers to.
  Clarity is king!

### Good Tools

In working with documentation, I often encounter developers who advocate for
Markdown as a format for documentation.

They are wrong, er, misguided.

Markdown is a highly useful subset of HTML for writing GitHub Issues and
shitposting on Stack Overflow. It lacks however **practically all** the functionality
needed to make it useful for documentation, compared to formats like AsciiDoc
or reStructuredText.

My preference is towards AsciiDoc, by way of
[AsciiDoctor](http://asciidoctor.org), which the Jenkins project uses *very*
heavily for all our new documentation needs. This includes formatting and
functionality such as:


* Various block delimiters such as source code or quote blocks
* Footnote support
* Inline image support
* Defining inline anchors for:
* Inter-document and intra-document cross-referencing
* Document attributes for defining document meta-data and properties
* Automatic tables of contents and bibliographies
* Rendering PDF, DocBook, HTML, Man pages, and other output formats
* Extension support for defining custom markup/tags


Without a good documentation tool like AsciiDoctor, I do not believe that we
(the Jenkins project) would be able to create consistent, quality documentation.


### Outside-in-approach

Finally, an "outside-in-approach" is what I believe to be another key to
writing better documentation. This might be more subjective than the previous
two sections in that I tend to organize my thoughts in outline form regardless
of medium.

As far as documentation, what has helped more than anything has been to start
at a high level and progressively work inward, for example:

* Who is the audience? Jenkins users.
* What are the common things that Jenkins users need to do or know? Install
  Jenkins, Configure Jenkins, Configure their workloads on Jenkins (and many
   more topics).
* (For example) What does Installing Jenkins entail? Depends on the platform,
  there's Linux packages, installers, and containers available.
* What do I need to know to get Jenkins running on Linux? Add these
  repositories, and some other bits.

By putting my thoughts down for each level before moving onto the next, I
rapidly identify misplaced ideas or topics, or in the best-case scenario, find
useless topics which needn't be documented to begin with. This approach has an
added benefit of forcing an ordering more akin to how a beginner would approach
Jenkins, instead of me brain-dumping (or info vomiting) 8 years of knowledge
into a document.

---

The [documentation](https://jenkins.io/doc/) for Jenkins is better than it was
at the beginning of the year, but I wouldn't call it "good," yet. It's
something that [we could use your help on](https://github.com/jenkins-infra/jenkins.io) too.


Frankly, I hope you consider contributing quality documentation to _any_ open source
project you use, since it's always in short-supply, for what I hope are now
obvious reasons.

In short, documenting is hard.
