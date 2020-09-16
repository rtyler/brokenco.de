---
layout: post
title: "Trait not bound errors with Diesel"
tags:
- rust
- diesel
- postgresql
---

Recently I have been exploring using [Diesel](https://diesel.rs) for a
simple Rust web application. I quickly ran into a very confusing `trait
bound` error, listed below when integrating with `chrono`. It took me a
while to understand and fix the error, which I thought I should write down
for later!


The error only started showing up when I queried a specific model:
```
error[E0277]: the trait bound `DateTime<Utc>: FromSql<diesel::sql_types::Nullable<diesel::sql_types::Timestamptz>, Pg>` is not satisfied
  --> src/main.rs:85:64
   |
85 |         let choices: Vec<Choice> = Choice::belonging_to(&poll).get_results(&pgconn).expect("Failed to get relations");
   |                                                                ^^^^^^^^^^^ the trait `FromSql<diesel::sql_types::Nullable<diesel::sql_types::Timestamptz>, Pg>` is not implemented for `DateTime<Utc>`
   |
   = help: the following implementations were found:
             <DateTime<Utc> as FromSql<diesel::sql_types::Timestamptz, Pg>>
   = note: required because of the requirements on the impl of `Queryable<diesel::sql_types::Nullable<diesel::sql_types::Timestamptz>, Pg>` for `DateTime<Utc>`
   = note: required because of the requirements on the impl of `Queryable<(diesel::sql_types::Integer, diesel::sql_types::Text, diesel::sql_types::Integer, diesel::sql_types::Nullable<diesel::sql_types::Timestamptz>), Pg>` for `(i32, std::string::String, i32, DateTime<Utc>)`
   = note: required because of the requirements on the impl of `Queryable<(diesel::sql_types::Integer, diesel::sql_types::Text, diesel::sql_types::Integer, diesel::sql_types::Nullable<diesel::sql_types::Timestamptz>), Pg>` for `models::Choice`
   = note: required because of the requirements on the impl of `LoadQuery<PooledConnection<ConnectionManager<PgConnection>>, models::Choice>` for `diesel::query_builder::SelectStatement<schema::choices::table, query_builder::select_clause::DefaultSelectClause, query_builder::distinct_clause::NoDistinctClause, query_builder::where_clause::WhereClause<diesel::expression::operators::Eq<schema::choices::columns::poll_id, diesel::expression::bound::Bound<diesel::sql_types::Integer, &i32>>>>`

error: aborting due to previous error; 1 warning emitted
```


I stumbled into [this closed issue](https://github.com/diesel-rs/diesel/issues/2445), which didn't really help me, but it did inspire me to review the `src/schema.rs`:

```rust
table! {
    choices (id) {
        id -> Int4,
        details -> Text,
        poll_id -> Int4,
        created_at -> Nullable<Timestamptz>,
    }
}
```

The `created_at` column is what is causing issues for me, and I noticed that it's wrapped in a `Nullable`. Meanwhile, my struct looks like:

```rust
#[derive(Associations, Debug, Identifiable, Queryable, Serialize)]
#[belongs_to(Poll)]
pub struct Choice {
    id: i32,
    details: String,
    poll_id: i32,
    created_at: DateTime<Utc>,
}
```


Turns out the `Nullable` wrapper around the `Timestamptz` SQL type was causing behavior that I didn't want. The underlying problem ended up being that my table definition didn't include a `NOT NULL` despite including a `DEFAULT NOW()`.

Naturally, altering the statement to be `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` caused my compilation error to disappear, fun!

