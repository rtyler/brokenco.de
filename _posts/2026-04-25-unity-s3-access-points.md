---
layout: post
title: "Unity Catalog with S3 Access Points"
tags:
- databricks
- deltalake
---

Governance is the synergy of our era. If I could go one week without a
discussion around governance that really just boils down to classic role-based
access control practices..

The bad news I have for you is that today, in the year 2026 **Unity Catalog
does not work with S3 Access Points.**

_However_ it does show a different pathology than it once did, which leads me
to believe that it _could_, if not for one silly little piece of technical
debt.

---

The system I am building utilizes [Amazon S3 Access
Points](https://aws.amazon.com/s3/features/access-points/) for _governance_ but
must integrate into the {Databricks](https://databricks.com) platform. A
platform which has its _own_ ideas about governance: [Unity
Catalog](https://docs.databricks.com/aws/en/data-governance/unity-catalog/). It
should come as no surprise that a system which was named _unity_ would go to
great strides to make itself the center of the universe. 

How troublesome!

Years ago a colleague and I tried to integrate Databricks Unity Catalog and S3
Access Points only for the approach to crash and burn. Integrating two
different opaque tools like IAM permissions and Unity Catalog led to all sorts
of attempted incantations, none of which actually succeeded.

The Databricks product team told us that the system did not support S3 Access
Points "by design." I found the reasoning _very_ patronizing because it was
presented as "we don't support S3 Access Points by design to prevent users from
circumventing Unity access controls."

What I understand now is how that "by design" was more of an excuse  "we just
don't want to test it" rather than something more substantive.


S3 Access Points can be [referenced a number of
ways](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points-naming.html)
like S3 Access Point Aliases to where even the most legacy system can integrate
with them. 

>  An access point alias name meets all the requirements of a valid Amazon S3
>  bucket name and consists of the following parts:

The first time we bounced off this problem [S3 Access Point
Aliases](https://aws.amazon.com/about-aws/whats-new/2021/07/amazon-s3-access-points-aliases-allow-application-requires-s3-bucket-name-easily-use-access-point/)
had been only recently released;

Despite all Unity Catalog's protestations the errors we ended up seeing don't
convey a structural limitation when using S3 Access Point Aliases, instead they
point to simply out-dated SDK support in the underlying Databricks Runtime.


My hunch is that the AWS SDK v1 being [announced as deprecated over two years
ago](https://aws.amazon.com/blogs/developer/announcing-end-of-support-for-aws-sdk-for-java-v1-x-on-december-31-2025/)
and being *completely* deprecated as of the end of 2025. Lots of Databricks and
other Spark [libraries still interact with S3 via the v1
SDK](https://hadoop.apache.org/docs/current3/hadoop-aws/tools/hadoop-aws/aws_sdk_upgrade.html). 
That SDK was originally released in 2010 (lol) and so it's likely that the
issue we were authentication issue we were seeing was mixed up in the support
for S3 Access Point Aliases with this old SDK.

Since we bounced off this problem a number of years ago one thing that has
changed for the better in Unity Catalog is that it is now possible to grant
Unity a completely read-only configuration in IAM-based S3 bucket policies.
While we cannot use S3 Access Points as part of our governance strategy, we can
at least still grant a fairly limited permission to Unity for read-only
operations.

Now I can have my esoteric [Delta Lake](https://delta.io) datastores present in
Unity without any risk of misconfiguration or error in Unity leading to data
corruption!


**Governance** to a lot of enterprise vendors is about _centralization of
control_, but for me it's about [defense in
depth](https://en.wikipedia.org/wiki/Defence_in_depth).
I never want a business-critical system to be a single
misconfiguration away from granting read or write access to the wrong
principal.


