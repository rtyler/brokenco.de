---
layout: post
title: "Converting XML to JSON in Rust"
tags:
- rust
---

I generally default to using JSON for data interchange but there are still a
myriad of formats of XML out there, for which I have created the
[xmltojson](https://crates.io/crates/xmltojson) crate. I originally wrote this
one night to help me get an XML dataset into JSON so that I could use
[PostgreSQL's](https://postgresql.org) `JSONB` column type, but I only recently
published it to [crates.io](https://crates.io) since it may be useful for
others.

**Cargo.toml**
```toml
[dependencies]
xmltojson = "0"
```


The `xmltojson` crate implements [Stefan Goessner’s xml2json](https://goessner.net/download/prj/jsonxml/) which results in a fairly straightforward conversion of XML data structure into JSON. Take the following XML for example:


```xml
<ol class="xoxo">
    <li>Subject 1
        <ol>
            <li>subpoint a</li>
            <li>subpoint b</li>
        </ol>
    </li>
    <li>
        <span>Subject 2</span>
        <ol compact="compact">
            <li>subpoint c</li>
            <li>subpoint d</li>
        </ol>
    </li>
</ol>
```

This XML structured will be rapidly converted into the following JSON, with
attributes and children encoded into the structure:

```json
{
    "ol": {
        "@class":"xoxo",
        "li": [
            {
                "#text":"Subject 1",
                "ol":{
                    "li":[
                        "subpoint a",
                        "subpoint b"
                    ]
                }
            },
            {
                "span":"Subject 2",
                "ol": {
                    "@compact":"compact",
                    "li": [
                        "subpoint c",
                        "subpoint d"
                    ]
                }
            }
        ]
    }
}
```

There are some oddities with the JSON encoding of XML, particularly around
CDATA, but overall I have been quite pleased turning XML into JSON which I can
more easily query with `jq`, PostgreSQL, or even ingest into Elasticsearch.


If you happen to find any bugs, please submit pull requests [on GitHub](https://github.com/rtyler/xmltojson)
