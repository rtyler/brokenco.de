--- 
layout: post
title: Virtual Hosting with HAProxy and WSGI
tags: 
- Software Development
- Linux
- Python
created: 1263688178
---
Lately I've fallen in love with a couple of fairly simple but powerful 
technologies: <a id="aptureLink_MG9e1mBPnu" href="http://haproxy.1wt.eu/">haproxy</a> and <a id="aptureLink_h4s21gIvSE" href="http://en.wikipedia.org/wiki/Web%20Server%20Gateway%20Interface">WSGI</a> (web server gateway interface). While the latter
is more of a specification (<a id="aptureLink_J39ynRlO1s" href="http://en.wikipedia.org/wiki/Wsgi">PEP 333</a>) the concepts it puts forth have made my life 
significantly easier. In combination, the two of them make for a powerful combination 
for serving web applications of all kinds and colors.

HAProxy is a robust, reliable piece of load balancing software that's **very** easy
to get started with, For the uninitiated, load balancing is a common means of distributing 
the load of a number of inbound requests across a pool of processes, machines, clusters and so on.
Whenever you hit any web site of non-trivial size, your HTTP requests are invariably transparently 
proxied through a load balancer to a pool of web machines.

I started looking into haproxy when I began to move [Urlenco.de](http://urlenco.de) 
away from my franken-setup of <a id="aptureLink_JfNVXqw8zi" href="http://en.wikipedia.org/wiki/Lighttpd">Lighttpd</a>/<a id="aptureLink_VtVTJkexMb" href="http://en.wikipedia.org/wiki/FastCGI">FastCGI</a>/<a id="aptureLink_M8XmGBHeCs" href="http://en.wikipedia.org/wiki/Mono%20%28software%29">Mono</a>/<a id="aptureLink_vg9xXC8F19" href="http://www.asp.net/">ASP.NET</a> to a pure <a id="aptureLink_RkZQSvmVt3" href="http://en.wikipedia.org/wiki/Python%20%28programming%20language%29">Python</a> stack. 
After poking around some articles about haproxy I discovered it can be used for **virtual hosts** 
as well as simple load balancing. Using a haproxy's ACLs feature (see Section 7 in the 
[configuration.txt](http://haproxy.1wt.eu/download/1.4/doc/configuration.txt)), you can 
redirect requests to one backend or another. While my "virtual hosting" with haproxy is using 
the ability to inspect the HTTP headers of inbound requests, you can use a number of different 
criterion to determine the right backend for serving a request: url matching, request method matching
(GET/POST), protocol matching (haproxy can load balance any kind of TCP connection) and so on.


WSGI (pronounced: *whiskey*) comes into play on the backend side of haproxy, using the 
<a id="aptureLink_2I1tbDf9Uh" href="http://eventlet.net/doc/modules/wsgi.html">eventlet.wsgi</a> module which provides a WSGI interface I can build web applications **very** 
quickly, test them and deploy them. When deployed, I can run them as "nobody" in userspace on
the server, binding to some higher numbered port (i.e. 8080) and haproxy will do the work routing
to the appropriate WSGI process.

Below is a simple haproxy configuration that I'm using to run [Urlenco.de](http://urlenco.de) and 
a site for [my wedding](http://erinandtylerswedding.com) and many more as soon as I finish them. The section to note is `frontend http-in` in which the ACLs are defined for the different virtually hosted domains and the conditionals for selecting a backend based on those ACLs.

    global
        maxconn         20000
        ulimit-n        16384
        log             127.0.0.1 local0
        uid             200
        gid             200
        chroot          /var/empty
        nbproc          4
        daemon

    defaults
        log global
        mode http
        option httplog
        option dontlognull
        retries 3
        option redispatch
        maxconn 2000
        contimeout 5000
        clitimeout 50000
        srvtimeout 50000

    frontend http-in
        bind *:80
        acl is_urlencode hdr_end(host) -i urlenco.de
        acl is_wedding hdr_end(host) -i erinandtylerswedding.com

        use_backend urlencode if is_urlencode
        use_backend wedding if is_wedding
        default_backend urlencode

    backend urlencode
        balance roundrobin
        cookie SERVERID insert nocache indirect
        option httpchk HEAD /check.txt HTTP/1.0
        option httpclose
        option forwardfor
        server Local 127.0.0.1:8181 cookie Local

    backend wedding
        balance roundrobin
        cookie SERVERID insert nocache indirect
        option httpchk HEAD /check.txt HTTP/1.0
        option httpclose
        option forwardfor
        server Local 127.0.0.1:8081 cookie Local
