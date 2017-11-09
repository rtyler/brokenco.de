---
layout: post
title: "Azure OpenDev Wrap-up"
tags:
- jenkins
- azure
- opendev
- presentation
- video
---

A couple weeks ago I boarded a plane at the always-adorable
[Charles M. Schulz Sonoma County Airport](https://sonomacountyairport.org/)
en route to Seattle to participate in a [Microsoft Azure OpenDev Event](/2017/10/05/azure-opendev.html).
Thanks to my pal Ken Thompson, who recently joined Microsoft as a product
marketing manager for their Open Source DevOps team, I was invited to talk
about all things Jenkins with a dash of Azure.


It's been no secret that I have [become a fan of Azure](https://twitter.com/agentdero/status/898957691510374401) lately.
Microsoft's investment in open source technologies as a means of driving
innovation for their cloud platform is _very_ exciting for me. While they
[don't get everything right](https://twitter.com/agentdero/status/904808509065142272),
I have seen tremendous month-to-month, and year-to-year, improvements from the
Azure team since I first started using Azure a few years ago.


Setting aside the Azure lovefest and getting back to the matter at hand
however: the Azure OpenDev event. Ken and his team decided to try something
different for this event and invited a number of folks from different
organizations like
[Ryan from GitHub](https://www.youtube.com/watch?v=D3C12ojRcp0&list=PLLasX02E8BPBmGz-fYt_TTqAxluLdcXEg&index=3),
[Matt from Chef](https://www.youtube.com/watch?v=sNLAECL6wx8&list=PLLasX02E8BPBmGz-fYt_TTqAxluLdcXEg&index=5),
[Nic from HashiCorp](https://www.youtube.com/watch?v=koYCkjYSkQ0&list=PLLasX02E8BPBmGz-fYt_TTqAxluLdcXEg&index=6),
and
[Christoph from Elastic](https://www.youtube.com/watch?v=tOqWX9JWEYc&list=PLLasX02E8BPBmGz-fYt_TTqAxluLdcXEg&index=7).
This line-up not only made for a really informative block of video content, but
it also made the whole experience quite fun too. From the pre-event speakers
dinner, to the [panel
discussion](https://twitter.com/bitwiseman/status/923374447897092096) we had at
the "after-party"/Seattle Jenkins Area Meetup, it was two days of what felt
like non-stop talking and excitement.

![Toon version](/images/post-images/azure-opendev/toon.jpg)


## Things I said

During my discussion with [Ashley](https://twitter.com/ashleymcnamara) I talked
about (at length!) [Jenkins Pipeline](https://jenkins.io/doc/book/pipeline)
which, regardless of who my employer presently is, has definitely moved the
needle for Jenkins automation forward in a spectacular way. In addition to
Pipeline, we also discussed and walked through some real-live Jenkins instances
running [Blue Ocean](https://jenkins.io/projects/blueocean).

We also discussed, briefly, some of the [Jenkins project's own infrastructure code](https://github.com/jenkins-infra/).
Composed of Puppet, Terraform, Jenkins Pipeline, and a schmear of bash
script.


The video below is a bit of a whirlwind tour, dabbling in Jenkins, the
project's infrastructure, and some Azure tools available for Jenkins.


<center>
<strong>Behold! The least flattering still-shot possible</strong>
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/jOWY6wa38J0" frameborder="0" allowfullscreen></iframe>
</center>


## Things I didn't have time to say

Unfortunately 30 minutes goes by really fast and I couldn't cover absolutely
everything I wanted to talk about. I did warn Ashley beforehand however, that I
can probably talk about Jenkins things for hours on end.

I wanted to talk more about how the Jenkins project now uses
[Kubernetes](https://kubernetes.io) quite heavily, on Azure, to power our
"application tier." Contrasted with our infrastructure tier of virtual
machines, storage accounts, databases, or load balancers, I wanted to explain
that the "application tier" fits perfectly in the Kubernetes world, and enables
different web applications, bots, and services to be rapidly developed and
continuously delivered.

I also wanted to talk about how we use Puppet to [manage our
Kubernetes](https://github.com/jenkins-infra/jenkins-infra/tree/staging/dist/profile/manifests/kubernetes)
resources after we tried a number of different approaches for managing our
Kubernetes-based infrastructure. Having realized that Puppet has all the basics
which we needed, but found ourselves reinventing: multiple environments,
secrets management, state management.

I didn't quite get a chance to talk about some of the Jenkins project's own
Jenkins Pipelines, like [this
Jenkinsfile](https://github.com/jenkins-infra/jenkins.io/blob/master/Jenkinsfile)
which is what actually builds the [jenkins.io](https://jenkins.io) static site
and uploads assets to Azure Storage. Or [this
Jenkinsfile](https://github.com/jenkins-infra/jenkins-infra/blob/staging/Jenkinsfile)
which tests, lints, and ensures our Puppet code is correct. Fortunately, I did
talk a _little_ bit about [this Jenkinsfile](https://github.com/jenkins-infra/azure/blob/master/Jenkinsfile)
which manages our Terraform build, test, and deploy pipeline.

I alluded too the [Jenkins project's own Jenkins environment](https://ci.jenkins.io)
but there's an entire presentation's worth of content in how I have architected
that Jenkins environment.


I could literally talk for hours about Jenkins and Jenkins-related topics.

**Hours**.

I'm not certain if that's a good or a bad thing however; probably best not to
think too much about it.

---

Overall between the speaker dinner, the OpenDev event, the after-party/JAM, and
the after-after party, the entire experience was challenging, informative, and
enjoyable. I do hope the team at Microsoft continues to host these types of
"rougher" open source friendly events in the future

Whether they realize it or not, Microsoft is in a great position to encourage
and facilitate some really interesting cross-project collaboration with more
events like this, so fingers crossed that they will step up to the plate.

![Standing Tall](/images/post-images/azure-opendev/standing-tall.jpg)

