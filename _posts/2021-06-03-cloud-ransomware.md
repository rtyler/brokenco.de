---
layout: post
title: "Ransomware is coming to a cloud near you"
tags:
- opinion
- security
---

Ransomware is the most significant and dangerous evolution of computer-based
crime I have seen, and it's going to get worse. Ransomware attacks have
compromised [oil
pipelines](https://www.complianceweek.com/cyber-security/colonial-pipeline-fallout-thwarting-ransomware-attacks-requires-collective-defense/30438.article),
[hospitals](https://www.bbc.com/news/technology-35880610), and
[beef](https://arstechnica.com/gadgets/2021/06/attack-on-meat-supplier-came-from-revil-ransomwares-most-cut-throat-gang/).
While they're nothing new over the past two years, targets have become
increasingly high-profile and the adverse impacts of ransomware have similarly
become more dire. Based on my read of the reports and incident reviews, these
attacks seem to largely be affecting physical infrastructure assets:
workstations, servers sitting in closets, and small-scale data center
operations. Given this trend, it might be easy conclude that running in AWS, Azure, or Google
Cloud offers some level of protection. I strongly doubt it, and I think
ransomware is about to get **worse**.


The mythos of "cloud-native" technology is not nearly wide-spread as its
practitioners would like to admit. I posit that **most** of the workloads
running in a public cloud like AWS are fairly simplistic "Infrastructure as a
Service" (IaaS) deployments. Rather than using higher-level cloud-native
platforms, most of what makes up the "cloud" are: virtual disks, network
devices, and machines. There is **nothing** inherently safer about running a
virtual machine in AWS compared to an on-premise machine. A cloud-based virtual
machine does make it easier to take disk snapshots and restore machines, but
that's only if you _use_ those features. I would guess that most don't.

I believe the nightmare scenario that corporate IT departments are experiencing
will soon be visiting tech companies and others that have migrated into cloud
environments. The worst-case scenario that nags at me goes something like this (using AWS terminology):

* An attacker finds an "in", through a leaked set of IAM keys or other exploit.
* The attacker disables S3 object versioning, RDS snapshots, or other safe-guards that have been enabled.
* The attacker then starts walking through stored data, downloading, deleting,
  or encrypting it along the way.
* At some point it is "zero day" and the final push of deleting/encrypting of "live" data is complete and the organization is paralyzed.
  
  
As long as the attacker is able to compromise an account with a high enough access level, there is unfathomable amount of damage that could be done. Segmented accounts can provide bulkheads against the damage, but based on the "digital transformations" I have seen over the past five years the two things typically left behind when enterprises migrate to the cloud are: security and disaster recovery.

In fact, I would guess that for many cloud users if the data attackers were
compromising wasn't in a "hot" access path, the attackers could remain
undetected inside the account for long periods of time, similar to the
on-premise enterprises hit by ransomware.


Ransomware is **lucrative** and will not be going anywhere soon. The cloud doesn't inherently protect you but it _does_ provide a *lot* of mechanisms that allow for better security practices, intrusion detection, policy violations, and disaster recover. The big question I would encourage any infrastructure engineer to be asking themselves right now is: **how can I reduce the impact of an attack**.

Because like it or not, they're coming.
