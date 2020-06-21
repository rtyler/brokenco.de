---
layout: post
title: "Writing Rust unit tests with async-std"
tags:
- async-std
- async
- rust
---

I have been writing a [lot of](https://github.com/reiseburo/hotdog) [Rust lately](https://github.com/rtyler/otto)
and as a consequence I have had to get a _lot_ better at writing unit tests. As
if testing along weren't tricky enough, almost everything I am writing takes
advantage of `async`/`await` and is running on top of the
[async-std](https://async.rs/) runtime.

Testing `async` functions with `async-std` is actually so easy it's no wonder
nothing showed up in my first search engine queries! Rather than using
`#[test]` use the `#[async_std::test]` notation and convert the test function
to an async function, for example:

```rust
async fn simple_method() -> boolean {
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[async_std::test]
    async fn test_simple_case() {
        let result = simple_method().await;
        assert!(result);
    }
}
```

That was easy&trade;


Another option which also worked out just fine was to utilize [smol](https://github.com/stjepang/smol) as in `dev-dependencies` to run something like:

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_simple_case() {
        let result = smol::run(simple_method());
        assert!(result);
    }
}
```

