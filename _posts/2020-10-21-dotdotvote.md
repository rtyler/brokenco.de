---
layout: post
title: Quick and simple dot-voting with Dot dot vote
tags:
- rust
- dotdotvote
---


I recently launched [Dot dot vote](https://www.dotdotvote.com), a simple web
application for running anonymous dot-voting polls. Dot-voting is a quick and
simple method for prioritizing a long list of options. I find them to be quite
useful in when planning software development projects. Every team I have ever
worked with has had far too many potential projects than they have people or
time, [dot voting](https://en.wikipedia.org/wiki/Dot-voting) can help customers
and stakeholders weigh in on which of the projects are most valuable to them.
[Dot dot vote](https://www.dotdotvote.com) makes it trivial to create
short-lived polls which don't require any user registrations, logins, or
overhead.


![Dot dot vote](/images/post-images/2020-dotdotvote/ddv-poll.png)


The desire for the application came out of some of my own roadmap planning
exercises for [Scribd](https://tech.scrib.domc). Unfortunately I didn't finish
the application in time and had to hack together something unpleasant with
Google forms. Next time around, the tool will be ready!


Give it a try and let me know what you think!


## Technologies

Dot dot vote is [free and open source
software](https://github.com/rtyler/dotdotvote/), and is quite simple. The
backend is built with [Rust](https://rust-lang.org/) using the minimalistic
[Tide](https://github.com/http-rs/tide) web application framework and
[sqlx](https://github.com/launchbadge/sqlx) for database (PostgreSQL) access. The "frontend" is plain old HTML and some basic JavaScript being rendered via [handlebars-rust](https://github.com/sunng87/handlebars-rust).
The application is currently deployed on Digital Ocean's new "App Platform",
which I won't discuss in this blog post except to say that it is _interesting_
in both good and bad ways.


> "this might be the most complete/functioning oss tide app in existence"
>
> -- Co-maintainer of Tide

This isn't my first Rust application which has reached "production" status,
[hotdog](https://github.com/reiseburo/hotdog) deserves that honor. It is
however the first non-trivial web application I have built from top to bottom
in years. Much of the time spent on implementation was just getting familiar
with the tools. With that experience under my belt, I actually built another
(non-public) web application of similar scope in about a day of frenzied
coding; Rust is web-ready as far as I am concerned!

There are a couple tips I would like to share for anybody wishing to explore
using these tools for their own projects.

### cargo sqlx prepare

I made heavy use of the `query!` and `query_as!` macros in sqlx, which both do
compile-time SQL query syntax validation against your live database schema.
It's *incredibly useful*, but it has the downside of requiring a live database
connection for in CI and other builds.

The experimental
[sqlx-cli](https://github.com/launchbadge/sqlx/tree/master/sqlx-cli) has an
integration with cargo that allows you to generate a `sqlx-data.json` file
which the macros can use instead of a live connection.

Despite being experimental and arguably a bit bleeding edge, I had no issues
with using the latest `master` branch from sqlx.


### handlebars-rust template reload in dev

Dot dot vote uses the `register_templates` call in handlebars-rust to load the
templates in the `views/` directory. For obvious performance reasons this reads
everything once, compiles, and stores the templates in memory. In development
this is *not* very useful, since you have to restart the web server any time
you make a minor view change.

The approach that I took was to provide a `render()` function on the `AppState`
struct which would abstract Handlebars template rendering for the routes. Then, in order to allow for "reloading" of templates in development/debug builds, I used the following snippet:



```rust
    pub async fn register_templates(&self) -> Result<(), handlebars::TemplateFileError> {
        let mut hb = self.hb.write().await;
        hb.clear_templates();
        hb.register_templates_directory(".hbs", "views")
    }

    pub async fn render(
        &self,
        name: &str,
        data: &serde_json::Value,
    ) -> Result<tide::Body, tide::Error> {

        // Reload all the templates in debug builds on each render call
        #[cfg(debug_assertions)]
        {
            self.register_templates().await;
        }

        // etc
    }
```

---

Overall the project was fun exploration into the web world of Rust. I would
strongly recommend the Tide/sqlx/handlebars-rust stack for building small and
fast API and web services. The stripped release binary is ~4MB and only takes
up 30MB at runtime in production. The most basic tier in Digital Ocean is
**way** over-provisioned!


With this little side project "complete", it's back to other fun Rust hacking!
