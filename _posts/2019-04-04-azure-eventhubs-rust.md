---
layout: post
title: "Publishing to Azure Event Hubs from Rust"
tags:
- rust
- kafka
- azure
---

Turn back now, this blog post is so niche that it's statistically impossible
for you to find this useful. Last night I was thinking about building a little
app which needed to deal with an event stream, and started poking around the
Azure Event Hubs documentation. I noticed that they _apparently_ can now [speak
Kafka](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-quickstart-kafka-enabled-event-hubs)
which means I can use my existing Kafka library tooling, nice! Since I was
already working with Kafka and Rust for another little project, I took a quick
detour and tried to see if I could publish to an Event Hub over Kafka, from
Rust. As luck would have it, I can!

The one quirk with Azure Event Hubs compared to how most people use Kafka was
the SASL/TLS authentication and encryption, was a bit tricky to use with the
[rdkafka](https://crates.io/crates/rdkafka) crate, which built on top of the
fantastic [librdkafka](https://github.com/edenhill/librdkafka). SASL/TLS is
seems to have become the defacto standard for running Kafka-as-a-Service like
AWS MSK or Confluent Cloud, so it is wonderful to figure out how to use the
rdkafka crate in this environment.

The relevant code from [my
gist](https://gist.github.com/rtyler/3d5b0ed5858f4ae1c2694d1b1b711a31) which
demonstrates this functionality is the `ClientConfig` for the producer:

```rust
/*
 * NOTE: `connection` is the full connection string for the Event Hub
 */
let producer: FutureProducer = ClientConfig::new()
    .set("bootstrap.servers", &brokers)
    .set("produce.offset.report", "true")
    .set("message.timeout.ms", "5000")
    .set("security.protocol", "sasl_ssl")
    /*
        * The following setting -must- be set for librdkafka, but doesn't seem to do anything
        * worthwhile,. Since we're not relying on kerberos, let's just give it some junk :)
        */
    .set("sasl.kerberos.kinit.cmd", "echo 'who wants kerberos?!'")
    /*
        * Another unused setting which is required to be present
        */
    .set("sasl.kerberos.keytab", "keytab")
    .set("sasl.mechanisms", "PLAIN")
    /*
        * The username that Azure Event Hubs uses for Kafka is really this
        */
    .set("sasl.username", "$ConnectionString")
    /*
        * NOTE: Depending on your system, you may need to change this to adifferent location
        */
    .set("ssl.ca.location", "/etc/ssl/ca-bundle.pem")
    .set("sasl.password", &connection)
    .create()
.expect("Producer creation error"); 
```

With those settings in place, any of the existing Rust rdkafka exampels should
work just fine, though I haven't tested the consumer API just yet.


I should also note that the Azure Event Hubs "Standard" tier supports enabling
the Kafka protocol, but their "Basic" tier does not, which is too bad. The
"Basic" tier is cheaply priced enough to make it reasonable for a
hobby-project's event stream.

---

I'm looking forward to playing a bit more with Rust and Kafka in the future for
a myriad of reasons. The most compelling of which are "serverless"
environments, such as that provided by the [AWS Lambda Rust
runtime](https://github.com/awslabs/aws-lambda-rust-runtime). The pricing of
AWS Lambda encourages fast (pricing per 100ms) and small (pricing per MB of
memory) makes it an ideal candidate for Rust.


Whether you're considering Azure Event Hubs, or any other SASL/TLS-based Kafka
interface, now you know how to use it from Rust!

