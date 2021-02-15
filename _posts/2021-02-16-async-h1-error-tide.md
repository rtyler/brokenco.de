---
layout: post
title: Reverse proxying a Tide application with Nginx
tags:
- nginx
- rust
---

Every now and again I'll encounter a silly problem, fix it, forget about it,
and then later run into the _exact_ same problem again. Today's example is a
confusing error I encountered when reverse-proxying a
[Tide](https://github.com/http-rs/tide) application with
[Nginx](https://nginx.org). In the Tide application, I was greeted with an ever-so-descriptive error:

```
ERROR tide::listener::tcp_listener > async-h1 error
```

I *knew* that I had hit this before, because I
remember discussing with [jbr](https://github.com/jbr) the need for
[async-h1](https://github.com/http-rs/async-h1) to be a bit more verbose in its
error messages. Try as I might however, I was not able to remember how to solve
the problem  Looking at the Nginx error logs, which weren't that much more helpful:

```
2021/02/14 17:41:26 [error] 45774#101333: *53 upstream prematurely closed connection while reading response header from upstream, client: 192.168.1.1, server: dotdotvote.com, request: "GET / HTTP/1.1", upstream: "http://10.0.1.6:8000/", host: "dotdotvote.com"
2021/02/14 17:41:26 [error] 45774#101333: *53 upstream prematurely closed connection while reading response header from upstream, client: 192.168.1.1, server: dotdotvote.com, request: "GET /favicon.ico HTTP/1.1", upstream: "http://10.0.1.6:8000/favicon.ico", host: "dotdotvote.com", referrer: "https://dotdotvote.com/"
```



Eventually I stumbled into [this closed GitHub
issue](https://github.com/http-rs/tide/issues/458) which had the critical
missing configuration snippet I was missing: `proxy_http_version 1.1;` It seems
that the `async-h1` crate cannot parse HTTP 1.0, or 2.0, or some version of
HTTP other than 1.1. I'm honestly not really sure what format was being sent
along to the Tide application.

My full `location` block below for reference: 
```
  location / {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host            $host;
    proxy_set_header X-Real-IP       $remote_addr;
    # https://github.com/http-rs/tide/issues/458#issuecomment-619243201
    proxy_http_version 1.1;

    proxy_pass http://dotdotvote;
  }
```


With that one weird trick, Nginx is happily reverse-proxying my little Tide
application!
