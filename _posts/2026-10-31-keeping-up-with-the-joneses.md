---
layout: post
title: Keeping up with the Joneses
tags:
- rust
- deltalake
- security
- software
---

Every non-trivial application these days is a layer of business logic on
top of an enormous pile of open source dependencies. Keeping up with _their_
releases, especially the security-relevant ones, is a job in itself. I am not
able to directly follow pull requests for some of our key dependencies in
[delta-io/delta-rs](https://github.com/delta-io/delta-rs), but I **do** try to
keep an eye out for releases of
[apache/arrow-rs](https://github.com/apache/arrow-rs) and
[apache/datafusion](https://github.com/apache/datafusion).

Before GitHub became Copilot AI Hub they built a lot of hidden features that
make integration with GitHub very useful like [Atom feeds for repo
tags](https://docs.github.com/en/rest/activity/feeds) at a predictable URL. For
DataFusion, that is
[github.com/apache/datafusion/tags.atom](https://github.com/apache/datafusion/tags.atom).
Drop that URL into any feed reader and new releases show up like any other
news.

I prefer `tags.atom` over the `releases.atom` variant you will also see since
lots of projects don't bother publishing GitHub Releases, like yours truly.
virtually every Rust crate however pushes git tags. 

## Generating the list

Every published crate records its repository on crates.io, so the pipeline is:
parse the manifest, ask the [crates.io API](https://crates.io/data-access)
where the code lives, and append `/tags.atom` to anything on GitHub:

```python
#!/usr/bin/env python3
"""Generate GitHub tag Atom feed URLs for a Cargo.toml's dependencies."""
import json
import sys
import tomllib
import urllib.request


def crate_repository(name):
    """Look up the repository URL for a crate on crates.io."""
    req = urllib.request.Request(
        f"https://crates.io/api/v1/crates/{name}",
        headers={"User-Agent": "cargo-atom-feeds (https://brokenco.de)"},
    )
    with urllib.request.urlopen(req) as resp:
        return json.load(resp)["crate"]["repository"]


def atom_url(repository):
    """Turn a GitHub repository URL into its tags.atom feed URL."""
    if not repository or "github.com" not in repository:
        return None
    path = repository.removesuffix(".git").rstrip("/")
    parts = path.split("github.com/")[-1].split("/")
    if len(parts) < 2:
        return None
    return f"https://github.com/{parts[0]}/{parts[1]}/tags.atom"


def dependencies(cargo_toml):
    """Yield crate names from a parsed Cargo.toml."""
    tables = [cargo_toml.get(section, {}) for section in
              ("dependencies", "dev-dependencies", "build-dependencies")]
    tables.append(cargo_toml.get("workspace", {}).get("dependencies", {}))
    for table in tables:
        for name, spec in table.items():
            # renamed crates: serde = { package = "serde_v8", ... }
            if isinstance(spec, dict) and "package" in spec:
                yield spec["package"]
            else:
                yield name


def main():
    with open(sys.argv[1] if len(sys.argv) > 1 else "Cargo.toml", "rb") as f:
        cargo = tomllib.load(f)

    for crate in sorted(set(dependencies(cargo))):
        url = atom_url(crate_repository(crate))
        if url:
            print(f"{crate:30s} {url}")
        else:
            print(f"{crate:30s} (no GitHub repository listed)")


if __name__ == "__main__":
    main()
```

**NOTE**: _The `User-Agent` header is not decoration; crates.io's
[data access policy](https://crates.io/data-access) asks for one, so be a mensch and use a custom one for your code should you run it :)_

Paste the unique URLs into your reader of choice and preso-bango I've got a
little bit better understanding of when my key dependencies get updated.

---

The feed entry is only a notification, I don't automate further than that. I
still read the release notes before upgjading anything because a lot of
dependencies have ... _errata_ and other considerations that bar their adoption.

Typically when I see a new tag show up it translates to a ticket or todo list
item, but at least then I know. [And knowing is half the
battle](https://www.youtube.com/watch?v=6I-MK9mF9nE)
