---
layout: post
title: "Exploring TypeScript"
tags:
- javascript
- typescript
---


In my [previous post](/2018/08/30/cd-for-the-jenkins-project.html) I mentioned
[Jenkins Evergreen](https://github.com/jenkins-infra/evergreen) which requires
a significant _backend_ service to built and deployed to manage a pushed-update
lifecycle. The prototype of that service which I wrote sometime late last year
was in Ruby, but I quickly realized that my usual comfort area of Ruby and
Python were not going to meet some requirements for the service. Consequently,
I ventured into JavaScript, with the fantastic framework
[FeathersJS](https://feathersjs.com). Almost a year later, I now have some
thoughts on the strengths and weaknesses of server-side JavaScript, and have in
turn started to explore
[TypeScript](https://www.typescriptlang.org/). Overall I have found TypeScript
to be interesting, but it is not without its weaknesses.


## Complexity with External Libraries

When we first started building the Evergreen backend,
[Baptiste](https://github.com/batmat) suggested TypeScript for adding helpful
types and other features to our development of Evergreen. At the time, I was
most concerned with the added complexity TypeScript might add to a project
where nobody involved was familiar with TypeScript _nor_ JavaScript. Having
since started a couple of projects in TypeScript, I still believe this to be
the case, unfortunately.

When adding other JavaScript-based libraries to a project, they often need a
`@types` package or some other definition of what the types that package
requires for the TypeScript compiler to do proper type checking. Microsoft does
have this handy [TypeSearch web site](https://microsoft.github.io/TypeSearch/)
which makes discovering pre-existing types-packages easier. Without a
types-package however, you may need to add type declarations into your _own_
project for third-party libraries to realize benefits of TypeScript.

Assuming you understand the art and zen of TypeScript, creating these type
declaration files isn't _too_ difficult, but for the novice to intermediate
user, I believe it's still overly complex.

## Testing

For writing and executing JavaScript tests, I have been very happy with
[jest](https://facebook.github.io/jest). TypeScript and Jest _sort of_ get
along together. I recommend the additional package `ts-jest` and the following
configuration in `package.json` to ensure that TypeScript is being executed
properly within tests.

```json
  "jest": {
    "transform": {
      "^.+\\.tsx?$": "ts-jest"
    },
    "testRegex": "(/test/.*|(\\.|/)(test|spec))\\.(jsx?|tsx?)$",
    "moduleFileExtensions": [
      "ts",
      "tsx",
      "js",
      "jsx",
      "json",
      "node"
    ]
  }
```

The downside with `ts-jest` that I have found is that it's not as comprehensive
as the TypeScript compiler. This results in tests running despite compilation
failures, which leads me to question what code is actually running under test.
My workaround for this is to always maintain two terminal window panes open to
the right of my editor. One with `tsc -w`, to constantly re-compile on
filesystem changes, and `jest --watchAll` to constantly re-run tests on
filesystem changes.

By running both of these together, I get the helpful compilation errors out of
the TypeScript compiler, while still running my tests and getting the useful
test feedback.

While not ideal, when `tsc` says I have compilation errors and `jest` passes my
tests, I don't get the most confidence in those green test results.


## Outputting JavaScript

TypeScript out of the box seems to target a much newer version of ECMAScript
than Node LTS (8) or latest (10) supports out of the box. For server-side
applications, I've found the following `tsconfig.json` to result in good
Node-compatible JavaScript:


```json
{
  "compilerOptions": {
    "alwaysStrict" : true,
    "outDir": "./build",
    "module" : "commonjs",
    "skipLibCheck": true,
    "lib" : ["es2017"],
    "module": "commonjs",
    "moduleResolution": "node",
    "esModuleInterop": true,
    "importHelpers" : true,
    "target": "es2015",
    "sourceMap": true
  },
  "include": [
      "./src/**/*"
  ]
}
```

Of particular note are the `target` and `lib` properties which ensure that some
modern JavaScript features are made available with an appropriate output format
which will run on Node 10. Now, what features those are specifically I can no
longer remember as that was many Stack Overflow searches ago at this point.

As best as I can tell, `tsc` is rather smart in that if the configuration isn't
supposed to work with a certain version of JavaScript, than there will be
compile-time errors for some standard API calls, such as methods added to
`Array` or `String` in recent language revisions.

I'm not supremely comfortable cargo-culting configuration from one project to
another, but I have little interest at this point in time in understanding the
depths of how TypeScript is configured, and why one might choose various
options depending on the project's needs.


---

In my personal projects I have yet to truly realize the benefits of
TypeScript but I have definitely been burned by the lack thereof in other
projects. Experiencing bugs which would have been prevented in TypeScript gives
me the confidence to continue the exploration of TypeScript, despite some of
the challenges it presents.

In a future blog post, I hope to outline some of the challenges faced, and
patterns needed for successfully using TypeScript together with a FeathersJS
application. Honestly though, I'm not sure I've even figured that one out yet.
And therein lies the fundamental problem with TypeScript:

It's a great add-on to the JavaScript ecosystem, but it suffers the drawbacks
of being an add-on.
