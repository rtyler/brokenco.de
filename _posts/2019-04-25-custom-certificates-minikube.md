---
layout: post
title: Using custom root certificates with Minikube
tags:
- kubernetes
- scribd
- minikube
---

If you were to draw a coordinate system for software, where the x-axis was
"important to use" and the y-axis was "enjoyable to use", x509 certificates
would be at the extreme edge of the bottom right of quadrant four. Much as I
dislike them, they are absolutely critical to securing practically everything
we do. As is the case with most companies, [Scribd](https://scribd.com) uses
custom root certificates to establish a controlled chain of trust for internal
resources. A sensible practice, but can be a great learning exercise, causing
you to discover all the various ways in which trust is defined and managed in a
modern development environment.

This week I'm doing a wee bit of [Kubernetes](https://kubernetes.io) work,
which has required the use of
[Minikube](https://github.com/kubernetes/minikube) for local testing before I
push specs and containers into merge requests. As luck would have it,
everything I'm touching also requires accessing internal tools and services,
secured by our internal chain of trust. While my laptop already has our
certificate added to its trust store, the virtual machine which Minikube
provisions to run the local Kubernetes cluster does not. As such, it _also_
needs to be taught about the custom root certificate before I can pull from our
internal registry.

Fortunately, adding a custom root certificate has gotten _much_ easier in
recent years with Minikube. Following [this comment from
GitHub](https://github.com/kubernetes/minikube/issues/1408#issuecomment-424720319),
it's as easy as two commands:

```bash
mkdir -p ~/.minikube/files/etc/ssl/certs &&
    cp ~/my-special-corporate.crt
~/.minikube/files/etc/ssl/certs/my-private-registry.corp.pem
```

With the PEM-formatted certificate in place, `minikube start` will copy the
file into the appropriate destination once the virtual machine boots,
and the Docker daemon will then be able to verify the certificate for
`my-private-registry.corp`.

From there it's very smooth sailing to pull containers from the private
registry via Kubernetes pod definitions.

Trust anchors away!
