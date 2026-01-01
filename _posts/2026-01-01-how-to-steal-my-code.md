---
layout: post
title: "How to steal my code"
tags:
- opensource
- opinion
- software
- software-development
---

All open source code has conditions attached. The majority of code which I have
written in my lifetime has been [open
source](https://en.wikipedia.org/wiki/Open_source) and therefore is usually
available for you to build from, distribute, or derive new works. There are
_some_ stipulations however and in this post I would like to help you
understand how you can take code I have written.

---

**A brief aside**
I find that using LLM-based coding assistants is unethical and
morally corrupt. These large language models were trained on open source code
en masse, with their different licenses and copyrights. Large-language models
are effectively laundering that code and re-selling it to other developers.
Cursor can help you write Terraform because its models slurped up code from
[Anton Babenko](https://github.com/antonbabenko) ([Putin
khuylo!](https://github.com/terraform-aws-modules/terraform-aws-s3-bucket?tab=readme-ov-file#input_putin_khuylo))
and thousands of others. Copilot is able to help you vibe-code a new Django app
because it copied [Tim Graham's](https://github.com/timgraham) and countless
other contributors' code without attribution.

Their outputs are a contemptible [parallel
construction](https://en.wikipedia.org/wiki/Parallel_construction) of intellectual property theft.

---

All of my code for the [Delta Lake](https://delta.io) project is licensed under
the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0). This
means if you want to copy this code you are welcome to, but you should include
the license text in your project **and** include **attribution**.

I have observed some confusion around attribution. 

**DO**:

* Include the copyright line from the license file where you're copying code
  from, e.g. `Copyright (2020) QP Hou and a number of other contributors.  All
  rights reserved.` for [delta-rs](https://github.com/delta-io/delta-rs)
* _or_ if you're lifting a snippet of code rather than whole files/modules, add
  a comment block around the section of code with the above copyright and
  mention that it's under the Apache License
* **and** include the copyright notice in **built binaries** from this code.
  The redistribution clause of the Apache License applies to source _and_
  object forms.

Also consider letting the upstream folks know! Most people open source code to
contribute to the general commons. Sending an email "hey thanks for X" goes a
_long_ way to making friends!

**Don't**:

* Just copy and paste the code you want, laundering copyrighted code like an
  LLM.
* Include nothing more than a comment in the source code with a link to code on
  GitHub.
* Pilfer code and then come back around and ask for credit for some _derived
  work_. I have lost count of the number of times "[I made
  this](https://knowyourmeme.com/memes/i-made-this)" has happened.


Since the "Business-Source License" nonsense started happening with Hashicorp,
Redis, MongoDB, and other open source presenting companies, I have taken to
licensing more and more of my code as
[AGPL](https://en.wikipedia.org/wiki/GNU_Affero_General_Public_License). That
does complicate matters a bit more but generally whatever you make with the
AGPL code has to also be made freely available.


I write free and open source code because I believe that produces the most
positive benefit for our society. I hope you can build something cool with code
that I wrote, but please follow the conditions of the license!
