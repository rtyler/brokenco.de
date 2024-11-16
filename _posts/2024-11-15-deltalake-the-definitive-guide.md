---
layout: post
title: "From the beginning, delta-rs to Delta Lake: The Definitive Guide"
tags:
- databricks
- deltalake
- buoyantdata
---


Nothing quite feels like "I made it!" like being _published_. Which is why I am
thrilled to share that [Delta Lake: The Definitive
Guide](https://bookshop.org/p/books/delta-lake-the-definitive-guide-modern-data-lakehouse-architectures-with-data-lakes-denny-lee/21429337?ean=9781098151942)
is available for purchase, and I kind of helped! I wanted to share a little bit
about how my contributions (Chapter 6!) came about, because my entrance into
the [Delta Lake](https://delta.io) ecosystem was about as unplanned as my
authorship of part of this wonderful book.


The [delta-rs](https://github.com/delta-io/delta-rs) project started in 2020 and I wish that I could say it is because
I am a brilliant visionary. The project largely started because I have had a
bias against JVM-based technology stacks and I had stepped into a role at
[Scribd](https://tech.scribd.com) where we were migrating to AWS, Databricks,
and a new architecture _anyways_ so why not challenge the orthodoxy? My
colleague [QP Hou](https://about.houqp.me/) and I were loving Rust and liked
Delta Lake from a design standpoint, but did not love [Apache
Spark](https://spark.spache.org) for some of the things we needed to do.

I would consider the official start of the project to be April 11th, 2020 when
I sent our Databricks colleagues the following:

----

Greetings! As I mentioned in our weekly sync up this week, we have an interest
in partnering with Databricks to develop and open source native client
interface for Delta Lake.

For framing this conversation and scope of the native interface, I categorize
our compute workloads into three groups:

1. **Big offline data processing**, requiring a cluster of compute resources where Spark makes a big dent.
1. **Lightweight/small offline data processing**, workloads needing "fractional
   compute" resources, basically less than a single machine. (Ruby/Python type
   tasks which move data around, or perform small-scale data accesses make up
   the majority of these in our current infrastructure, we've discussed using
   the Databricks Light runtime for these in the past, since the cost to
   deploy/run these small tasks on Databricks clusters doesn't make sense).
1. **Boundary data-processing**, where the task might involve a little bit of
   production "online" data and a little bit of warehouse "offline" data to
   complete its work. In our environment we have Ruby scripts whose sole job is
   to sync pre-computed (by Spark) offline data into online data stores for the
   production Rails application, etc, to access and serve.

I don't want to burn down our current investment in Ruby for many of the 2nd
and 3rd workloads, not to mention retraining a number of developers in-house to
learn how to effectively use Scala or pySpark.

My proposal is that we partner with Databricks and jointly develop an open
source client interface for Delta Lake. One where we would have at least one
developer from Databricks working with at least one developer from Scribd on a
jointly scoped effort to deliver a library capable of _initially_ addressing
our '2' and '3' use-cases.

[..]

Further, I propose that we jointly develop a client interface in Rust, which
will allow us to easy extend that within the Databricks community to support
Golang, Python, Ruby, and Node clients.

The key benefits I imagine for us all:

* Much broader market share for Delta Lake as a technology. Not only would
  companies like Scribd benefit, and continue to invest in Delta Lake, but
  other companies would have an easier on-ramp into the Databricks ecosystem.
  Basically, if you start using Delta Lake before you use Spark, you will (I
  guarantee) reach a point where these lightweight workloads become heavyweight
  workloads requiring the full power and glory of the Databricks runtime :D

* It's a fantastic developer advocacy story that hits a number of key bullet
  marketing points: open source, partner collaboration, Rust (so hot right now) :)

* Scribd is able to "immediately" take advantage of Delta Lake benefits without
  burning up all our existing codebase and investment in Ruby tasks and
  tooling. Thereby allowing for an easier onramp into Delta Lake and the
  Databricks platform as a whole.

The scope of the effort I think would be largely around properly dealing with
the transaction log, since the Apache Arrow project has already created a
pretty decent [parquet crate](https://crates.io/crates/parquet) in Rust. That
said, there may be some writer improvements we'd want/need to push upstream to
Apache Arrow to make this successful.

----


On second thought, almost all of this has come true! What a brilliant sage! (plz clap)

Like many advancements, there's a right time, a right place, and a right group
of people. Unfortunately Databricks didn't join the party until a later on but
were a strong supporter of our initial work, providing guidance and helping to
make [Delta Lake](https://delta.io) an ever-more thriving open source
community.  The right people were all converging on the direction that made
this possible with [Neville](https://github.com/nevi-me) helped make
[arrow-rs](https://github.com/apache/arrow-rs) a much better [Apache
Parquet](https://parquet.apache.org) writer. QP wrote the first version of the
protocol parser and created the first Python bindings for the library.
[Christian Williams](https://github.com/xianwill) built out
[kafka-delta-ingest](https://github.com/delta-io/kafka-delta-ingest) with
[Mykhailo Osypov](https://github.com/mosyp) and helped prove that: **Rust is
way more efficient for data ingestion workloads.**. As time went on Will Jones,
Florian Valeye, and Robert Peck joined the party and helped turn delta-rs from
a small Scribd-motivated open source project into a thriving Rust and Python
project.

<a href="https://bookshop.org/p/books/delta-lake-the-definitive-guide-modern-data-lakehouse-architectures-with-data-lakes-denny-lee/21429337?ean=9781098151942" target="_blank"><img src="/images/post-images/2024-deltalake/book-cover.jpg" align="right" width="200"/></a>

Scribd had wild success with the data ingestion being in Rust, and the data
processing/query being in Spark. The community grew, Databricks grew, and at
some point some folks started working on a book.

As a long-time maintainer of delta-rs and talking head in the Delta and
Databricks ecosystem I was asked to be a technical reviewer of the book after
Prashanth, Scott, Tristen, and Denny had already gotten more than halfway
through the chapters.

I provided as much feedback as I could on their chapters. I reviewed the
outline and noticed "Chapter 8: TBD".

What's supposed to be Chapter 8? "_We're not sure yet._"

My friend [Kohsuke](https://kohsuke.org) once marveled at how I was able to
acquire things for the [Jenkins project](https://jenkins.io) by the simple act of
asking for them. There's some skill involved in finding mutually beneficial
opportunities, but being uninhibited by the possibility somebody would say "no"
helps a lot.

"So this outline looks good, but when are you going to talk about Rust and
Python? There are dozens of us! Dozens!"

[Denny](https://dennyglee.com/) needed another chapter and I asked if I could
write about building native data applications in Rust and Python.


Suddenly I was helping to write a book.

----


[Scribd](https://tech.scribd.com) is a fun company to work at. Books,
audiobooks, podcasts, articles. We have a deep appreciation for the written
word, telling stories, and learning. All of which I value highly. Before this
experience however I had never seen the _other_ side of books. The creation,
the meetings, the rewrites, the edits, the reviews, going to press. It is
incredibly interesting and the team at O'Reilly are talented, helpful, and professional.

Going through copy-editing I was fielding review comments on the consistency of
tense, the subject of sentences, discussions about what is a proper noun and
how to consistently apply terms through _hundreds of pages_ of content. I have
heard about how invaluable editors are, I have now seen them in action am in
awe.

Over the years I have tried and failed to explain what I do to family members.
For people that don't work in tech "working on the computer" all looks largely
the same, especially for older generations. Having your work, your name _in
print_ has an intangible "wow" factor. More so than conference talks,
websites, GitHub stars, or branded t-shirts, a printed artifact recognizes the
accomplishments of the innumerable contributors to the Delta Lake ecosystem
over the years.


If you're data inclined, I recommend picking up a copy, Prashanth, Scott,
Tristen, and Denny have written a very useful guide, and also I contributed a
bit too! :)




