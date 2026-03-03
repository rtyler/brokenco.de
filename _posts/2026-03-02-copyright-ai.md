---
layout: post
title: DCO and AI is a no-go.
tags:
- opinion
- opensource
---


The phrases "generative AI" and "copyright" evoke a multitude of stories about
unauthorized training, scraping, and violation of norms. The thought that
somebody could then turn around and then try to copyright works _generated_ by
these large language models is absurd, but in 2026 anything kind of goes
doesn't it?

One of the big arguments _against_ generative AI-based coding
tools is that they were trained on billions of lines of _copyrighted_ and
licensed works in the open source ecosystem, and they strip those works of all
attribution and violate the terms of the licenses.


Yesterday there was some fervor about [the Supreme Court allowing a lower court
decision to
stand](https://www.theverge.com/policy/887678/supreme-court-ai-art-copyright)
in my timeline. I have been following this topic for a few weeks after reading this
[Congressional Research Service report: Generative Artificial Intelligence and
Copyright
Law](https://www.congress.gov/crs_external_products/LSB/PDF/LSB10922/LSB10922.8.pdf)
(PDF) and considering how some of the guidance might affect the use of
generative AI in open source projects.


[kat nailed it with their toot](https://toot.cat/@zkat/116162089501237946)

> So uh
> 
> does this mean that there is now precedent that at least "agentic" dev systems,
> potentially any genAI dev system, now leaves companies open to their code no
> longer being considered copyrightable if they use these systems?

kat is right that **this is huge**.

In the [Delta Lake project](https://github.com/delta-io) we rely on [Developer
Certificate of
Origin](https://en.wikipedia.org/wiki/Developer_Certificate_of_Origin) (DCO) with
guidance from the Linux Foundation. Yes, [that Linux Foundation](https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation).

From the DCO:

> The contribution was created in whole or in part by me and I have the right
> to submit it under the open source license indicated in the file; or

From the [Apache License](https://www.apache.org/licenses/LICENSE-2.0.html):

> "Licensor" shall mean the copyright owner or entity authorized by the copyright owner that is granting the License.
>
> [..]
>
> "Contributor" shall mean Licensor and any individual or Legal Entity on behalf of whom a Contribution has been received by Licensor and subsequently incorporated within the Work.


I am no lawyer but I do have at least a 12th grade reading comprehension level.

If AI-generated works are not copyrightable, then it is not possible for
somebody to _license_ under any open source license, much less assert via DCO
that they are able to do so.

Again, this is a big deal.

From the Congressional Research report 

> The AI Guidance states that authors may claim copyright protection only “for
> their own contributions” to such works, and they must identify and disclaim
> AI-generated parts of the works when applying to register their copyright.

The only viable solution I can imagine is that all AI-generated code
contributions in open source projects is considered public domain and commented
appropriately. Otherwise I don't see a sensible path forward for
AI-generated code in open source projects.
