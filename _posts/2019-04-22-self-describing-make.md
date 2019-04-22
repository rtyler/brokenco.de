---
layout: post
title: Self-documenting Makefiles
tags:
- software
---

Ever since I stumbled across [this blog post on auto documented
Makefiles](https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html),
I have been adding the author's little snippet to every new `Makefile` that I
write.

The snippet, listed below, relies on comments on the same line as the Makefile
target beginning with `##`. This approach is simple and helps ensure that only
the targets which I want to be documented and output for others are documented,
rather than attempting to auto-generate a full list of targets from the
Makefile.


```make
help: ## Display this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
```

By adding the `help` target as the `.DEFAULT_GOAL`, bare invocations of `make`
will output the help information, ensuring that new developers can quickly
understand the build system.

```
➜  otto git:(master) make
build                          Build all components
check                          Run validation tests
clean                          Clean all temporary/working files
depends                        Download all dependencies
help                           Display this help text
parser                         Generate the parser code
prereqs                        Check that this system has the necessary tools to build otto
swagger                        Generate the swagger stubs based on apispecs
➜  otto git:(master) 
```


Neat!
