---
layout: post
title: "Building an Azure Function to send IRC notifications with Rust"
tags:
- rust
- azure
- github
---


Delivering a simple payload to IRC is an ideal use-case for Function-based
cloud computing. Last year when GitHub discontinued their service for pushing
notifications into IRC channels, I had a perfect situation to couch-hack with a
library I had recently discovered: [Azure Functions for
Rust](https://github.com/peterhuene/azure-functions-rs/)

Functions-as-a-Service are a technology which I constantly kick myself for
liking as much as I do. Functions, Lambdas, or whatever you wish to call them
are a novel reinvention of [FastCGI](https://en.wikipedia.org/wiki/FastCGI),
and lots of fun to mock, but like its predecessors: when appropriately used,
Functions can be incredibly useful. I personally think Functions work well as
low-throughput "glue". Binding simple services or components together which
don't warrant an "always-on" application means Functions can make good
technical and financial sense.

I wrote [this simple function](https://github.com/rtyler/irc-push-function) a
few months ago, before I actually knew what I was doing with Rust. In the span
of an evening I was able to cobble something together which would read incoming
JSON and write information into a [Freenode](https://freenode.net) channel:

```rust
#[func]
pub fn webhook(req: HttpRequest) -> HttpResponse {
    if let Ok(event) = req.body().as_json::<PushEvent>() {
        info!("Parsed push event from {}", event.sender.login);
        dispatch_to_irc(event);
        return "Messages dispatched to IRC".into();
    }
    else {
        return "Failed to parse event".into();
    }
}
```

([it's really simple, I swear](https://github.com/rtyler/irc-push-function/blob/master/src/functions/webhook.rs))

I ended up learning more during this exercise about the Azure Functions Runtime
For Linux, than Rust itself. Traditional Azure Functions run inside a Windows
context, which aside from being totally hilarious, is incredibly limiting for
people wanting to do anything serious that isn't built around C#. The Azure
Functions for Linux support is exactly how I wish _all_ Functions-as-a-Service
providers operated: just build the thing into a Docker container. While the
[Dockerfile](https://github.com/rtyler/irc-push-function/blob/master/Dockerfile)
is a bit esoteric, the end result is a conventional container which can be
shipped off to a registry from a CI process, just like practically everything
else in my world.

Overall the "irc-push-function" I developed is simple enough, runs without a
hitch, and hasn't cost much of anything the entire time it has been running.
If you're already running workloads in Azure, I certainly recommend trying out
[azure-functions-rs](https://github.com/peterhuene/azure-functions-rs/).

