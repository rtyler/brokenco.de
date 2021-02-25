---
layout: post
title: Thoughts on WebTorrent
tags:
- infra
- opinion
---

[WebTorrent](https://webtorrent.io)
is one of the most novel uses of some modern browser technologies that I have
recently learned about.  Using WebRTC is is able to implement a truly
peer-to-peer data transport on top of support offered by existing browsers. I
came across WebTorrent when I was doing some research on what potential future
options might exist for more scalable distribution of free and open source
libraries and applications. In this post, I want to share some thoughts and
observations I jotted down while considering WebTorrent.

WebTorrent basically implements BitTorrent on top of the browser technology
stack, which means that as clients download a file they also help upload it to
other clients. Before the popularization of cloud providers, streaming
services, and self-service CDN companies, the BitTorrent model was pretty much
the only viable mechanism for many large free and open source projects to
distribute larger binaries. Not counting those who had friends with fast `.edu` or Internet2 uplinks who started to offer hosting and distribution like my pals at the [Oregon State University Open Source Lab](https://osuosl.org).
BitTorrent's popularity seems to have largely faded when most of the
interesting videos, and a lot of porn, started to become available via far
simpler streaming services like YouTube, etc.

To date the number one inhibitor of BitTorrent conceptually is that it has
*never* been natively integrated to the browser. The internet is **much** more
than just `www` and what we see in the browser, but for most mainstream
consumers if it is not available over the web, it might as well not exist.


[WebTorrent](https://webtorrent.io/faq) solves that key and crucial limitation
which on its own is quite an impressive achievement. It does however come with
some key drawbacks that have given me pause on rushing to roll out WebTorrent
in the projects with which I am affiliated:

1. WebTorrent effectively operates outside of the existing BitTorrent network.
   Since it is over WebRTC there are limitations on creating connections to
   other native BitTorrent clients and trackers which operate over TCP or UDP.
   For a file provider, such as an open source project, would need to operate
   two "seeders" should they wish to serve a file over both BitTorrent and
   WebTorrent.
2. Browser-based implementations of WebTorrent, such as that found in [PeerTube](https://github.com/Chocobozzz/PeerTube)
   run into a _classic_ BitTorrent problem: insufficient seeders. PeerTube is a
   decentralized video streaming platform which has support for federation and
   video redundancy. When clients are viewing a video or stream, their browser
   window sets up a WebTorrent session and they begin downloading from existing
   seeders, typically the PeerTube instance the user typed into their address
   bar. If they're lucky, the PeerTube instance has been "followed" and another
   PeerTube instance has provided "video redundancy" meaning there may possibly
   be more than one seeder for the WebTorrent client. _Additionally_ the person
   watching the video becomes a seeder as well. 
   
   In practice what this means is that WebTorrent can only help avoid massive
   bandwidth requirements for the originating PeerTube instance if:
     * There are multiple PeerTube instances providing video redundancy on the video being watched.
     * Multiple viewers are watching the video **simultaneously**.

   Generally speaking, once a viewer closes the browser window/tab, they _stop_
   seeding the file. This means that practically WebTorrent-based applications
   may only be advantageous if they can convince users to keep their browsers
   seeding after they have finished with the file.
3. Server-side support for WebTorrent is not quite as mature as I would have
   hoped. There are relatively stable Node packages such as
   [webtorrent-hybrid](https://npmjs.com/package/webtorrent-hybrid) which can
   help systems administrator run WebTorrent seeders without needing a browser.
   Outside of the Node ecosystem, the only implementation I could find of any
   notoriety was the [recently
   added](https://feross.org/libtorrent-webtorrent/) support for WebTorrent in
   the [libtorrent](https://www.libtorrent.org/) C++ library. I have no
   opinions on the library itself, but the nature of many C++ libraries like
   libtorrent makes them somewhat challenging to interoperate with in languages
   that provide fast-function interfaces (FFI) such as Python and Ruby, or
   those which provide native C-interop such as Java, Golang, and Rust. 

WebTorrent is still _so cool_. I am really hoping to it continues to grow and
succeed. With some very compelling implementations in PeerTube and
[Instant.io](https://instant.io/), I think WebTorrent has the potential to
provide a really liberating foundation for decentralizing some facets of our
internet infrastructure.

It might not yet be what _I_ want it to be, but it's definitely something worth
keeping an eye on!
