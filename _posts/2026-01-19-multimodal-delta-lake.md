---
layout: post
title: "Multimodal with Delta Lake"
tags:
- rust
- parquet
- deltalake
- ml
---

The rate of change for data storage systems has accelerated to a frenzied pace
and most storage architectures I have seen simply cannot keep up. Much of my
time is spent thinking about large-scale tabular data stored in [Delta
Lake](https://delta.io) which is one of the "lakehouse" storage systems along
with [Apache Iceberg](https://iceberg.apache.org) and others. These storage
architectures were developed 5-10 years ago to solve problems faced moving from
data warehouse architectures to massive scale structured data needs faced by
many organizations. The storage changes we need today must support
"multimodal data" which is a dramatic departure in many ways from the
traditional query and usage patterns our existing infrastructure supports.

> Multimodal learning is a type of deep learning that integrates and processes
> multiple types of data, referred to as modalities, such as text, audio, images,
> or video. This integration allows for a more holistic understanding of complex
> data, improving model performance in tasks like visual question answering,
> cross-modal retrieval, text-to-image generation, aesthetic ranking,
> and image captioning.
>
> [From Wikipedia](https://en.wikipedia.org/wiki/Multimodal_learning)

Honestly, I have been working on this problem for longer than I knew that it
had a name!

Working on [Content
Crush](https://tech.scribd.com/blog/2026/content-crush.html) at Scribd I have
had to negotiate an ever-present challenge: how do we make multimodal data
seamless to work with our classic tabular datasets?

A couple of the ideas that I have been thinking about revolve around one
principle: **re-encoding of existing data is unacceptable.** In the past I have
considered simply encoding binary data such as that from images or PDFs into
[Apache Parquet](https://parquet.apache.org). This approach suffers from a couple major flaws:

* Re-encoding requires substantial computation for any non-trivial set of images, PDfs, video, etc.
* Redundant object storage, even with compression it is unlikely that any
  organization which has terabytes or petabytes of image data will want to
  store a secondary copy of it for their multimodal needs.
* Embedding a 1MB PDF file inside of a Parquet file is _not silly_ but
  embedding a 10GB video file inside of a Parquet file is _very silly_. Any
  approach taken should scale in a reasonable fashion for data in the gigabyte
  to terabyte range.

A secondary objective in my thinking has been to avoid needing substantial
client changes for working with multimodal data. I recently watched [a talk by
Ryan Johnson](https://www.youtube.com/watch?v=YmY_NwaoxNk) about adding
transactional semantics to Delta Lake and one of the big takeaways that I
heard from him was about the troublesome nature of ensuring _all actors_ in the
system cooperated with the transaction semantics. In a modern data environment
that could be _dozens_ of different off-the-shelf libraries, Databricks
notebooks, AWS SageMaker transforms, and so on. The less "exposure" to the
client layer the better.


## Parquet Anchors

The first idea that I had was "Parquet Anchors" which would be built on [Binary
Protocol
Extensions](https://parquet.apache.org/docs/file-format/binaryprotocolextensions/)
in Apache Parquet. In most cases the rich text/image/video data is already
stored in object storage such as AWS S3 and a URL should be sufficient to
retrieve that data.

The extension of the binary protocol as I understand it, would allow custom
information to be encoded in the Parquet files that are being written as part
of an existing Delta Table. The specific mechanism of encoding this data is
somewhat irrelevant so long as it can carry:

* Artifact name (e.g. `some.pdf`)
* Artifact URL (`s3://bucket/prefix/of/keys/some-10x9u09123.pdf`)
* Artifact length (number of bytes)
* Artifact content type (e.g. `application/pdf`)
* Checksum
* Checksum Algorithm


### Pros
The most obvious benefit of going down this route is the ease at which one
could update existing data files _and_ this note from the Binary Protocol
Extensions document:

> _Existing readers will ignore the extension bytes with little processing overhead_


Logically Parquet Anchors could be quite simple to implement and for _most_
users of a Delta table with Parquet Anchors would never know they were there.


### Cons

The natural downside of this feature being hidden from existing readers is that
means clients must be updated in order to read the extension data properly. For
something like processing multimodal data where a row of content metadata
might refer to `some.pdf` this would mean the reader would have to have some
indication that it must:

1. Read the extended binary information
1. _Then_ fetch the necessary artifacts

There is another downside to this approach in that a table would need to be
"rewritten" but only _partially_. If a Parquet file added to the Delta table
references 1000 artifacts, then that `.parquet` file would need to be rewritten
to include the Parquet Anchors for those 1000 artifacts alongside that files
`.add` action. In essence I think this approach would require a full-table
rewrite where each `.parquet` in the transaction log would be retrieved,
processed, and rewritten with the appropriate Anchors.

Considering ways to address the shortcomings of Parquet Anchors I came up with
my next concept.


## Virtual Delta Tables (vdt)

The notion of Parquet Anchors I think is useful to hold onto, hyperlinks to
existing artifacts is a key part of the multimodal data storage solution, but
perhaps not as a direct encoding into the Parquet data files. Considering the
shortcomings led me to think of how to present a virtual Delta table "view" to
existing clients while hiding the disparate nature of the data behind the
scenes.

One underutilized feature of the Delta Lake protocol is the use of URLs in the
`add` actions which enables functionality like [shallow
clones](https://delta.io/blog/delta-lake-clone/). I have long thought of this
as a super power that should really be used more.


### vdt0: just the artifacts

The magic of the URL support in the Delta protocol is that the URLs don't even
have to point to object storage. Nothing about the protocol dictates that the
URLs must point to `s3://` or `abfss://` URLs, you can just point to `https://`
URLs. AWS S3 supports `https://` URLs, but so does _every other web service_.

Imagine a storage architecture which already contains heaps of `.pdf`
artifacts. A `vdt` web service could provide a read-only URL structure which
maps the existing object storage structure into a Delta Lake URL scheme.

A virtual table with just those PDF artifacts could be configured at
`https://vdt.aws/v1/<catalog>/<schema>/<table>`. Using tooling like
[s3s](https://github.com/s3s-project/s3s) `vdt` can provide S3-like operations
off of this virtual URL, exposing a virtualized JSON transaction log or
checkpoints for the Delta client.

Imagine the schema of such a virtual table for PDF artifacts:


| Column    | Datatype  |
| --------- | --------- |
| id | `long`|
| filename | `string` |
| content\_type | `string` |
| url | `string` |
| filesize | `long` |
| data | `binary` |
| checksum | `string` |
| checksum\_algo | `string` |

The virtualized transaction log is where the real fun can begin. If information
about the artifacts can be sourced from an existing database, then the
virtualized transaction log could contain numerous _imagined_ parquet files as
the `add` actions:

```JSON
{
  "add": {
    "path": "datafiles/some-guid.parquet",
    "size": 841454,
    "modificationTime": 1512909768000,
    "dataChange": true,
    "stats": "{\"numRecords\":1,\"minValues\":{\"val..."
  }
}
```

The special path for the `some-guid.parquet` would perform **on-demand**
parquet encoding for the underlying artifacts.  The most primitive
implementation could simply represent _each_ PDF file as a `.parquet` file with
an `add` action. So long as the `add` action conveyed the necessary file
statistics to allow consuming engine to filter out files which are not
necessary, this could be a seamless way to expose structured PDF data to the
consumer. The `path` in the action could _also_ refer to an already cached
version of the encoded file in S3 using the existing URL support in the
protocol, in this way clients could progressively cache as need be on the
server-side.

---

**Brief aside**: I have never fully understood why [Delta
sharing](https://delta.io/sharing/) exists as a separate entity. In my opinion
the Delta Lake protocol coupled with a clever server-side backend could provide
identical functionality for all existing Delta implementations.

---

Assuming the `vdt` service supports the schema defined above and can properly
retrieve the PDF artifacts and encode them as Parquet data on the fly, a query
such as `SELECT filename, raw FROM vdt WHERE filename = $?`.

### Pros

Breaking the pretense of "objects must actually exist" with Delta Lake is very
liberating.  On-demand encoding artifacts in Apache Parquet would means all
client-side libraries should be able to seamlessly work within their existing
environments.

When I think about potential approaches for implementing `vdt0` I can also
imagine many different potential avenues for optimization. 

### Cons

While I really do like this idea, I'm not sure _how much_ I should like it
considering the potential downsides:

* Requires some existing structure behind the scenes to build up a sensible
  virtual Delta log. For situations where artifacts are simply in a dumb bucket
  somewhere, with no metadata already stored in a relational database,
  producing a virtual transaction log would be quite difficult.
* I cannot imagine a sensible path for **write** workloads with `vdt0`.
* Without having implemented this (yet!) it is unclear to how much compute-time would be expended on uncached parquet file encoding.
* Most data scientists want the PDF/image/etc but they don't _typically_ want
  the raw bytes that they then have to parse through.


---

## Uh, what if you just don't use Delta Lake?

Hey good question. Great interlude opportunity!

As a seller of fine hammers and hammer accessories, everything does in fact
look like a nail.

Delta Lake is kind of a means to an end for me here. I think its protocol has
enough maturity in terms of features and client capabilities to provide
_almost_ everything I need from a multimodal storage system. I just can't/don't
want to shove everything into a Delta table per se.

---

## vdt1: adding virtual legs

Since I have already indulged in the heretical idea of "what if we just make
the files up" I went a level further to consider _what if we got even more
virtualized_. One key characteristic I dislike with the `vdt0` approach is that
it is _too simple_ believe it or not.

When I think about artifacts like PDFs, they have far more structure than just
bytes. There are pages, typically sections, text, images, titles, footnotes,
and so on. For most machine learning use-cases the data scientist may be
interested in raw bytes for some projects but much more often they are
interested in the _parsed_ and _structured_ data of the artifact.

While my expertise is largely around text-based storage and processing, I would
imagine image/audio/video artifacts also have similar structure of interest to
data scientists.

Indulging in even more virtual-thinking I started to think about collections of
data all associated with an artifact. There's the raw data schema above, but for PDFs I can also envision:

**Paragraphs**

| Column    | Datatype  |
| --------- | --------- |
| id | `long`|
| page | `long` |
| offset | `integer` |
| text | `string` |
| is\_heading | `bool` |
| heading\_level | `integer` |

**Images**

| Column    | Datatype  |
| --------- | --------- |
| id | `long`|
| content\_type | `string` |
| page | `long` |
| data | `binary` |
| bounds\_x | `long` |
| bounds\_y | `long` |

**Links**

| Column    | Datatype  |
| --------- | --------- |
| id | `long`|
| page | `long` |
| href | `string` |
| label | `string` |


Taken all together this only represents _20 columns_ of data but could
represent **most** of the information needed for most multimodal workloads. I
mention the low column count because I have seen bug reports from Delta Lake
users talking about issues with tables containing _thousands of columns_.

A virtualized table schema could take these interior schemas and join them
together such that a single row might have: `id`, `raw_filename`,
`raw_content_type`, `raw_url`, `raw_filesize`, `raw_data`, `raw_checksum`,
`raw_checksum_algo`, `paragraph_page`, `paragraph_text`, `paragraph_offset`,
`paragraph_is_heading`, `paragraph_heading_level`, `image_content_type`,
`image_page`, `image_data`, `image_bounds_x`, `image_bounds_y`, `link_page`,
`link_href`, `link_label`.

So long as the schema allows nullable columns for everything but `id`, the
`vdt` service can expose the disjointed data behind the scenes in a sensible
way with the `add` actions on the virtual Delta table and its file statistics.
For example an `add` action which includes `link` data would list all other
columns as null within the file statistics `nullValues` such that any engine
querying for `raw` columns would ignore that file entirely.

### Pros

I think this structure would be possible to build in a traditional Delta Lake
system assuming one wished to re-encode data into new storage. Hiding existing
data behind a virtualized Delta table allows us to avoid data denormalization.

Similar to `vdt0` there are optimization and caching approaches that are
readily available with `vdt1` but unlike `vdt0` the "write path" is more
apparent to me with this approach. By hiding metadata about an artifact inside
the virtualized data structure, writes which add rows with those columns could
sensibly be accepted and inserted into an internal Delta or other table.

Depending on how metadata associated with an artifact is concerned, the `vdt`
service could simply front a number of other conventional Delta tables and act
as a proxy ensuring to push predicates and I/O filtering "to the edge" as far
as it will go, before collecting results for the query engine.

### Cons

This approach is certainly the most complex but could potentially require the least amount of re-encoding of existing data assets. The devil is in the details with how one might map existing data sources together. My sketch above places a tremendous amount of emphasis on an `id` which acts as a primary key between all the metadata associated with a singular artifact.

Nothing defined thus far accounts for potential changes in an artifact or its
metadata as time goes on. If a new version of an existing document is uploaded,
the new version should likely be considered "canonical" but be _appended_
rather than _merged_ with existing records. How one might sensibly model that
in a system like Delta which doesn't support referential integrity between
datasets leads me back to the "anchors" idea from before.  That said, I'm not
sure if that's much ado about nothing.

---

From a data storage standpoint one key aspect of multimodal data is that the
different modalities are presented to the end user or system **together**. What
I like about the virtual Delta tables concept is that this it doesn't require
substantial client changes to accomplish but _does_ provide a path to present
various types of data _together_ for a given artifact.


I have various bits and pieces of a potential `vdt` system lying around the
workshop floor. If the idea has legs I might take a crack at a prototype
implementation, but first I will need some feedback!


Let me know what you think by emailing me at `rtyler@` this domain!

