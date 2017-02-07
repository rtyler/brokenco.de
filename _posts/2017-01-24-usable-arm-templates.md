---
layout: post
title: "Make JSON files readable, or, Azure Resource Manager templates in YAML"
tags:
- azure
- infra
- docker
- jenkins
---


The Jenkins project is currently undergoing a major infrastructure migration to
[Microsoft Azure](https://jenkins.io/blog/2016/05/18/announcing-azure-partnership/https://jenkins.io/blog/2016/05/18/announcing-azure-partnership/)
as our primary infrastructure provider, and as a result, I have been spending a
tremendous amount of time getting friendly with Azure tooling.

Azure gets a lot of things _right_, I would argue more things _right_ than AWS,
but they also get a few things **wrong**. One of the more frustrating things
that Azure gets _wrong_ is their AWS CloudFormation-equivalent tool "Azure
Resource Manager" (also referred to as "ARM"). The implementation of ARM and
distinction of "Resource Groups" in Azure's conceptual model is superior, in my
opinion, to anything AWS currently has, but the mimicking of CloudFormation by
defining ARM Templates as **JSON** is utterly annoying.

JSON is a **machine-readable format**, it is not a human-readable format and
its use by various vendors as a "configuration format" is misguided at best.
While the (mis)handling of trailing commas is annoying, the lack of inline
comments is abhorrent.

Based on a suggestion by my former colleague
[@jotto](https://twitter.com/jotto), the Jenkins project no longer has any ARM
templates written in JSON.

![Just use YAML](/images/post-images/arm-templates-yaml/jotto-tweet.png)


Our [jenkins-infra/azure](https;//github.com/jenkins-infra/azure) repository
nowcontains all the tools necessary to make this viable but in short, we use
a script (`yaml2json`) and GNU/Make targets to convert all the `.yaml` files in our
`arm_templates/` directory to `.json` files for deployment into Azure.


### The yaml2json script

The key script is called
[`yaml2json`](https://github.com/jenkins-infra/azure/blob/master/scripts/yaml2json)
which is a very simple Python script for taking a list of `.yaml` files and
outputting their equivalent `.json` files in the same directory:

```python
#!/usr/bin/env python

import json
import sys
import yaml

def main():
    if len(sys.argv) == 1:
        print 'Must pass a list of yaml files'
        sys.exit(1)

    for f in sys.argv[1:]:
        contents = yaml.load(file(f))
        json_path = f.replace('.yaml', '.json')
        with file(json_path, 'w+') as fd:
            fd.write(json.dumps(contents))

if __name__ == '__main__':
    main()
```

Obviously very simple, but it requires the `yaml` module which for some reason
*still* isn't included in Python's "batteries included" standard library. To
make sharing and re-use fo this script easy across contributors, I added a
Docker container to the
[jenkins-infra/azure](https;//github.com/jenkins-infra/azure)
repository.

### The python-yaml container

We generally assume that everybody implementing Terraform plans and ARM
templates has Docker installed. Frankly, I cannot imagine doing any kind of
operations/infrastructure work without a local Docker daemon running anymore,
so it's not a high bar to pass.

To run the `yaml2json` script effectively, we have a
[wrapper script](https://github.com/jenkins-infra/azure/blob/master/scripts/python-with-yaml)
which will build a Docker container if it doesn't exist and then execute
Python:


```bash
#!/bin/sh

# local container which will just run Python with PyYaml installed since it's
# not in the default python distribution
CONTAINER=python-yaml

docker inspect -f . ${CONTAINER} > /dev/null
if [ $? -eq 1 ]; then
    cat << EOF | docker build -t ${CONTAINER} --rm -
FROM python:2-alpine
RUN pip install pyyaml
EOF

fi;
exec docker run --rm -i \
    -v $(readlink -m $(dirname $0))/../:/data -w /data \
        ${CONTAINER} $@
```

I would consider the script above a hack, and wouldn't use this approach for
anything of any major consequence, but inlining the `Dockerfile` and building a
container with a single Python package installed needn't have too much
supporting infrastructure around it.

With the `python-with-yaml` script implemented, the Makefile cleverness can
then be added to tie everything together and ensure the `.json` templates are
generated before we attempt to deploy anything to Azure.

### The Makefile

Since we are [already using a Makefile](https://github.com/jenkins-infra/azure/blob/master/Makefile)
for validating and deploying our Terraform plans, it makes sense to extend our
Makefile implementation to ensure that the YAML templates are converted to JSON
before deploying anything.

```
# The default rule will make sure that all yaml files are converted to their
# JSON equivalents
all: $(patsubst %.yaml,%.json, $(wildcard *.yaml))

%.json: %.yaml
    ../scripts/python-with-yaml ./scripts/yaml2json arm_templates/$<

clean:
    rm -f *.json

.PHONY: all clean
```


The
[Makefile](https://github.com/jenkins-infra/azure/blob/master/arm_templates/Makefile)
is short, but uses some features not known to many novice or intermediate
GNU/Make users. The first two targets are all that really need explaining here:

```
all: $(patsubst %.yaml,%.json, $(wildcard *.yaml))
```

The first defined target is `all`, which is a [Phony
target](https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html#Phony-Targets),
includes a clever path substitution (`patsubst`) when defining its prerequisite targets.
The `wildcard` will list all `.yaml` files in the directory and replace the
`.yaml` with a `.json` at the end. In essence, if `database.yaml` exists, there
will be a prerequisite for the target `database.json` in Make.


```
%.json: %.yaml
    ../scripts/python-with-yaml ./scripts/yaml2json arm_templates/$<
```

Experienced Make users will recognize this pattern for
[generating prerequisites automatically](https://www.gnu.org/software/make/manual/html_node/Automatic-Prerequisites.html#Automatic-Prerequisites).
Given the above example file, `database.yaml`, this will create a target for
`database.json` which itself has a prerequisite for `database.yaml`. Defining
the `database.yaml` prerequisite is important as changes to that file will
cause the next `make` invocation to regenerate the `.json` file. In most
compilation-based environments, this approach is what effectively supports
"incremental compilation." The rules for the target itself simply use the `$<`
variable, which is an
[automatic variable](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables),
for the name of the first prerequisite (i.e. `database.yaml`), allowing
`yaml2json` to be invoked properly.

---

Combining these three scripts has removed much of the frustration I have been
having with ARM templates over the past few weeks. In addition to being more
human-readable, YAML's support for inline-comments means that contributors,
such as myself, can easily explain what is happening in our more complex
templates and why.


Don't let JSON make you cry, YAML is just a few scripts away!
