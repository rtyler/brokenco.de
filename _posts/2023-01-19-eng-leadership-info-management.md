---
layout: post
title: "A lot of engineering management is actually information management"
tags:
- software
- leadership
- management
- opinion
---

Are you an organized person? Do you understand information flow in your
organization? The importance of categorization and taxonomy? You might be a good
fit for Engineering Management! Having now spent a number of years in management
and leadership positions, I have noticed a number of successful patterns, and
unsuccessful patterns. In this post I want to focus on one of the more
successful patterns: good information management.

Engineering managers are expected to have loads of information ready
at all times. The architecture of the systems their team is responsible for,
current project priorities, cross-team points of dependence or collaboration,
and a myriad of other snippets of information. It's a _lot_, but I don't think
it's reasonable to expect a person to maintain so much information in their
active memory. That's why information management is _very_ important for a
management role, I don't need to _remember_ everything, but I do want to
remember where everything is _documented_.

Some of the productive patterns that I have seen and utilized:

* **Decision Log**: it's great when a team can make decisions quickly, but an
  inventory of decisions made is increasingly important as the team grows or
  evolves over time. This should include a synopsis of the decision being made,
  the alternatives considered, the trade-offs discussed between options, and
  the reasoning behind the decision ultimately made.
* **Link everything**: [Tim
  Berners-Lee](https://en.wikipedia.org/wiki/Tim_Berners-Lee) wants you to
  hyperlink all your hypertext! Creating a meeting invite? Link to the meeting
  notes page in the agenda. Creating a meeting notes page to discuss a project?
  Link to the project in the issue tracker. Creating a ticket in the issue
  tracker? Link to the decision made to implement that solution, or the
  customer support ticket(s) it relates to, or the other projects that this
  ticket blocks. Creating a commit to complete a ticket, link to the ticket in
  the commit and pull request. Every link created is a breadcrumb for the
  manager and the team to tap into this web of useful and related information.
* **Research must produce documentation**: frequently a manager or engineer needs
  to answer a question, that's it. "Can this technology be used to solve this
  type of problem." That research work doesn't usually result in a direct code
  or systems change to a production application, but the _output_ of that
  research should be documentation in the wiki. In essence **every bit of work
  in engineering should produce an artifact**. Most tasks will produce a pull
  request, but research tasks should produce a document which outlines what was
  learned, or create a new decision in the decision log. This allows the
  manager to benefit and reference back to knowledge gained during a project
  that did not lead to tangible code changes.
* **Metadata is crucial**: At least in the Atlassian suite of tools there are a
  myriad of ways to categorize pages and tickets. _Use them_. A good taxonomy
  of labels can go a long way. In the case of documentation in the wiki, this
  allows for creating aggregations of pages around a particular topic. These
  aggregation pages can provide a quick overview for all resources relating to
  a specific technology or project. In the issue tracker labels can provide a
  useful point to query tickets relating to a point in the ticket lifecycle, a
  project, or even a specific customer's needs.


From my perspective it is not the project managers job to add the necessary
links or information hierarchy, it is not even really the engineering managers
job. It is however the managers job to build the culture of information
management that allows them and the team to quickly recall or re-discover
critical information about the projects that are being worked.


Some managers I know use running Google Docs or Spreadsheets to manage their
workload, which may work for personal task tracking, but I typically discourage
their use. They're not linkable and discoverable enough! Many spreadsheets are
write-once and read-once. By building and collaborating with a shared
information management scheme, the team and the managers can benefit from the
on-going "gardening" of information.

Regardless of the system you use or consider, if you are a manager, please
consider that a large part of your job relies on managing _information_, and
institute the practices and systems necessary!

