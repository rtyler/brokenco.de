---
layout: post
title: The single most important middleware for Express
tags:
- javascript
- opinion
---

Almost every web framework I have used in the past five years shares the same
stupid flaw: mishandling of redundant slashes. Invariably this causes problems
when some script _somewhere_ joins URL segments together with multiple slashes
in them, and ends up receiving a 404.


The following [ExpressJS](https://expressjs.com/) middleware will properly neutralize redundant slashes
before the routing layer takes over.

```
  /*
   * Remove redundant slashes in the URL for properly routing
   *
   * For example: //authentication -> /authentication which ensures that the
   * request is routed correctly
   */
  app.all('*', (request, response, next) => {
    request.url = request.url.replace(/\/+/, '/');
    next();
  });
```

