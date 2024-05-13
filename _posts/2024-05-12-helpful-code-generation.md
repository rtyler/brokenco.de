---
layout: post
title: "A large language model is not a good co-pilot"
tags:
- software
- ml
- opinion
---

Large language models (LLMs) seem to only be good at two things: summarizing
text and making up bullshit. The idea that a general purpose LLM is going to
herald a new age of software development efficiency is misleading in most cases
bordering on malicious. While there are a number of other recommendations or
predictive machine learning models which _can_ improve software development
efficiency, LLMs propensity to generate bullshit undermines trust in a way that
makes me question their validity at baseline as a software development tool.

A couple months ago I recall using Google's Bard in an attempt to generate some Terraform boilerplate code. It so fantastically failed to do so that the top Google search result from Stack Overflow was almost always _functional_ code whereas Bard consistently produced invalid code. 

This weekend while playing around I tried out Llama 3, another LLM which was
also trained by pilfering the collective code commons of the internet, but
still cannot generate useful code. I asked it about Rust, and about [Delta
Lake](https://delta.io) which is was able to explain similar to the first page
of their respective Wikipedia pages.

I then asked:

> How do you read a delta table in rust?


Below a portion of its response:

> To read a Delta Lake table in Rust, you can use the `delta-rs` crate, which is a Rust wrapper around the Apache Arrow and Parquet libraries. Here's an example of
> how to read a Delta table:                                                                                                                                       


So far so good! You do use the [delta-rs](https://github.com/delta-io/delta-rs) crate, which is based on Apache Arrow and Parquet libraries. I'm cheating a bit since I helped create delta-rs, so this is more like a proctored exam rather than a true co-piloting experience. Llama 3 continues with some code:


```rust
use delta::DeltaTable;
use arrow::record_batch;

async fn read_delta_table() {
    // Load the Delta table using the delta-rs crate
    let dt = DeltaTable::load("path/to/table").await.unwrap();
                                                             
    // Get the first record batch (i.e., a chunk of data)   
    let rb = dt.next().unwrap();
    
    // Iterate over the records in the record batch      
    for row in rb.iter_rows() {
        // Print each record as a string
        println!("{:?}", row.to_string());
    }
} 
```

This code is so completely and utterly nonsense. That's not how you import the
`deltalake` library. That's not how you use Arrow. That's not how you open a
Delta table with Rust. There is no `next()` function on a `DeltaTable` struct.
There's no `iter_rows()` on a `RecordBatch`.

Almost everything about this code is incorrect. Not a little bit of "oh this is
perhaps referring to older APIs", flat out wrong, will not compile, never would have, fail.


The explanation of this code provided by the LLM contains even more gems:


> Here's what's happening:                                                                                                                                         
>                                                                                                                                                                  
> 1.  **`DeltaTable::load()`**: We load the Delta table using the `DeltaTable` struct from the `delta-rs` crate. Pass the path to the Delta table as a string.     
> 2.  **`next()`**: We get the first record batch (a chunk of data) from the loaded Delta table using the `next()` method.                                         
> 3.  **`iter_rows()`**: We iterate over the records in the record batch using the `iter_rows()` method, which returns an iterator over the rows.                  
> 4.  **`to_string()`**: For each row, we convert it to a string using the `to_string()` method.                                                                   
>                                                                                                                                                                  
> This code assumes you have the `delta-rs` crate installed and the necessary dependencies (e.g., Apache Arrow and Parquet). You can install `delta-rs` via Cargo: 
> ```
> [dependencies]
> delta = "0.10.1"
> ```                                                                                                                                                                 │        

As somebody with intimate knowledge of the `deltalake` library and protocol,
this is all ha-ha funny to me. But for somebody who might be trying to learn
something new or is rushing to get some work done, these sorts of answers are
so wildly misleading as to be dangerous. I don't expect LLMs to be able to
always produce coherent and compileable Rust code, but at no point will _any_
of these snippets lead the reader to a productive path of inquiry.


It seems that most of the people pushing LLMs in software development have an
ulterior motive that is _not_ in your best interest as a developer. Executives
who want to squeeze more productivity out of you, platforms who want to
increase lock-in to their proprietary tools, or hardware manufacturers who want
to sell more chips. 

This has been said a lot lately, but what makes delivering software hard is not
the "writing code", but typically the "understanding code" part. For which LLMs
are so poorly suited as to be worse than useless. If you cannot trust their
output, you have to both understand the slop they're producing _and_ be able to
figure out where it is wrong, and how you can fix it.
