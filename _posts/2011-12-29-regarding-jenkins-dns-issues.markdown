---
layout: post
title: And now a word about the Jenkins DNS debacle
tags:
- puppet
- jenkins
- opinion
---

Now that things have settled down, I'd like to address what happened during the
[jenkins-ci.org DNS outage I discussed
here](https://groups.google.com/group/jenkinsci-users/browse_thread/thread/b1015d6efd53343f#).

Long story short, some poor assumptions caused a lot of trouble while switching
registrars away from GoDaddy.


----

First let me explain the motivations for moving from GoDaddy: aside from the
SOPA issue, I've *always* hated dealing with GoDaddy. The have had an
absolutely **shit** product for a long time, but as a long time customer,
momentum was quite a limiting factor. Before my involvement with the Jenkins
infrastructure, I would have only used GoDaddy once or twice a year.

Since becoming the driving force behind a lot of the Jenkins back-end, I've had
to deal with them once or twice a month, and everytime I would be bombarded
with upsells, ads and other shit that I wanted no part in. With the renewal of
jenkins-ci.org coming up in January, it makes sense to switch registrars before
I renew the domain for 5 years (which I will be doing).

The SOPA boycott is just gravy on top.

----

As for the "DNS debacle", here's a quick bulleted list of what happened:

#### The Negative

* Jenkins used GoDaddy's DNS service, when the GoDaddy side of the domain
  transfer was complete they canceled the DNS service and seemingly zeroed
  out all our DNS records.
* The `jenkins-ci.org` nameservers, which are generally copied over when
  switching registrars, were set to GoDaddy's nameservers prior to the transfer
  (mistake on my part).
* What I had assumed would automatically take effect once the transfer was
  complete on Namecheap's side, did not take effect. In fact, somehow the data
  I had entered in was obliterated when GoDaddy's nameservers were copied over.
* I'm not good at writing zone files, and the most subtle mistakes were easy to
  slip past those who I asked to review them. Zone files are the devil.

Instead of focusing too much on the colossal screw-up, I'd like to focus more
on what positive has come out of the situation.


#### The Positive

* `jenkins-ci.org` is now with a registrar that isn't commonly accepted to be
  "freakin' terrible"
* To mitigate the downtime people were experiencing, I quickly set up what I
  presumed would be a temporary nameserver on one of our machines colocated
  with the [OSUOSL](http://www.osuosl.org).
* Instead of taking that nameserver down, I've actually promoted it to become
  `ns1.jenkins-ci.org` which is wholly powered by [our Puppet
   manifests](https://github.com/jenkinsci/infra-puppet/). Now anybody in the
   community can submit a pull request to add records to [our zone
   file](https://github.com/jenkinsci/infra-puppet/blob/master/modules/jenkins-dns/files/jenkins-ci.org.zone) and we can
   approve and deploy it all from GitHub via Puppet.
* While working on DNS, I noticed that `iptables(8)` wasn't properly configured
  on some of our hosts. We've since bundled the [firewall module from Puppet
  Labs](http://forge.puppetlabs.com/puppetlabs/firewall) in our repository and
  set up the appropriate rules on all hosts to lock them down.


I could vent about the idiocy of the DNS system, how much I abhor GoDaddy, or a
myriad of other issues that had to be resolved in these past two days, but that
wouldn't be very useful.

Despite the amount of time consumed in the affair, I think the project comes
out ahead and stronger, and at the end of the day that's what is really
important to me.
