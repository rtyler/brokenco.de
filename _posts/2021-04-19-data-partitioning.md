---
layout: post
title: "Understanding big data partitioning"
tags:
- deltalake
---

Data partitioning is one of the principles to utilize when developing large
data sets, but do you know what that actually means for the storage format? I
didn't! Many "big data" storage systems such as HDFS, S3, and Azure Data Lake
Storage all are effectively a **file system**. This past year or so, I've
become much more familiar  with [Delta
Lake](https://github.com/delta-io/delta-rs/) and kind of just assumed that data
partitioning was something being done at the transaction log level. Turns out I guessed wrong.


**Data partitioning is almost always _just_ special directories in the file system.**


I feel like I have been duped!


Consider the following example from the delta-rs test data:


```
delta-0.8.0-partitioned
├── _delta_log
│   └── 00000000000000000000.json
├── year=2020
│   ├── month=1
│   │   └── day=1
│   │       └── part-00000-8eafa330-3be9-4a39-ad78-fd13c2027c7e.c000.snappy.parquet
│   └── month=2
│       ├── day=3
│       │   └── part-00000-94d16827-f2fd-42cd-a060-f67ccc63ced9.c000.snappy.parquet
│       └── day=5
│           └── part-00000-89cdd4c8-2af7-4add-8ea3-3990b2f027b5.c000.snappy.parquet
└── year=2021
    ├── month=12
    │   ├── day=20
    │   │   └── part-00000-9275fdf4-3961-4184-baa0-1c8a2bb98104.c000.snappy.parquet
    │   └── day=4
    │       └── part-00000-6dc763c0-3e8b-4d52-b19e-1f92af3fbb25.c000.snappy.parquet
    └── month=4
        └── day=5
            └── part-00000-c5856301-3439-4032-a6fc-22b7bc92bebb.c000.snappy.parquet
```

In the above example the `delta-0.8.0-partitioned` [Delta](https://delta.io) table is
partitioned by year, month, and day. The table metadata _does_ have the `partitionColumns` defined, for example:

```json
{
    "partitionColumns":["year","month","day"]
}
```

What's _really_ giving the queries the performance benefits of partitioning is
the fact that the file system layout takes these "partitions" (special
directory names) into consideration when determining which files to actually
load up for the query.

At the end of the day, it all just comes down to binary files on the file systems.

"_It's a UNIX system! I know this!_"
