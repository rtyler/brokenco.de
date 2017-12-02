---
layout: post
title: "Jenkins on Kubernetes with Azure storage"
tags:
- aks
- azure
- jenkins
- kubernetes
---

_This research was funded by [CloudBees](https://cloudbees.com/) as part of my
work in the CTO's Office with the vague guideline of "ask interesting
questions and then answer them." It does not represent any specific product
direction by CloudBees and was performed with
[Jenkins](https://jenkins.io), rather than CloudBees products, and Kubernetes
1.8.1 on Azure._


At [this point](/tag/azure.html) it is certainly no secret that I am fond of the
work the Microsoft Azure team have been doing over the past couple years. While
I was excited to announce [we had
partnered](https://jenkins.io/blog/2016/05/18/announcing-azure-partnership/) to
run Jenkins project infrastructure on Azure. Things didn't start to get _really_
interesting until they announced [Azure Container
Service](https://azure.microsoft.com/en-us/services/container-service/). A
mostly-turn-key Kubernetes service alone was pretty interesting, but then
"[AKS](https://azure.microsoft.com/en-us/blog/introducing-azure-container-service-aks-managed-kubernetes-and-azure-container-registry-geo-replication/)"
was announced, bringing a, much needed, _managed_ Kubernetes resource into the
Azure ecosystem. Long story short, thanks to Azure, I'm quite the fan of
Kubernetes now too.

Kubernetes is brilliant at a lot of things. It's easy to use, has some really
great abstractions for common orchestration patterns, and is superb for running
stateless applications. State**ful** applications also run fairly well on
Kubernetes, but the challenge usually has _much_ more to do with the
application, rather than Kubernetes. Jenkins is one of those challenging
applications.

Since Jenkins is my jam, this post covers the ins-and-outs of deploying a
Jenkins master on Kubernetes, specifically through the lens of Azure Container
Service (AKS).  This will cover the basic gist of running a Jenkins environment
on Kubernetes, evaluating the different storage options for "Persistent
Volumes" available in Azure, outlining their limitations for stateful
applications such as Jenkins, and will conclude with some recommendations.


* [Jenkins and the File System](#filesystem)
* [Kubernetes Storage](#k8s-storage)
* [Azure Disk](#azure-disk)
* [Azure File](#azure-file)
* [Conclusions](#conclusions)

<a name="filesystem"></a>

## Jenkins and the File System

To understand how Jenkins relates to storage in Kubernetes, it's useful to
first review how Jenkins utilizes its backing file system. Unlike many
contemporary web applications, Jenkins does not make use of a relational
database or any other off-host storage layer, but rather writes a number of
files to the file system of the host running the master process.

These files are not data files, or configuration files, in the traditional
sense. The Jenkins master maintains an internal tree-like object model, wherein
generally each node (object) in that tree is serialized in an XML format to the
file system. This does not mean that every single object in memory is written
to an XML file, but a non-trivial number of "live" objects representing
Credentials, Agents, Projects, and other configurations, may be periodically
written to disk at any given time.

A concrete example would be: when an administrator navigates to
`http://JENKINS_URL/manage` and changes a setting such as "Quiet Period" and
clicks "Save", the `config.xml` file (typically) in `/var/lib/jenkins` will be
rewritten.

These files aren't typically read in any periodic fashion, they're usually
only read when objects are loaded into memory during the initialization of Jenkins.

Additionally, XML files will span a number of levels in the directory
hierarchy. Each Job or Pipeline will have a directory in
`/var/lib/jenkins/jobs/<jobname>` which will have subfolders containing files
corresponding to each Run.

In short, Jenkins generates a large number of little files across a broad, and
sometimes deep, directory hierarchy. Combined with the read/write access
patterns Jenkins has, I would consider it a "worst-case scenario" for just
about any commonly used network-based storage solution.

Perhaps some future post will more thoroughly profile the file system
performance of Jenkins, but suffice it to say: it's complicated.


<a name="k8s-storage"></a>

## Kubernetes Storage

With a bit of background on Jenkins, here's a cursory overview storage in
Kubernetes. Kubernetes itself provides a consistent, cross-platform, interface
primarily via three "objects" if you will: [Persistent
Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/),
Persistent Volume Claims, and [Storage
Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/). Without
diving too deep into the details, workloads such as Jenkins will typically make
a "Persistent Volume Claim", as in "hey give me something I can mount as a
persistent file system."  Kubernetes then takes this and confers with the
configured Storage Classes to determine how to meet that need.

In Azure these claims are handled by one of two provisioners:

* [Azure Disk](#azure-disk): an abstraction on top of Azure's "data disks"
  which are attached to a Node within the cluster. These show up on the actual
  Node as if a real disk/storage device has been plugged into the machine.
* [Azure File](#azure-file): an abstraction on top of Azure Files Storage, which
  is basically CIFS/SMB-as-a-Service. CIFS mounts are attached to the Node
  within the cluster, but rapidly attachable/detachable like any other CIFS/SMB
  mount.

Both of these can be used simultaneously to provide persistence for stateful
applications in Kubernetes running on Azure, but their performance and
capabilities are not going to be interchangeable.


<a name="azure-disk"></a>

### Azure Disk

In AKS, two Storage Classes are pre-configured by default, yet neither one is
configured to [actually **be** the default Storage
Class](https://github.com/Azure/AKS/issues/48):

* `default`: utilizes the "Standard" storage (as in, hard drive, spinning
  magnetic disks) model in Azure.
* `managed-premium`: utilizes the "Premium" storage (as in, solid state
  drives).

The only real distinctions between the two which I have observed are going to be
speed and cost.

#### Limitations

Regardless of whether "Standard" or "Premium" storage is used for Azure
Disk-backed Persistent Volumes in Kubernetes (AKS or ACS) the limitations are
the same.

In my testing, the most frustrating limitation is the [fixed number of data disks which can be attached to a Virtual Machine in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-general).

As of this writing, the default Virtual Machine size used when provisioning AKS
is: `Standard_D1_v2`. One vCPU and 3.5GB of memory and a data disk limit of
**four**. Fortunately the default node count for AKS is current 3, but this
means that a default AKS cluster cannot currently support more than 12
Persistent Volumes backed by Azure Disk at once.

An easy way to change that is to provision larger Virtual Machine sizes with
AKS, but this **cannot be changed** once the cluster has been provisioned. For
my research clusters I have stuck with a minimum size of `Standard_D4_v2` which
provides up to 32 data disks per Virtual Machine, e.g.:
`az aks create -g my-resource-group -n aks-test-cluster -s Standard_D4_v2`


The Azure Disk Storage Class in Kubernetes also only supports the
`ReadWriteOnce` [access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes).
In effect a Persistent Volume can only be mounted read/write by a single Node
within the Kubernetes cluster. By understanding how Azure Disk volumes are
provisioned and attached to Virtual Machines in Azure, this makes total sense.
The impact of this means that the only allowable `replica` setting for any
given workload which might use this Persistent Volume is **1**.

This has one further limitation on scheduling and high-availability for
workloads running on the cluster. Detaching and attaching disks to these
Virtual Machines is a **slow** operation. In my experimenting this varied from
approximately 1 to 5 minutes.

For a "high availability" stateful workload, this means that a Pod dying or
being killed by a rolling update, may incur a non-trivial outage __if__
Kubernetes schedules that Pod for a different Node in the cluster. While there
is support [specifying node affinity](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/)
in Kubernetes, I have not figured out a means of encouraging Kubernetes to keep
a workload scheduled on whichever Node has mounted the Persistent Volume.
Though it would be possible to explicitly pin a Persistent Volume to a specific
Node, and then pin a Pod to that Node, a lot of workload flexibility would be
lost.


#### Benefits

It may be tempting to think at this point "Azure Disk is not good, so
everything should just use Azure File!" But there are benefits to Azure Disk
which should be considered. Azure Disk is, for lack of a better description, a
big dumb block store. In that simplicity are its strengths.

While Persistent Volumes backed by Azure Disk can be slow to detach or reattach
to a Node, once they're present, they're fast. Operations like disk scans,
small reads and writes, all _feel_ like trivially fast operations from the
Jenkins standpoint. In my testing the difference between a Jenkins master
running on local instance storage (the Virtual Machine's "main" disk) and
running a Jenkins master on a partition from a Data Disk, is imperceptible.

Another benefit which I didn't realize until I evaluated [Azure
File](#azure-file) backed Persistent Volumes is that, as a big dumb block
store, Azure Disks are essentially whatever file system format you want them to
be. In AKS they default to `ext4` which is perfectly happy and native to me,
meaning my Linux-based containers will make the correct assumptions about the
underlying file system's capabilities.


<a name="azure-file"></a>

### Azure File

AKS does not set up an Azure File Storage Class by default, but the Kubernetes
versions which are available (1.7.7, 1.8.1) have the support for Azure File
backed Persistent Volumes. In order to add the storage class, pass something
like the following to Kubernetes via `kubectl create -f azurefile.yaml`:

```yaml
---
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: azurefile
  annotations:
  labels:
    kubernetes.io/cluster-service: 'true'
provisioner: kubernetes.io/azure-file
parameters:
  storageAccount: 'mygeneralpurposestorageaccount'
reclaimPolicy: 'Retain'
# mountOptions are passed into mount.cifs as `-o` options
mountOptions:
```

According to [the Azure File documentation](https://kubernetes.io/docs/concepts/storage/storage-classes/#azure-file)
it's not necessary to specify the `storageAccount` key, but I had some
difficulty coaxing AKS to provision an Azure Storage Account on its own, so I
manually provisioned one within the "hidden" AKS Resource Group"
(`MC_<group>_<aks-name>_<location>`) and entered the name into
`azurefile.yaml`.

Full disclosure: I **hate** Storage Accounts in Azure. Where nearly everything
else in Azure rather enjoyable to use, and neatly tucked into Resource Groups,
and have reasonable naming restrictions, Storage Accounts are crummy and live
in an Azure _global namespace_ so if somebody else chooses the same name as what
you want, tough luck. The reason this is somewhat relevant to the current
discussion is that Storage Accounts _feel old_ when you use them. Everything
about them _feels_ as if it's from a by-gone era in Azure's development (ASM).

The feature used by the Azure File Storage Class is what I would describe as
"Samba/CIFS-as-a-Service."  Kubernetes is basically utilizing the
Microsoft-technology-equivalent of NFS.

But it's not NFS, it's CIFS. And that is **important** to Linuxy container
folks.


#### Limitations

The biggest limitations with Azure File backed Persistent Volumes in Kubernetes
are really limitations of
[CIFS](https://technet.microsoft.com/en-us/library/cc939973.aspx), and frankly,
they are _infuriating_. An application like Jenkins will make, what were at one
point, reasonable assumptions about the operation system and underlying
file system. "If it looks like a Linux operating system, I am going to assume
the file system supports symbolic links" comes to mind. Jenkins will attempt to
create symbolic links when a Pipeline Run or Build completes, to update a
`lastSuccessfulBuild` or `lastFailedBuild` symbolic link, which are useful for
hyperlinks in the Jenkins web interface.

Jenkins should no doubt be more granular and thoughtful about file system
capabilities, but I'm willing to bet that a number of other applications which
you might consider deploying on Kubernetes are also making assumptions along
the lines of "it's a Linux, so it's probably a Linuxey file system" which Azure
File backed Persistent Volumes invalidate.

Volumes which are attached to the Node, are attached [with very strict
permissions](https://github.com/kubernetes/kubernetes/issues/2630#issuecomment-344091454).
On a Linux file system level, an Azure File backed volume attached at `/mnt/az`
would be attached with `0700` permissions allowing _only_ root access. There
are two options for working around this, as far as I am aware of:

1. Adding a `uid=1000` to the `mountOptions` specified for the Storage Class in
   the `azurefile.yaml` referenced above. Unfortunately this would require that
   every container attempting to utilize Azure File backed volumes use the same
   uid.
1. Specifying a
   [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
   for the container with: `runAsUser: 0`. This makes me feel exceptionally
   uncomfortable, and I would absolutely not recommend running any untrusted
   workloads on a Kubernetes cluster with this setting.


The final, and for me the most important, limitation for Azure File backed
storage is the performance. Presently there is [no Premium model offered for
Azure Files Storage](https://feedback.azure.com/forums/217298-storage/suggestions/8374074-offer-premium-storage-option-for-azure-file-servic),
which I would presume means that Azure File volumes are backed by spinning hard
drives, rather than solid state.

The performance bottleneck for Jenkins is _not_ theoretical however. With a
totally fresh Persistent Volume Claim for a Jenkins application, the
initialization of the application took upwards of **5-15 minutes**, namely:

* 2-3 _seconds_ to create the Persistent Volume and bind it to a Node in the
  Kubernetes cluster.
* 3-4 minutes to "extract [Jenkins] from war file". When `jenkins.war` runs the
  first time, it unpacks the `.war` file into `JENKINS_HOME` (usually
`/var/lib/jenkins`) and populates `/var/lib/jenkins/war` with a number of small
 static files. Basically, unzipping a 100MB archive which contains hundreds of
 files.
* 5-10 minutes from "Starting Initialization" to "Jenkins is ready." In my
  observation this tends to be highly variable depending on the size of Jenkins
  environment, how many plugins are loaded, and what kind of configuration XML
  files must be loaded at initialization time.


The closest comparison to Azure File backed storage and the performance
challenges I have observed with it, are similar to challenges the CloudBees
Engineering team observed with [Amazon EFS](https://aws.amazon.com/efs/) when
it was first announced. The disk read/write patterns exhibited by Jenkins
caused trouble on EFS as well, but that has seen marked improvement over the
last 6 months, whereas Azure Files Storage doesn't appear to have had
significant performance improvements in a number of years.


#### Benefits

Despite performance challenges, Azure File backed Persistent Volumes are not
without their benefits. The most notable benefit, which is what originally
attracted me to the Azure File Storage Class, is the support for the
`ReadWriteMany` access mode.

For some workloads, of which Jenkins is not one of them, this would enable a
`replicas` setting greater than 1 and concurrent Persistent Volume access
between the running containers. Even for single container workloads, this is a
valuable setting as it allows for effectively zero-downtime rolling updates and
re-deployments when a new Pod is scheduled on a different underlying Node.

Additionally, Azure File volumes can be simultaneously mounted by other machines in the
resource group, or even across the internet, which can be very useful for
debugging or forensics when something goes wrong (things usually go wrong).
Compared to an Azure Disk volume which would require a [container to be successfully
running](https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/) in the Kubernetes environment before you could dig into the disk.


<a name="conclusions"></a>

## Conclusions

Running a highly available Jenkins environment is a non-trivial exercise. One
which requires a substantial understanding of both the nuances of how Jenkins
interacts with the file system but also how users expect to interact with the
system. While I was optimistic at the outset of this work that Kubernetes, or
more specifically AKS, might significantly change the equation; it has not.

To the best of my understanding, this work applies evenly to Azure Container
Service (ACS) and Azure Container Service (AKS) (naming is hard), since both
are using the same fundamental Kubernetes support for Azure via the Azure Disk
and Azure File Storage Classes. Unfortunately I don't have time to do a serious
performance analysis of Data Disks using Standard storage, Data Disks using
Premium Storage, and Azure File mounts. I would love to see work in that area
published by the Microsoft team though!


At this point in time, those seeking to provision Jenkins on ACS or AKS, I
strongly recommend using the Azure Disk Storage Class with Premium storage.
That will not help with "high availability" of Jenkins, but at least once
Jenkins is running, it will be running swiftly. I also recommend using [Jenkins
Pipeline](https://jenkins.io/doc/book/pipeline) for all Jenkins-based
workloads, not just because I fundamentally think it's a better tool than
classic Freestyle Jobs, but it has built-in **durability**.  Using Jenkins in
tandem with the [Azure VM Agents](https://plugins.jenkins.io/azure-vm-agents)
plugin, workloads are kicked out to dynamically provisioned Virtual Machines,
and when the master goes down, from which recovery can take 5-ish minutes in
the worst case scenario, the outstanding Pipeline-based workloads will not be
interrupted during that window.


I still find myself excited about the potential of AKS, which is currently in
"public preview." My recommendation to Microsoft would be to spend a
significant amount of time investing in both storage and cluster performance to
strongly differentiate AKS from Kubernetes provided on other clouds.
Personally, I would love to have: faster stateful applications, auto-scaled
Nodes based on compute (or even Data Disk limits!), and cross-location
[Federation](https://kubernetes.io/docs/concepts/cluster-administration/federation/)
for AKS.


Maybe in 2018!



---

### Configuration

Below is the configuration for the Service, Namespace, Ingress, and Stateful
Set I used:

```yaml
---
apiVersion: v1
kind: "List"
items:
  - apiVersion: v1
    kind: Namespace
    metadata:
      name: "jenkins-codevalet"

  - apiVersion: v1
    kind: Service
    metadata:
      name: 'jenkins-codevalet'
      namespace: 'jenkins-codevalet'
    spec:
      ports:
        - name: 'http'
          port: 80
          targetPort: 8080
          protocol: TCP
        - name: 'jnlp'
          port: 50000
          targetPort: 50000
          protocol: TCP
      selector:
        app: 'jenkins-codevalet'

  - apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      name: 'http-ingress'
      namespace: 'jenkins-codevalet'
      annotations:
        kubernetes.io/tls-acme: "true"
        kubernetes.io/ingress.class: "nginx"
    spec:
      tls:
      - hosts:
        - codevalet.io
        secretName: ingress-tls
      rules:
      - host: codevalet.io
        http:
          paths:
          - path: '/u/codevalet'
            backend:
              serviceName: 'jenkins-codevalet'
              servicePort: 80

  - apiVersion: apps/v1beta1
    kind: StatefulSet
    metadata:
      name: "jenkins-codevalet"
      namespace: "jenkins-codevalet"
      labels:
        name: "jenkins-codevalet"
    spec:
      serviceName: 'jenkins-codevalet'
      replicas: 1
      selector:
        matchLabels:
          app: 'jenkins-codevalet'
      volumeClaimTemplates:
        - metadata:
            name: "jenkins-codevalet"
            namespace: "jenkins-codevalet"
          spec:
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 5Gi
      template:
        metadata:
          labels:
            app: "jenkins-codevalet"
          annotations:
        spec:
          securityContext:
            fsGroup: 1000
            # https://github.com/kubernetes/kubernetes/issues/2630#issuecomment-344091454
            runAsUser: 0
          containers:
            - name: "jenkins-codevalet"
              image: "rtyler/codevalet-master:latest"
              imagePullPolicy: Always
              ports:
                - containerPort: 8080
                  name: http
                - containerPort: 50000
                  name: jnlp
              resources:
                requests:
                  memory: 384M
                limits:
                  memory: 1G
              volumeMounts:
                - name: "jenkins-codevalet"
                  mountPath: "/var/jenkins_home"
              env:
                - name: CPU_REQUEST
                  valueFrom:
                    resourceFieldRef:
                      resource: requests.cpu
                - name: CPU_LIMIT
                  valueFrom:
                    resourceFieldRef:
                      resource: limits.cpu
                - name: MEM_REQUEST
                  valueFrom:
                    resourceFieldRef:
                      resource: requests.memory
                      divisor: "1Mi"
                - name: MEM_LIMIT
                  valueFrom:
                    resourceFieldRef:
                      resource: limits.memory
                      divisor: "1Mi"
                - name: JAVA_OPTS
                  value: "-Dhudson.DNSMultiCast.disabled=true -Djenkins.CLI.disabled=true -Djenkins.install.runSetupWizard=false -Xmx$(MEM_REQUEST)m -Dhudson.slaves.NodeProvisioner.MARGIN=50 -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85"
```

