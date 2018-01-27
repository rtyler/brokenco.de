---
layout: post
title: "Working with JavaScript callback APIs from async/await"
tags:
- software
- javascript
---

To ignore Node.js as a possibility in certain problem domains, for which it is
the best tool for the job, is a tremendously silly and at times unprofessional
decision. While I don't delight in writing JavaScript, I must acknowledge that
JavaScript has matured quite nicely over the past ten years. Perhaps the most
helpful addition, for me at least, are the `async` and `await` keywords which
aim to prevent the callback nightmare many casual JavaScript developers may
dread.

Particularly for Node applications, callbacks provided a mechanism through
which highly event-driven code could be executed. Inside the runtime, this generally
means the execution thread can defer certain slow operations, such as timers or
network I/O, until the timer fires or the socket's buffer has data available
for the application. All the while, executing other "work" within the
application. I was first introduced to this cooperative multitasking
approach over a decade ago, via "greenlets" in Python, the tools and libraries
I used were hacks on top of CPython, and never caught any significant adoption.
Node, however, is "just JavaScript" which practically every web application
must maintain some familiarity with anyways. This allowed Node to enter a
niche, which [Go](https://golang.org) would later intrude upon, of lightweight
and high-connection-count services.

Unfortunately, callback-oriented code is fairly difficult to read and
understand as it's execution-flow cannot be read linearly by scrolling down in
the text editor. For this reason, in my opinion, the `async` and `await` syntax
sugar is so valuable in JavaScript. Borrowing from
[javascriptasyncfunction.com](https://javascriptasyncfunction.com/),
callback-oriented code such as:


```javascript
function foo(onSuccess) {
  var request = new XMLHttpRequest();
  request.open('GET', 'https://swapi.co/api/people/1/', true);

  request.onload = function() {
    if (request.status >= 200 && request.status < 400) {
      var data = JSON.parse(request.responseText);
      onSuccess(data.name);
    }
  };

  request.send();
}
```

Can be re-written as:

```javascript
async function foo() {
  const response = await fetch('https://swapi.co/api/people/1/');
  const parsedResponse = await response.json();
  return parsedResponse.name;
}
```

This is all well and good, but only works because the APIs underneath, e.g.
`fetch`, have been introduced to support it. For the unfortunate developer
(read: me) who must work with the legacy "callback-oriented" APIs, it might not
be obvious how to use `async` and `await` in an application which _must_
integrate with callback-driven libraries.

---

While banging my head against this problem I learned that JavaScript engines
introduced the `Promise` API, which was somehow related, but it was never
succinctly clear how.

What I found so terribly confusing was: I had always seen the `async` and
`await` keywords used together but never with a callback-oriented API.

It helps to tease the two apart, and explain them separately:

**async**: should be used with a function declaration to denote that it can be
deferred and will, in effect, implicitly return a `Promise`.

**await**: should be used to block a sequential flow of execution until a
`Promise` can be resolved. `await` cannot be used unless the function
containing it is marked `async`.


Let's say I want to take a function, which currently uses callbacks, and
incorporate it into the rest of my `async`/`await` application. The trick, it
turns out, is to wrap it with a `Promise`:

```javascript
function sendMessage(payload) {
    return new Promise((resolveFunction, rejectFunction) => {
        clientAPI.send(payload, (error, response) => {
            /* in the callback */

            /* if there was an error, invoke the `reject` function as part of
               the Promise API. */
            if (error) { rejectFunction(error); }

            /* if there was a response, inoke the `resolve` function as part of
               the Promise API */
            resolveFunction(response);
        });
    });
}
```

This `sendMessage` function can then be used in other `async` type functions,
e.g.:

```javascript
async function notifyBroker() {
    let response = await sendMessage({ping: true});
    /* do something with `response` */
}
```

This doesn't completely change the writing of JavaScript to a sequential model,
the top-level invocation of this function must treat it as a `Promise`, e.g.:
`notifyBroker().then(() => { /* callback when notifyBroker() completes */ });`

It does, however, make it a lot easy to author non-blocking code without
a descent into callback hell.
