---
layout: post
title: "Visualizing Kafka streams with Kafkakitty"
tags:
- kafka
- kafkakitty
- rust
---

People will sometimes look at my screen covered in terminal windows
overflowing with text: "how do read all that?" These moments remind
me how inscrutable backend development can appear to the outsider. Today I
would like to introduce a tool that I hope makes a some parts a _little_ more
easy to understand: [Kafkakitty](https://github.com/reiseburo/kafkakitty)


Kafkakitty is a kafkacat-inspired utility which brings Kafka messages to your
browser in real-time. Building on the concepts I explored with a project years
ago titled 
[Offtopic](https://github.com/reiseburo/offtopic), Kafkakitty is a tiny
web application which you can run locally to provide a nice user interface to a
set of Kafka streams.


![Kafkakitty in action](https://raw.githubusercontent.com/reiseburo/kafkakitty/master/screenshot.png)




At the end of practically every week, I have invited the Core Platform team to
"find your square on the carpet for show-and-tell." The goal of show-and-tell
is to share something you have learned this week, document a failed approach,
or show something off. For a period of time, we had a _lot_ of exploratory work
with [Apache Kafka](https://kafka.apache.org). Like most pieces of backend
infrastructure, Apache Kafka does not "demo well." As one project continued
across multiple weeks, demos often times would just be two terminals: one
running our software, another running
[kafkacat](https://github.com/edenhill/kafkacat). "Two terminals"
became a running gag for the team. "Hold on a sec, let me get two terminals
running.."


Kafkakitty is a single binary like `kafkacat`, and similarly Kafkakitty can be
run on your local machine and consume from a remote Kafka cluster. Unlike
`kafkacat` however, Kafkakitty relies on your browser to provide a richer
visualization of the messages arriving in the specified topics.
Built in [Rust](https://rust-lang.org) and [Vue.js](https://vuejs.com), the
project is in its early stages but works quite well for me against
unauthenticated Kafka environments.

I'm hoping it will prove useful for more people to understand Kafka and the
events which backend systems are relaying through the system. Maybe it will
even replace the "two terminals" demo sometime soon!
