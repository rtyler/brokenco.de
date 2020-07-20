---
layout: post
title: Building a real-time data platform with Apache Spark and Delta Lake
tags:
- spark
- deltalake
- databricks
- scribd
---

The [Real-time Data Platform](/2019/08/28/real-time-data-platform.html) is one
of the fun things we have been building at Scribd since I joined in 2019. Last
month I was fortunate enough to share some of our approach in a presentation at
Spark and AI Summit titled: "The revolution will be streamed." At a high level,
what I had branded the "Real-time Data Platform" is really: [Apache
Kafka](https://kafka.apache.org), [Apache Airflow](https://airflow.apache.org),
[Structured streaming with Apache Spark](https://spark.apache.org), and a
smattering of microservices to help shuffle data around. All sitting on top of
[Delta Lake](https://delta.io) which acts as an incredibly versatile and useful
storage layer for the platform.

In my presentation, which is embedded below, I outline how we tie together Kafka, Databricks, and Delta Lake.

<center>
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/YmyCOr9Mr9Y" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</center>

The recorded presentation also complements some of our
[tech.scribd.com](https://tech.scribd.com) blog posts which I recommend reading as well:

* [Streaming data in and out of Delta Lake](https://tech.scribd.com/blog/2020/streaming-with-delta-lake.html)
* [Streaming development work with Kafka](https://tech.scribd.com/blog/2020/introducing-kafka-player.html)
* [Ingesting production logs with Rust](https://tech.scribd.com/blog/2020/shipping-rust-to-production.html)
* [Migrating Kafka to the cloud](https://tech.scribd.com/blog/2019/migrating-kafka-to-aws.html)


I am incredibly proud of the work the Platform Engineering organization has
done at Scribd to make real-time data a reality. I also cannot recommend Kafka +
Spark + Delta Lake highly enough for those with similar requirements.

Now that we have the platform in place, I am also excited for our late 2020 and
2021 roadmaps which will start to take advantage of real-time data.
