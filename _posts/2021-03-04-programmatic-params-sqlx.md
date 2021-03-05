---
layout: post
title: Dynamically adding parameters in sqlx
tags:
- otto
- rust
---

Bridging data types between the database and a programming language is such a
foundational feature of most database-backed applications that many developers
overlook it, until it doesn't work. For many of my Rust-based applications I
have been enjoying [sqlx](https://github.com/launchbadge/sqlx) which strikes
the right balance between "too close to the database", working with raw cursors
and buckets of bytes, and "too close to the programming language", magic object
relational mappings. It reminds me a lot of what I wanted [Ruby Object
Mapper](https://rom-rb.org/) to be back when it was called "data mapper." sqlx
can do many things, but it's not a silver bullet and it errs on the side of
"less magic" in many cases, which leaves the developer to deal with some
trade-offs. Recently I found myself with just such a trade-off: **mapping a `Uuid` such that I could do `IN` queries.**


When the `uuid` feature is enabled in sqlx, it will natively encode and decode
16-byte payloads into the `Uuid` type provided by the
[uuid](https://crates.io/crates/uuid) crate. It's neat, especially if you're
like me and like to use `Uuid` as a primary key rather than problematic
auto-incrementing integers. This approach runs into problems when trying to execute queries such as:

```sql
SELECT * FROM projects WHERE uuid IN (uuid1, uuid2, ...)
```

The above might be written in Rust with:

```rust
let records: Vec<Project> = sqlx::query_as("SELECT * FROM projects WHERE uuid IN (?)")
    .bind(&uuids) // try to bind the Vec<Uuid>
    .fetch(&conn) // Run the query
    .await?;
```

The problem is that the `.bind` function will not be able to properly map the
values of the `Vec` into the query engine. If you start to think about what
that would mean for sqlx to make this code work, you may start thinking of
short-cuts that won't work for a general purpose tool like sqlx. Perhaps
converting each `Uuid` to a string, and then joining that string with a comma?
Not all `Uuid``s are serialized the same, but even then, sqlx guessing that it
should serialize a bucket of byes into a string is spooky to say the least.


I struggled with this problem for the better part of an hour or so, and had a
good back and forth with one of the maintainers of sqlx in [this
issue](https://github.com/launchbadge/sqlx/issues/1083). Ultimately the code I came up with that worked operated by **dynamically** binding the N different `Uuid` types I had into the query:

```rust
// Create a dynamic query string with the right number of parameter
// placeholders injected
let query = format!(
    "SELECT * FROM projects WHERE uuid IN ({})",
    (0..keys.len())
        .map(|_| "?")
        .collect::<Vec<&str>>()
        .join(",")
);

// Dynamically bind each entry from 
let mut q = sqlx::query_as::<sqlx::Sqlite, Project>(&query);
for x in (0..uuids.len()) {
    q = q.bind(uuids[x]);
}

let records = q.fetch(&conn).await?;
```

The snippet above creates a query string with the right number of parameter
placeholders (`?`) and then iterates through the array to bind each parameter
in turn.

Using this somewhat verbose but simple approach, I managed to get my `IN`
queries with `Uuid` native types working, without any need to do my own
serialization or deserialization.
