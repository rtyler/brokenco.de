---
layout: post
title: "Multiple Let's Encrypt domains in a single Nginx server block"
tags:
- nginx
- freebsd
- security
---


[Nginx](https://nginx.org) is a fantastic web server and reverse proxy to use
with [Let's Encrypt](https://letsencrypt.org/), but when dealing with multiple
domains it can be a bit tedious to configure.  I have been moving services into
more [FreeBSD](https://freebsd.org) jails as I alluded to [in my previous
post](/2021/02/02/freebsd-pkg-with-an-offline-jail.html), among them the
general Nginx proxy jail which I have serving my HTTP-based services. Using
Let's Encrypt for TLS, I found myself declaring multiple `server` blocks inside
my virtual host configurations to handle the apex domain (e.g.
`dotdotvote.com`), the `www` subdomain, and vanity domains (e.g.
`dotdot.vote`). With the help `Membear` and `MTecknology` in the `#nginx`
channel on [Freenode](https://freenode.net), I was able to refactor multiple
largely redundant `server` blocks into one.


With Nginx 1.15.9 a feature I have seen referred to as "dynamic certificates"
was released. Originally the `ssl_certificate` and `ssl_certificate_key` were
loaded when Nginx _started_. This meant that you could not refer to any of the
[Nginx variables](http://nginx.org/en/docs/varindex.html) when creating the
setting. With dynamic certificates, the resolution of the `ssl_certificate`
directive is done _later_ by the worker(s) process(es). It's a _very_ handy
feature!

```
server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name dotdotvote.com www.dotdotvote.com dotdot.vote;
  ##
  # Certificates
  ssl_certificate     /usr/local/etc/letsencrypt/live/$ssl_server_name/fullchain.pem;
  ssl_certificate_key /usr/local/etc/letsencrypt/live/$ssl_server_name/privkey.pem;

  # ... snip ...
  location / {
    # ... snip ...
    proxy_pass http://dotdotvote;
  }
}
```

In the example above, I'm using the `$ssl_server_name` variable which will
correspond to the server name requested in the SNI part of the TLS payload.
This ensures that the right hostname's certificate is utilized.

My first attempt was with `$server_name`, which I recommend you avoid using
`$server_name` since that will not be computed per request. For example, in the
block below the `$server_name` variable will _always_ be `dotdotvote.com` and
requests served on `www.dotdotvote.com` will use the incorrect certificate.:

```
server {
    server_name dotdotvote.com www.dotdotvote.com;

    ssl_certificate '/some/path/$server_name/fullchain.pem';
}
```

When I was originally setting this up, I also stumbled into some "Permission
denied" errors from Nginx. With the static certificate declaration, the _main_
Nginx process would load the file. That process would run as root before
dropping privileges to the `www` user for the Nginx worker(s). To address this
I needed to go change filesystem ownership in order for the `www` user to
properly read the certificate files.

---

In retrospect, this feature seems relatively simple to use if you have a good
understanding of the Nginx process and permissions model. Suffice it to say, I
wouldn't have figured this out without a bit of help from the folks in
`#nginx`. With the change in place my Nginx configurations are now much more
succinct and readable!
