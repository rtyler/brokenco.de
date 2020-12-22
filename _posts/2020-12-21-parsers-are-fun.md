---
layout: post
title: Parsing in Rust
tags:
- rust
- pest
- antlr
---


In a world where everything is increasingly YAML, you might find yourself
wondering: "why bother to write a parser?" For starters, I recommend reading
the [YAML specification](https://yaml.org/spec/1.2/spec.html) before if you
haven't, but more importantly: there are so many domains which can be better
modeled with domain-specific semantics and syntax. When I was younger parsing
was typically done with lexx/yacc/bison/whatever and was complete drudgery, but
there are a few great modern tools in the Rust ecosystem that make writing
parsers _fun_.

I first dabbled in writing parsers with [ANTLRv4](https://github.com/antlr)
which is an absolutely **fantastic** toolset for writing parsers. The primary
author [Terence Parr](https://github.com/parrt) has written a number of good
books such as "The Definitive ANTLR 4 Reference" and "Language Implementation
Patterns". Both of which I recommend even if you're not setting out to write
that next great programming language.

In [Rust](https://rust-lang.org) our options are also pretty decent. When I
first ventured into writing Rust I discovered
[antlr4rust](https://github.com/rrevenantt/antlr4rust) which I promptly
bookmarked and then set aside until I had a parsing project. Once I finally had
a parsing project, I revisited the project and found that I didn't like the
ANTLR-like semantics in the Rust language. It didn't quite feel idiomatic
enough for me to feel comfortable.

More recently I have discovered **[Pest](https://pest.rs/)** which I have now
used within [Otto](https://github.com/rtyler/otto) and my most recent
experiment [Jenkins Declarative Parser](https://github.com/rtyler/jdp).

The grammar is similar enough to ANTLR that I was able to get started and my ideas quite quickly. Still, I haven't become clever enough to use parser-level stack manipulations, so I think that means I remain a parser-simpleton.


Below is an example of the grammar necessary to parse the `script { }` step in
Declarative Jenkins Pipelines, which themselves allow arbitrary Groovy code
within them (I didn't want to parse the groovy too).


```peg
scriptStep = { "script" ~ opening_brace ~ groovy ~ closing_brace }
groovy = {
            (
            // Handle nested structures
            (opening_brace ~ groovy ~ closing_brace)
            | (!closing_brace ~ ANY)
            )*
         }

stagesDecl = { "stages" ~
                opening_brace ~
                stage+ ~
                closing_brace
              }
```

The qualifiers and details on the grammar can be found in the [pest_derive
crate's documentation](https://docs.rs/pest_derive/).

Once compiled into the Rust program, using the generated parser is a _little_
goofy but still very workable, a snippet:

```rust
let mut parser = PipelineParser::parse(Rule::pipeline, buffer)?;

while let Some(parsed) = parser.next() {
    match parsed.as_rule() {
        Rule::agentDecl => {
            // parse the agent {} declaration
        }
        Rule::stagesDecl => {
            parse_stages(&mut parsed.into_inner())?;
        }
        _ => {}
    }
}
```

The parsers I am writing tend to be relatively simplistic, taking user-friendly
models and turning them into internal data structures for further use. While
basic it reminds me of the domain-specific language (DSL) "fad" among Rubyists.
I once joked "for loving Ruby so much, Rubyists sure do spend a lot of time
building tools to avoid writing Ruby." Once you have a simple and easy approach
to create syntax and tooling that better models the domain you're working it,
it's hard to avoid!

YAML, XML, and JSON have their place as data serialization formats, but far too
frequently they're used for configuration or other descriptive usages. Many
developers will cite "everybody knows YAML" in their use, thereby overlooking
that "syntax" and "semantics" are two very distinct pieces of the puzzle. Yes,
most everybody grasps the basics of YAML syntax, however whatever keys a
program is encoding as semantically significant for its configuration (see:
Kubernetes) is a _very_ different story.

The next time you find yourself needing to describe or model complex concepts
for your program, consider creating a language to describe it! Writing the
parser will be easier than you might think!
