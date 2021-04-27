---
layout: post
title: "Why build a native interface to Delta Lake"
tags:
- deltalake
- rust
---

Investing in the development of [delta-rs](https://github.com/delta-io/delta-rs) is one of the
longer shots I have taken recently and with my [upcoming Data and AI Summit
talk](https://databricks.com/session_na21/growing-the-delta-ecosystem-to-rust-and-python-with-delta-rs)
on the subject, I wanted to share some back story on the project. As I have
mentioned before [Delta Lake](https://delta.io) is a key component of
[Scribd's](https://tech.scribd.com) data platform. We selected Delta Lake for
many reasons, including that it is a open and vendor neutral project. The power
of Delta Lake has opened up countless opportunities for data and for the past
year I have seen the potential for many more.


Almost a year ago, I emailed some pals at [Databricks](https://databricks.com)
my thinking on why I _needed_ a native interface to Delta Lake. In this post I
will share some of those thoughts and highlight where I was **wrong**.


From that email, with some slight edits:

> For framing this conversation and scope of the native interface, I categorize
> our compute workloads into three groups:
>
> A: Big offline data processing, requiring a cluster of compute resources where
>    Spark makes a big dent.
>
> B: Lightweight/small offline data processing, workloads needing "fractional compute"
>    resources, basically less than a single machine. Ruby/Python type tasks
>    which move data around, or perform small-scale data accesses make up the
>    majority of these in our current infrastructure. We have discussed using
>    Spark for these in the past, but since the cost to develop/deploy/run
>    these small tasks on Databricks clusters doesn't make sense.
>
> C: Boundary data-processing, where the task might involve a little bit of
>    production "online" data and a little bit of warehouse "offline" data to
>    complete its work. In our environment we have Ruby scripts whose sole job is
>    to sync pre-computed (by Spark) offline data into online data stores for the
>    production Rails application, etc, to access and serve.
>
> I don't want to burn down our current investment in Ruby for many of the 'B' and
> 'C' workloads, not to mention retraining a number of developers in-house to
> learn how to effectively use Scala or Pyspark.

When I originally proposed a native interface, delta-rs did not exist. My
colleague [QP](https://github.com/houqp) created the initial sketch of delta-rs
over the course of a few weekends following my original description of the
challenges we faced; I think it was kind of a "I bet I can do this" motivation
on his part.

What I did not fully appreciate at the time was the resource cost and
complexity of data **ingestion** around Delta Lake. A non-trivial amount of
time and resources are spent simply getting data _into_ Delta Lake. Following
the framing above, these are typically "lightweight data processing workloads"
which take some form of data and append it to a Delta table. Identifying the
scope of this challenge led to the creation of
[kafka-delta-ingest](https://github.com/delta-io/kafka-delta-ingest). The
kafka-delta-ingest daemon is built on top of delta-rs to allow for scalable and
rapid ingestion of data from Kafka topics into Delta tables. The challenges of
running this workload in Spark Streams ultimately motivated the renewed
interest in what 


In my original vision I expected us to develop a Ruby binding, with room to grow to a Python, Node, and Golang binding down the road. I hoped we would develop the Ruby binding first to allow the
numerous Sidekiq and other Ruby processes at Scribd to dive into Delta Lake
data. Luckily that hasn't happened yet, but others in the open source community
have stepped up to provide a really good [Python
binding](https://delta-io.github.io/delta-rs/python/) which I am told is
already being used in **production** for some use-cases.

There's still time to be that amazing contributor to build Node or Golang bindings! ;)

---

Just over a year on from my initial "here's a wild idea that I think we could
make happen" and delta-rs has taken on a life of its own in ways I did not
anticipate. There have been over a dozen different contributors, support using
Delta Lake in Rust, Python, and early support for Ruby, and storage backends
implemented for the local filesystem, AWS S3, and Azure's Data Lake Storage
(Gen 2). There have been over 130 pull requests _merged_ and as of this writing
there are a few more in various states of draft or review. A second
implementation of the [Delta Lake
protocol](https://github.com/delta-io/delta/blob/master/PROTOCOL.md) has also
led to a few pull requests improve our collective definition of what Delta Lake
actually _is_.


I am also quite pleased that to date there has not been a single substantive
_code_ contribution by Databricks, the company which birthed Delta Lake. I
consider this to be hugely **positive** for the [Delta Lake
project](https://delta.io) as a whole. Foundations and open source ecosystems
will always benefit from a diversity of contributors whether at an individual
or a corporate level.

Databricks has been a hugely supportive partner in this effort, making time and
space for answering questions, making suggestions, and helping to popularize
the delta-rs work that has been done. For that I am tremendously grateful. One of these days I'll convince them to start writing some [Rust](https://rust-lang.org) ;)

---

To me the story of delta-rs and Scribd's involvement in its development is why
I think it is essential for engineering leaders to invest in open source
standards, projects, and communities. Any core platform or infrastructure
component needs to _last_ in an ever-changing technology stack, and there's no
way to predict where the road will take you. Working within and around an open
source community provides a path forward to grow the technology that is key to
the organization.



