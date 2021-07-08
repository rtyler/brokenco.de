---
layout: post
title: "Accessing Handlebars variables in an outer scope"
tags:
- rust
---

This weekend I learned some unfamiliar behaviors with the way Handlebars
handles nested variable scopes. I typically use Handlebars via the
[handlebars-rust](https://github.com/sunng87/handlebars-rust) implementation
which aims to maintain nearly one to one compatibility with the [JavaScript
implementation](https://handlebarsjs.com/). They have block scope helpers such
as `#each` and `#with`, both of which create an inner scope for variable
resolution. Unfortunately, the syntax can be quite unintuitive for accessing outer
scope once in those nested scopes.

Handlebars is a largely declarative templating syntax which uses curlybraces
such as `{{var}}` for variable and helper substitution. The `#each` helper is
important for loops, imagine the following data structure:

```json
{
  "repos" : [
    {
      "name" : "otto"
    },
    {
      "name" : "l4bsd"
    }
  ],
  "mood" : "cool"
}
```

This could be rendered into a list on a page via:

```html
<ul>{% raw %}
    {{#each data.repos}}
        <li>{{name}}</li>
    {{/each}}{% endraw %}
</ul>
```

Inside the `#each` block the values of the indexed object become the scope for variable resolution, such that `{{name}}` actually refers to `data.repos[i].name`. This presents problems when the template must refer to outer scope variables, such as `mood`. In the Rust implementation this variable resolution can be accomplished through a path traversal style syntax such as:

```html
<ul>{% raw %}
    {{#each data.repos}}
        <li>{{name}} is {{../data.mood}}</li>
    {{/each}}{% endraw %}
</ul>
```

The `../data.mood` is all that's needed to refer to the variable in the outer
scope of variables. Not what I expected at all, and the only reason I found it
was because I found [an old
issue](https://github.com/sunng87/handlebars-rust/issues/416) which alluded to
the syntax and gave it a try.


