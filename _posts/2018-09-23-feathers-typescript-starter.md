---
layout: post
title: A simple starter application for Feathers and TypeScript
tags:
- typescript
- feathers
---

It took me a little while to get comfortable with
[TypeScript](https://typescriptlang.org) when used in conjunction with
[Feathers](https://feathersjs.com). I have found the combination to be quite
useful for building small little web APIs and applications over the past couple
months, but starting from scratch has been a bit of a pain. Tweaking all the
configuration files, and getting all the right dependencies installed is not
somemthing I want to keep resident in my memory, so I have created this
[feathers-typescript-starter](https://github.com/rtyler/feathers-typescript-starter)
repository.

The repository has what _I_ find are suitable defaults and dependencies within
it. Including `winston` for logging, `sequelize` for accessing the database,
and `jest` for testing.

Unfortunately neither CLI provided by the `@feathers/cli` nor `sequelize-cli`
packages can properly generate TypeScript right now, so some additional
hand-tweaking is necessary to convert newly created services or models into
TypeScript.


I hope you find
[this repository](https://github.com/rtyler/feathers-typescript-starter)
useful!
