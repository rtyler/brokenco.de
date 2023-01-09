---
layout: post
title: "ChatGPT and your intellectual property"
tags:
- software
- ml
- opinion
---

There is an excessive number [ChatGPT](https://en.wikipedia.org/wiki/ChatGPT)
screenshots littering social media right now, and not nearly enough critical
thinking about feeding data into this novel new chatbot. An anecdotal survey of
my timeline includes people asking ChatGPT to solve math equations, write
emails for them, create short story prompts, identify bugs in code, or even
generate code for them. Behold, the power of AI!

ChatGPT is created by [OpenAI](https://openai.com/blog/chatgpt/), which despite
the name is *not* any form of "open" organization, but rather a startup which
has been [considering funding at a pretty monstrous
valuation](https://siliconangle.com/2023/01/05/openai-startup-behind-chatgpt-discusses-tender-offer-value-29b).
In essence, ChatGPT is an AI tool trained on a large corpus of public and
proprietary information, packaged up as a kooky chatbot.

Fine. Setting aside my own annoyance with ML developers co-opting data from
"the commons", fine.

The zeal with which most people are dumping information into ChatGPT really
concerns me however. I have seen a number of people feeding their own source
code into ChatGPT to ask it to find bugs or security holes.  It would be
foolish to assume that the inputs into ChatGPT are not _also used to train
ChatGPT_, or at least the next generations of the model.

I am certainly no lawyer, but the two primary problems here are:

* Most developers are not authorized to disclose proprietary information of
  their employers. Pasting source code into _any_ browser window creates a
  liability, but a browser window with ChatGPT increases the likelihood that
  the source code disclosed will be _reproduced_ in the future, for some other
  user of the system. Uh oh!
* Can the code _generated_ by ChatGPT could be considered _yours_? Who actually
  owns the copyright to machine generated code, or machine generated anything
  for that matter? Do the architects of the system own it, or the users
  supplying the inputs? This particular wrinkle isn't unique to ChatGPT, but
  any ML tool generating data which occupies a space adjacent to human created,
  and copyrighted works.
 
 
My concerns with what OpenAI is doing with this data is not tin-foil paranoia.
[Adobe is catching
grief](https://news.yahoo.com/adobe-using-photos-train-ai-001413408.html) for
opting Lightroom users _in_ to train their AI with those users copyrighted or
proprietary works.

I am sure the legal system will catch up to the rapid evolution of these ML
robber barons, but until then I think we should all be _very_ weary of feeding
intellectual property to these systems.

