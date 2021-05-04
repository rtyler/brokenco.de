---
layout: post
title: Recovering from disasters with Delta Lake
tags:
- deltalake
- scribd
---

Entering into the data platform space with a lot of experience in more
traditional production operations is a _lot_ of fun, especially when you ask
questions like "what if `X` goes horribly wrong?"  My favorite scenario to
consider is: "how much damage could one accidentally cause with our existing
policies and controls?"  At [Scribd](https://tech.scribd.com) we have made
[Delta Lake](https://delta.io) a cornerstone of our data platform, and as such
I've spent a lot of time thinking about what could go wrong and how we would
defend against it.  


To start I recommend reading this recent post from Databricks: [Attack of the
Delta
Clones](https://databricks.com/blog/2021/04/20/attack-of-the-delta-clones-against-disaster-recovery-availability-complexity.html)
which provides a good overview of the `CLONE` operation in Delta and some
patterns for "undoing" mistaken operations. Their blog post does a fantastic
job demonstrating the power ot clones in Delta Lake, for example:


```sql
-- Creating a new cloned table  from loan_details_delta
CREATE OR REPLACE TABLE loan_details_delta_clone
    DEEP CLONE loan_details_delta;

-- Original view of data
SELECT addr_state, funded_amnt FROM loan_details_delta GROUP BY addr_state, funded_amnt

-- Clone view of data
SELECT addr_state, funded_amnt FROM loan_details_delta_clone GROUP BY addr_state, funded_amnt
```


For my disaster recovery needs, the clone-based approach is insufficient as I detailed in [this post](https://groups.google.com/g/delta-users/c/2WOymkv4KgI/m/zvqKkQwJDwAJ) on the delta-users mailing list:


> Our requirements are basically to prevent catastrophic loss of business critical data via:
> 
> * Erroneous rewriting of data by an automated job
> * Inadvertent table drops through metastore automation.
> * Overaggressive use of VACUUM command
> * Failed manual sync/cleanup operations by Data Engineering staff
> 
> It's important to consider whether you're worried about the transaction log
> getting corrupted, files in storage (e.g. ADLS) disappearing, or both.


Generally speaking, I'm less concerned about malicious actors so much as
_incompetent_ ones. It is **far** more likely that a member of the team
accidentally deletes data, than somebody kicking in a few layers of cloud-based
security and deleting it for us.

My preference is to work at a layer _below_ Delta Lake to provide disaster
recovery mechanisms, in essence at the object store layer (S3). Relying strictly
on `CLONE` gets you copies of data which can definitely be beneficial _but_ the
downside is that whatever is running the query has access to both the "source"
and the "backup" data.

The concern is that if some mistake was able to delete my source data, there's
nothing actually standing in its way of deleting the backup data as well.


In my mailing list post, I posited a potential solution:

> For example, with a simple nightly rclone(.org) based snapshot of an S3 bucket, the
> "restore" might mean copying the transction log and new parquet files _back_ to
> the originating S3 bucket and *losing* up to 24 hours of data, since the
> transaction logs would basically be rewound to the last backup point.


Since that email we have deployed our Delta Lake backup solution,
which operates strictly at an S3 layer and allows us to impose hard walls (IAM)
between writers of the source and backup data.

One of my colleagues is writing that blog post up for
[tech.scribd.com](https://tech.scribd.com) and I hope to see it published later
this week so make sure you follow us on Twitter
[@ScribdTech](https://twitter.com/scribdtech) or subscribe to the [RSS
feed](https://tech.scribd.com/feed.xml)!



