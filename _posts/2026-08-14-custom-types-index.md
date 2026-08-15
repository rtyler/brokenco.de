---
layout: post
title: Crashing the index with PostgreSQL custom types
tags:
- postgresql
- data
- dataeng
---

My current work project is one of the first Aurora/PostgreSQL deployments and
already the **largest**. Success brings _scaling challenges_ and the types of
things seasoned operators classify as "good problems to have." Compared to
previous scaling work around [Delta Lake](https://delta.io) the knobs and ways
in which online relational databases scale is a muscle that has atrophied in
the past decade. The relational database landscape is also quite different
especially with [Amazon Aurora which is quite well
designed](https://aws.amazon.com/video/watch/f2a0fcbccb8/)in the past decade.
The relational database landscape is also quite different especially with
[Amazon Aurora which is quite well
designed](https://aws.amazon.com/video/watch/f2a0fcbccb8/).

At some point it doesn't matter how "well architected" the underlying database engine was, the laws of physics still apply. The speed of light between CPU cores, storage, and memory still imposes limitations. Similar to my work
related to [Engineering around Extreme S3
scale](/2026/02/13/screaming-in-the-cloud.html), the difference between systems
which handle hundreds of millions of _something_ and hundreds of **billions**
of something is substantial. 


My original database design relied upon [Custom
types](https://www.postgresql.org/docs/current/sql-createtype.html), which I
really enjoy using for easily mapping complex data types into PostgreSQL.
Similar to a `struct` in Rust, at it's most simple a custom type is a
collection of associated fields:

```rust
struct Coordinate {
    brand: Brand,
    doc_id: u64,
    page: Option<u32>,
};
```

Can easily map into the database with:

```sql
CREATE TYPE coordinate AS (brand BRAND NOT NULL, doc_id BIGINT NOT NULL, page: INTEGER);
```
The utility of custom types is so _alluring_ for modeling richer data in at the
database level because so much of our mental models for systems are driven by
data encapsulation. I see similar design patterns from my colleagues when working with Delta Lake tables. A preference for creating columns of deeply nested structs, despite my protestations around flattening the into wider table schemas with more columns.

The biggest performance downside with custom types that I observed was when
using custom types in **indexes** but the issue was obscured by Aurora's
exceptional performance until we crossed into the _billions_ scale.

For the PostgreSQL engine version we were running, custom types in indexes would only be used correctly if the full type was present in the query. Using the example above this meant that a query would **not use the index correctly** when querying on `doc_id` alone! Instead the query was required to construct a type inline, e.g.:

```sql
SELECT * FROM some_table 
    WHERE c = ('scribd', 123, NULL)::COORDINATE

```

The inefficiencies of queries with a partial custom type predicate wasn't
noticed until queries in hitting billion row tables started to slow down. Those
production query plans made it fairly obvious that the index wasn't being used,
but it was not clear to me _why_ until after we really considered the offending query plans.


**Storage** of the custom type was also not something I considered until after
the billions scale where the indexes and table sizes ballooned. The [enumerated
type](https://www.postgresql.org/docs/current/datatype-enum.html) occupies four
bytes on disk. Combined with the other two entries in the type each row
required 16 bytes of storage. With smaller scale data that's kind of a "who
cares" amount of data but 10 billion rows that equates to around 149GiB to
store nothing but this one custom type in the table.

---

The solution we ended up with to resolve the inefficiencies of the custom type
for query and storage performance was to switch towards a bit-masked 64-bit
integer with the custom type's properties encoded within. 

My colleague experimented with using a binary encoded field which had similar
benefits over a custom type. Ultimately the bitmask approach allowed us to
halve the storage requirements and improved query performance since the index
moved from a hash index to a [b-tree
index](https://www.postgresql.org/docs/current/indexes-types.html) for
operations on that column.

**Billions** is such an astronomically large number that I often explain that
the "physics of billions" is so fundamentally different that it's like going
from Newtonian to Quantum physics: the old rules no longer apply. In our online
data system, we have tables that vary from hundreds of millions of rows, to
tens of billions of rows, and our modelling has to account for _both_ which has
been an exciting challenge.

<center><iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/XCv9Tviftgo?si=BzXciAynsuGwsshX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe></center>

The system would not have gotten this far without some of the superpowers that
PostgreSQL has to offer. Originally we deployed to PostgreSQL 17 but after
watching the above session we were convinced to upgrade to PostgreSQL 18 and
reaped the additional performance rewards offered by the upgrade.

PostgreSQL by default is quite fast. Aurora/PostgreSQL by default is
exceptionally fast. As a data system grows the "nice problems to have" start
popping up and query plans, APM traces, and all other sorts of telemetry become
crucial to understanding how and where to start improving performance.

I would not recommend avoiding custom types in PostgreSQL, there is a time and
a place for them, and we're still using them quite heavily, just not as indexed
columns!

