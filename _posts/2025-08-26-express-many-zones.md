---
layout: post
title: The thing about appendable objects in S3
tags:
- aws
- opinion
---


Storing bytes at scale is never as simple as we lead ourselves to believe. The
concept of files, or in the cloud "objects", is a useful metaphor for an
_approximation_ of reality but it's not _actually reality_. As I have fallen
deeper and deeper into the rabbit hole, my mental model of what _is_ storage
really has been challenged at every turn.

This evening I was at the [San Francisco FinOps
Meetup](https://www.duckbillgroup.com/san-francisco-finops-meetup/) with the
nice folks from Chime and the Duckbill Group. Corey asked some questions about
S3 Express One Zone that I thought warranted a little bit more thought.

Last year Amazon announced that [S3 Express One Zone now supports the ability
to append data to an
object](https://aws.amazon.com/about-aws/whats-new/2024/11/amazon-s3-express-one-zone-append-data-object/).

Setting aside the discussion on whether S3 Express One Zone is _actually_ useful for a
moment, I want to focus on the "appendable object" concept.

> Applications that continuously receive data over a period of time need the
> ability to add data to existing objects. For example, log-processing
> applications continuously add new log entries to the end of existing log
> files. Similarly, media-broadcasting applications add new video segments to
> video files as they are transcoded and then immediately stream the video to
> viewers.

I don't know much about media-broadcasting applications, so perhaps this
functionality is useful there, but I know a **lot** about log-processing
applications.

Corey's fundamental question about appendable objects: **is this useful in S3 Standard**.

After a good hour or two of consideration, I am going to say pretty
definitively: _probably not_.


Appendable objects work by requiring the writer, the caller of `PutObject` to
specify the offset of the object to put _new bytes_ at. This pushes a
coordination requirement to the writer which I have difficulty conceiving a way
to make work in real-world applications.

Setting `Standard` aside, I am having trouble grappling with how to design an application to use this functionality. Take the example provided in the AWS docs:

```
aws s3api put-object --bucket amzn-s3-demo-bucket--azid--x-s3 \
        --key sampleinput/file001.bin \
        --body bucket-seed/file001.bin \
        --write-offset-bytes size-of-sampleinput/file001.bin
```


* My application has written 4096kB of `file001.bin`
* I have more data to append, I need to know that **I am the only instance** appending to `file001.bin`
* I also need to know that **no other process has appended** to `file001.bin` past the original 4096kB boundary
* Then I `PutObject` the next 4096kB.

There is external-to-S3 coordination that would be required by an application
to make sure two concurrent appenders don't _ever_ touch the same file. In
fact, the only safe way I can imagine this working is to put a lock entry into
a DynamoDB table saying `process-A` is appending to `file001.bin`, and _then_
the process would need to send `HeadObject` to make absolutely certain it had
the _correct offset bytes_ before issuing a write.

For an application where a single process is _guaranteed_ to operate on a single object in S3, this would be viable, but I would need to make sure the application architecture ensures a number of guarantees are in place.

From a reliability standpoint, I don't know what would happen should a process
_crash_ in the middle of a write. Is the object forever corrupted? Are parts
left in limbo like when multi-part uploads are aborted? Perhaps at AWS their
applications don't crash in  the middle of I/O operations, but I can
confidently say that applications I write crash all the time!

**Bytes offsets are just so damn dangerous**.

As Corey now knows [I have a love/hate relationship with Apache
Parquet](/2025/07/16/no-way-parquet.html), which has been designed with a _lot_
of lessons learned from large scale data systems. Byte offsets as a way to write segments of an object are _extremely_ likely to lead to corrupted data. Developers like to joke about the two hard problems in computer science:

* Caching
* Naming things
* Off-by-one errors

The probability of an application corrupting its own data is 1.0.

With [Apache Parquet](https://parquet.apache.org) the **footer** contains the
important metadata about the data contained within the file. One major benefit
of the design is that the data must have been **written first** for a valid
file to exist. Contrast this to [Apache Avro](https://avro.apache.org), which I
am decidedly less fond of. Avro _starts_ with the file header and then data
blocks. The data blocks on their own indicate how long each block is, but as
far as I can tell there is no way for a reader to tell if all the necessary
data blocks were actually written to storage. You can easily tell if a data
block was partially written, but I don't believe you can tell if a data block
is simply missing.

The "finalization" of an Apache Parquet footer provides a very useful end for
the write of any particular data application.

## Just answer the question

Fine, okay, what were we talking about again?

Corey wants to know whether appendable objects are useful in S3 Standard?

**No**

Appendable objects require application level coordination which is largely
impractical for _most_ developers, myself included, to safely manage. Standard
tier introduces the challenges of availability zones to the discussion,
cross-AZ latencies, and a myriad of other distributed computing problems. What
_would_ be useful is cheaper [output conversions and
transformations](https://docs.aws.amazon.com/firehose/latest/dev/create-transform.html)
from Kinesis Firehose. Most append-oriented applications I have seen, built, or
designed, require something in the shape of a Kinesis, [Apache
Kafka](https://kafka.apache.org), or similar to provide that mission-critical
**durable data ordering** function.

Output conversion with Kinesis is an incredibly novel tool at our disposal.
While expensive it makes turning data streams into objects in S3 _very_
simple.

Appendable objects are best suited for applications where losing data or
corrupting objects is acceptable.

Management has kindly requested that I stop building such applications, so I'll
stick to more durable data primitives for now.
