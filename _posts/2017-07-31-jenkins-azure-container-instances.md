---
layout: post
title: "Jenkins in seconds with Azure Container Instances"
tags:
- azure
- opensource
- jenkins
---


Recently Microsoft announced an interesting new addition to their public cloud
offering: [Azure Container Instances](https://azure.microsoft.com/en-us/blog/announcing-azure-container-instances/).
Azure Container Instances are fast and billed by the second, which is quite
compelling on its own. They are interesting in that they provide two novel
levels of container orchestration, the first is rather basic:"take this
container and run it." The second is an integration with Kubernetes which
allows the Kubernetes cluster, most likely one an Azure Container Service, to
schedule container workloads through Azure Container Instances rather than on
the existing Kubernetes agents )VMs) via the "ACI connector." As this service
matures, this could enable some very novel load-based bursting, or cost-saving,
deployment patterns on top of Kubernetes in Azure.

![Jenkins on Azure Container Instances](/images/post-images/jenkins-aci/jenkins-home.png)_

The Jenkins project has been publishing official releases [as Docker
containers](https://hub.docker.com/r/jenkins/jenkins) for some time, so last
Friday I decided it would be interesting to experiment with launching Jenkins
as an Azure Container Instance. I'll first launch Jenkins "the easy way," then
review some of the challenges and more advanced approaches.

### The Easy Way

1. Create a Resource Group into which the Azure Container Instance will be deployed:
   `az group create --name jenkins --location eastus`
1. Deploy the container:
   `az container create --image jenkins/jenkins:lts-alpine --name jenkins --resource-group jenkins --ip-address public --port 8080`

In a matter of seconds Jenkins will be up and running. In fact, it seems that
it takes longer for the JVM to boot than it does for Azure to provision the
container instance, which is pretty slick.

I can inspect my containers with: `az container list`

    ➜  ~  az container list
    Name     ResourceGroup    ProvisioningState    Image                       IP:ports             CPU/Memory       OsType    Location
    -------  ---------------  -------------------  --------------------------  -------------------  ---------------  --------  ----------
    jenkins  jenkins          Creating             jenkins/jenkins:lts-alpine  52.179.126.248:8080  1.0 core/1.5 gb  Linux     eastus
    ➜  ~


When I navigate to the IP address listed, I'm presented with the familiar
[Jenkins Post-install Setup
Wizard](https://jenkins.io/doc/book/getting-started/installing/#setupwizard),
which prompts me for the administrator token to configure the instance. Again
using the Azure command line, I can fetch the recent log output with: `az
container logs --name jenkins --resource-group jenkins`, which dumps something
like this to my console:


    Jul 31, 2017 5:48:33 PM jenkins.install.SetupWizard init
    INFO:

    *************************************************************
    *************************************************************
    *************************************************************

    Jenkins initial setup is required. An admin user has been created and a password generated.
    Please use the following password to proceed to installation:

    e06025745e4d4c559e9ead0819d0dd1a

    This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

    *************************************************************
    *************************************************************
    *************************************************************

    Jul 31, 2017 5:48:34 PM hudson.model.UpdateSite updateData
    INFO: Obtained the latest update center data file for UpdateSource default


With this generated password I can complete the set up of Jenkins and get
started! **Hurrah!**

### Caveats and Outstanding Questions

Of course, this is really helpful for testing with Jenkins but the example above
is **stateless**. When I delete the instance (`az container delete --name
jenkins --resource-group jenkins`) all my configured
[Pipelines](https://jenkins.io/doc/book/pipeline) and settings are lost. Azure
Container Instances [do support stateful
containers](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-mounting-azure-files-volume)
but it's a bit more tedious to set up than I wanted to cover in this blog post.


Another interesting behavior I noticed while working with my Jenkins Azure
Container Instances was "No valid crumb issued" errors when saving
configuration. These errors
typically indicate an aggressive reverse proxy between the end-user and
Jenkins. This can be easily remedied with the "Enable proxy compatibility"
setting in the "Configure Global Security" page in Jenkins:

![Crumb compatibility](/images/post-images/jenkins-aci/crumb-proxy.png)


Finally, it's not clear how to properly utilize the public IP address assigned
to the Azure Container Instance. Whether it's something that could be linked
with Azure DNS, or put behind an Azure Load Balancer.

Azure Container Instances are **very** new to the Azure ecosystem, and as such
I wouldn't recommend using them for production-level workloads just yet, but
they do look like a very handy tool for development, testing, and demonstration
of container-based applications. In the case of Jenkins, if you start
[automating Jenkins with Groovy](/2017/07/24/groovy-automation-for-jenkins.html) you could readily
create your own custom Jenkins container which, out of the box, has everything
configured for testing in seconds via an Azure Container Instance.


You can learn more about Azure Container Instances
[here](https://docs.microsoft.com/en-us/azure/container-instances/), which
support Linux containers first; Windows support is on the way. The adoption of
open source tools and technology by Microsoft in Azure is rapidly becoming a
competitive advantage compared to Amazon Web Services which, as a consumer and
open source advocate, is very exciting to watch. If you haven't taken a look at
Azure recently, I recommend it!
