---
layout: post
title: "Implementing Virtual Hosts across Namespaces in Kubernetes"
tags:
- kubernetes
---

After learning how to build my first terrible website, in ye olden days,
perhaps the second useful thing I ever really learned was to run multiple websites on
a single server using
[Apache VirtualHosts](https://httpd.apache.org/docs/current/vhosts/index.html).
The novelty of being able to run more than one application on a server was
among the earliest things I recall being excited about. Fast forward to
the very different deployment environments we have available today, and I find
myself excited about about the same basic kinds of things. Today I thought I
would share how one can implement a concept similar to Apache's VirtualHosts
across Namespaces in Kubernetes.


*Note:* I won't cover too much about networking in Kubernetes in this blog post, but I
recommand Julia Evans' post titled [Operating a Kubernetes Network](https://jvns.ca/blog/2017/10/10/operating-a-kubernetes-network/),
which is a good, alebit advanced, overview of some of the things going on in
Kubernetes behind the scenes to make networking in Kubernetes "work."


The basic gist of what I was trying to accomplish was as follows: deploy
multiple application stacks, each separated into a Kubernetes
[Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
unto itself, and mount those all under the same public IP. Exposing
applications to "the outside world" is relatively simple, numerous blog posts,
documentation, and Stack Overflow snippets demonstrate this. Segregating
workloads into Namespaces seems to be less popular however.

The most important component for making applications "serve things" from a
Kubernetes cluster is the [Ingress
Resource](https://kubernetes.io/docs/concepts/services-networking/ingress/).

Well, that's not entirely true.

The most important component for making applications "serve things" from a
Kubernetes cluster is the [Ingress
Controller](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-controllers).

Two things coarsely referred to as "Ingresses" in examples and blog posts,
which typically never discussed Namespaces, made searching and understanding
the bits of information I needed to understand, rather tricky. As [@evnsio
highlights](https://twitter.com/evnsio/status/928284557060780032): "Explaining
Kubernetes ingress controllers is hard".

Deep within a GitHub issue, which has been lost to the sands of time in my
browser history, a passing comment revealed what I had been misunderstanding:
**a Kubernetes cluster will have one Ingress Controller, but can have many
Ingress Resources.**

Instead of trying to deploy an Ingress Controller to each namespace along with
my application, this informed me that I only needed to deploy one controller,
and then add an Ingress Resource for each "VirtualHost" in my environment. I
was also confused by the [Name-based virtual hosting
documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/#name-based-virtual-hosting)
which uses a single `.yaml` configuration to describe multiple hosts. I found
myself exploring how to dynamically generate a mega-yaml-configuration
including all my "virtual hosts" across Namespaces.

As luck would have it, this is **completely unnecessary**! The nginx Ingress
Controller pays attention to the entire Kubernetes object space, not just its
own Namespace, for Ingress Resources. In effect this means that any Ingress
Resource, in **any** Namespace, is going to be picked up and for which nginx rules
will be generated.


**Eureka!**


With this knowledge in hand, not only could I separate name-based virtual hosts
into their own Namespaces, with little bits of Ingress Resource configuration
as shown below. I could _also_ use the same host name and different
_paths_ across Namespaces. In essence, one Namespace could have an Ingress Resource
mapping a `path` of `/`, while another Namespace with its application stack,
might have an Ingress Resource mapping a `path` of `/blog`. The _one_ Ingress
**Controller** amagalmates those into a single nginx configuration to handle
inbound traffic.


### Configurations

Below is an example of an nginx Ingress Controller and a single Ingress
Resource which is applied to a single Namespace.

**ingress resource**

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: 'http-ingress'
  namespace: 'jenkins-rtyler'
  annotations:
    kubernetes.io/tls-acme: "true"
    kubernetes.io/ingress.class: "nginx"
spec:
  tls:
  - hosts:
    - rtyler.codevalet.io
    secretName: ingress-tls
  rules:
  - host: 'rtyler.codevalet.io'
    http:
      paths:
      - path: '/'
        backend:
          serviceName: 'jenkins-rtyler'
          servicePort: 80
```


**ingress controller**

```yaml
---
apiVersion: v1
kind: List
items:
  - apiVersion: v1
    kind: Namespace
    metadata:
      name: 'nginx-ingress'

  - apiVersion: v1
    kind: Service
    metadata:
      name: 'nginx'
      namespace: 'nginx-ingress'
    spec:
      type: LoadBalancer
      ports:
      - port: 80
        name: http
      - port: 443
        name: https
      sessionAffinity: 'ClientIP'
      selector:
        app: 'nginx'

  - apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: 'nginx-ingress'
      name: 'nginx'
    data:
      proxy-connect-timeout: "15"
      proxy-read-timeout: "600"
      proxy-send-timeout: "600"
      hsts-include-subdomains: "false"
      body-size: "64m"
      server-name-hash-bucket-size: "256"

  - apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: 'nginx'
      namespace: 'nginx-ingress'
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: 'nginx'
        spec:
          containers:
          - image: 'gcr.io/google_containers/nginx-ingress-controller:0.8.3'
            name: 'nginx'
            imagePullPolicy: Always
            env:
              - name: POD_NAME
                valueFrom:
                  fieldRef:
                    fieldPath: metadata.name
              - name: POD_NAMESPACE
                valueFrom:
                  fieldRef:
                    fieldPath: metadata.namespace
            livenessProbe:
              httpGet:
                path: /healthz
                port: 10254
                scheme: HTTP
              initialDelaySeconds: 30
              timeoutSeconds: 5
            ports:
              - containerPort: 80
              - containerPort: 443
            args:
              - /nginx-ingress-controller
              - --default-backend-service=webapp/webapp
              - --nginx-configmap=nginx-ingress/nginx
```
