---
layout: post
title: Feathers authentication for web pages and forms
tags:
- javascript
- feathersjs
---

I have been using [Feathers](http://feathersjs.com) for a number of projects
lately, including the backend and client for [Jenkins
Evergreen](https://jenkins.io/projects/evergreen). 
It is obvious from the design and structure of Feathers that a significant
amount of thought went into its development.  Overall, I have been happy with
the experience implementing clean APIs, and have added Feathers as my default
toolchain for new web API and application development. Feathers has been great
for building JSON-based RESTful APIs, but I stumbled over some hurdles when
using it as a more traditional web application framework.

The simplest to fix, but most frustrating to stumble over, was utilizing
[Feathers
Authentication](https://docs.feathersjs.com/api/authentication/server.html)
when serving [views via
Feathers](https://docs.feathersjs.com/guides/advanced/using-a-view-engine.html).
By default, the authentication in Feathers utilizes a [JSON
Web Token](https://jwt.io) for capturing the current authentication status of a
request. When using the
[OAuth2](https://docs.feathersjs.com/api/authentication/oauth2.html)
authentication mechanism, it is possible to tell Feathers to set a cookie with
the JSON Web Token.

Then, when adding authorization in front of a Feathers service, it's as simple as
adding a hook:

```javascript
{
  before: {
    all: [
      authentication.hooks.authenticate(['jwt']),
    ],
  },
  after: {
  },
  error: {
  },
};
```

Unfortunately even with that cookie set, a browser accessing the service, this
results in "Not Authentication" errors.

After a bit of searching around I eventually discovered some references to what
I _thought_ might solve my problem on this page titled:
[FeathersJS Auth Recipe: Authenticating Express middleware (SSR)](https://docs.feathersjs.com/guides/auth/recipe.express-middleware.html).

By default, though the OAuth2 authentication module for Feathers will _set_ a
cookie, it doesn't appear to do anything by default to _read_ that same cookie.
One must install and use the `cookie-parser` package.

```
$ npm install --save cookie-parser
```

Once the `cookie-parser` package has been installed, it's important that it
gets added as the first middleware in the application.

```javascript
const cookieParser = require('cookie-parser');
/*
 * Add the cookie parser to GET routes
 */
app.get('*', cookieParser());
/*
 * Add the cookie parser to POST routes
 */
app.post('*', cookieParser());
```

With this package installed and configured, the JWT cookie will be parsed
properly when for requests coming in to the application. This ensures that the
`authentication.hooks.authenticate(['jwt'])` hook has the appropriate material
it needs to perform the authentication.
