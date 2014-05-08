---
layout: post
title: "3 Elasticsearch nodes in 3 minutes"
tags:
- vagrant
- vagrant-aws
- puppet
- elasticsearch
---

For one of my newer projects at [Lookout](http://hackers.lookout.com), I've
been experimenting with [Elasticsearch](https://elasticsearch.com) as the
primary data store. The advantages of Elasticsearch are many for my particular
use-case, but one of the things I particularly like about it is the distributed
nature of its design.

Like most modern data stores, Elasticsearch was built to be deployed in a
clustered environment where data is replicated automatically between various
nodes (Cassandra is also in this category). Also like most modern data stores,
most developers won't run a cluster of Elasticsearch nodes for their local
development. They'll only run one, and miss a lot of simple bugs that can crop
up from a distributed system. Such as (not a complete list):

 * The node you're talking to goes down
 * The node you're talking to is too slow
 * The node you're talking to has become disconnected from the other nodes
 * The data you've just written hasn't yet been indexed (Elasticsearch specific)
 * And of course, Heisenbugs!


To make my life easier, I created the
[instant-elasticsearch](https://github.com/rtyler/instant-elasticsearch)
repository. `instant-elasticsearch` uses a couple great tools to make it easy to
spin Elasticsearch nodes up and down in AWS:

 * [Vagrant](http://vagrantup.com)
 * [Puppet](https://github.com/puppetlabs/puppet)
 * The [vagrant-aws](https://github.com/mitchellh/vagrant-aws) plugin for
   Vagrant
 * The [elasticsearch/elasticsearch](http://forge.puppetlabs.com/elasticsearch/elasticsearch) Puppet module

Combining these four building blocks with a simple Puppet
[manifest](https://github.com/rtyler/instant-elasticsearch/blob/master/manifests/vagrant.pp)
and a clever
[Vagrantfile](https://github.com/rtyler/instant-elasticsearch/blob/master/Vagrantfile)
and `instant-elasticsearch` is a `vagrant up` away from automatically
provisioning a *functional* and *self-discovering* Elasticsearch cluster.

Once the cluster is up and running, you will have to do the manual work of
copying some hostnames into your application's configuration files but only
because I've not yet had a chance to automate that part (shame on me).

The workflow I use for `instant-elasticsearch` is one where I come
into the office in the morning, spin up my entire cluster fresh which takes
about 3-4 minutes. After it's provisioned, I start my work. Throughout the day I
might shutdown some instances here and there to test some fault tolerance, but
for all intents and purposes the cluster remains mostly "up" until the end of
the day. At the end of the day, I make sure all my code is committed, then run
`vagrant destroy -f` to nuke my cluster.

All said and done I might spend a couple of bucks to save myself countless
hours of hunting down the subtle application bugs that might occur in
production without sufficient testing locally.

Not too bad for 80 lines of Puppet, and 50 lines of Ruby!

