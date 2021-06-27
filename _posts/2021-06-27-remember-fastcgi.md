---
layout: post
title: "Remember FastCGI?"
tags:
- rust
---


"Serverless" is sometimes referred to as "cgi-bin" which isn't entirely fair as
it's somewhere between cgi-bin and FastCGI.  Somewhere along the way both faded
from memory. While goofing off last weekend wondered to myself: is
[FastCGI](https://en.wikipedia.org/wiki/FastCGI) still useful? Unlike the
classic cgi-bin approach where a script or program was executed for each
individual request, FastCGI is a binary protocol which allows for longer lived
processes serving multiple requests. It continues to be used in the PHP
community but seems to have largely fallen out of favor. Nonetheless I decided
to tinker a little bit with FastCGI in Rust.


The most sensible crate that I found was the [fastcgi](https://github.com/mohtar/rust-fastcgi) and played around a bit.
The crate is a bit old and I needed to do some fiddling to get a simple example compiling:

```rust
extern crate fastcgi;

use std::io::Write;
use std::net::TcpListener;
use log::*;

fn main() -> std::io::Result<()> {
    pretty_env_logger::init();
    let listener = TcpListener::bind("127.0.0.1:8010")?;
    info!("Listening on 8010");

    fastcgi::run_tcp(|mut req| {
        info!("Handling request");
        for param in req.params() {
            info!("{:?}", param);
        }

        write!(&mut req.stdout(), "Content-Type: text/plain\n\nHello, world!")
        .unwrap_or(());
    }, &listener);

    Ok(())
}
```


In order to test out my little FastCGI server I spun up nginx in Docker which required a little bit of configuration in the `nginx.conf`:

```
server {
    listen 8080;

    location / {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass 127.0.0.1:8010;
    }
}
```

After about 45 minutes of tinkering around I had an end-to-end example working
and arrived at the conclusion that if I was going to do all this process
management and web server configuration, how is this any better than just
running an embedded web server?

A functionally identical Rust program using
[Tide](https://github.com/http-rs/tide) looks something like this:

```rust
#[async_std::main]
async fn main() -> Result<(), std::io::Error> {
    tide::log::start();
    let mut app = tide::new();
    app.at("/").get(|_| async { Ok("Hello, world!") });
    app.listen("127.0.0.1:8080").await?;
    Ok(())
}
```

Unlike the FastCGI version, I can hit this directly when testing and do not require a local web server. Though, if I do wish to put this behind nginx, the configuration is quite similar:

```
server {
    listen 8080;

    location / {
        proxy_pass 127.0.0.1:8080;
    }
}
```

If you find yourself with a scripted language where processing HTTP requests
might be too slow or unsafe, I can still see some utility for FastCGI. For most
of the rest of us, HTTP won, just write little HTTP webservers.


