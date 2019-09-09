---
layout: post
title: Ruby Infrastructure Engineering
tags:
- ruby
- scribd
---

My favorite part of the stack is the netherworld between the underlying
infrastructure and the app. That fuzzy grey area where data goes from databases
to object-relational mappers (ORMs), web servers to request libraries (e.g.
Rack/WSGI), and so on. In many cases a technology roadmap where one considers
infrastructure, but not the application, or vice-versa, is doomed from the
start. At Scribd, I have been given permission to hire more people that love
this layer of the stack, and I have taken to calling it "Ruby Infrastructure."
A phrase which is fairly unique, that I wanted to define in greater detail.

I have described the general mission of [the
team](https://jobs.lever.co/scribd/6fff482b-6363-4525-b6b0-6131d6994eef) as
follows:

> The Ruby Infrastructure team will help Scribd adopt major ecosystem
> improvements such as Sorbet, new Rails versions, and interpreter releases.
> Measure and optimize performance across the thousands of requests per second
> served by Ruby at Scribd. Create libraries that encapsulate common Ruby
> application patterns and approaches. Open high quality pull requests to
> improve upstream projects like Sidekiq, Rails, and Ruby itself.


Ruby at Scribd is serious business. We run one of the largest Rails deployments
on the internet (hi
[GitHub](https://github.blog/2019-09-09-running-github-on-rails-6-0/)!) and
need more focused effort on scaling it from a technology and organization
standpoint. The Ruby ecosystem has also matured greatly over the past 10 years
and every couple of months there are new improvements which Scribd can adopt. 

The Ruby Infrastructure team is intended to be the group of people which make
sure that all our Ruby and Rails applications are performing well, scaling, and
are easy to develop and deploy.

To give you a better idea of what this team will do, here are some of the
projects which I have in mind:

### Simplify with Aurora

We have over 7TB of online relational data which, for historical reasons, is
spread across a number of master-replica clusters. Migrating these databases
to, and adopting [RDS/Aurora](https://aws.amazon.com/rds/aurora/#) looks very
promising. The advertised read-performance and dataset storage scalability may
allow us to consolidate the database infrastructure and allow us to delete swaths
of complex database magic in the applications.

All that code for switching up database connections or delegating reads to
read-replicas _may_ disappear behind the curtains of Aurora. We certainly need
to do some investigation here, but this is a pristine example of that grey area
where the Ruby Infrastructure team will excel.


### Web Socketin'

Enabling Web Sockets on smaller applications is trivially easy these days. For
larger sites like [Scribd.com](https://scribd.com/) a large number of variables
need to be considered: do we terminate sockets in Rails? What will an
incredibly high connection count do to our existing app infrastructure? How
will application developers write code which supports Web Sockets and their
existing request flows? Does our app host capacity plan change dramatically as
a result?

Seemingly mundane requests like "can we enable web sockets?" from application
developers or product managers, at the scale of billions of requests per month,
can have far reaching implications that the Ruby Infrastructure team is poised
perfectly to answer.


### Efficient Host Sizing

Our current infrastructure is at times over-provisioned. The specifics I won't
get into in this post, but there are a lot of low-hanging fruit in understanding
our existing application footprints and then sizing our infrastructure around
them appropriately. Whether we're talking about understanding or improving our
[memory
utilization](https://www.joyfulbikeshedding.com/blog/2019-03-29-the-status-of-ruby-memory-trimming-and-how-you-can-help-with-testing.html),
or becoming more elastic around CPU utilization. Building an overall
understanding of how these Ruby applications perform, how to tune them, and how
to structure their resource usage is going to be one of the frequently
re-evaluated projects for Ruby Infrastructure.


---

There are a myriad of other interesting projects which will crop up once a
couple [Ruby Infrastructure
Engineers](https://jobs.lever.co/scribd/6fff482b-6363-4525-b6b0-6131d6994eef)
join the company. Like the other teams in [Platform
Engineering](/2019/08/22/platform-engineering-at-scribd.html), this team will
be entirely remote which means we can  hire the most qualified people we're
able to find, from nearly anywhere.

I'm excited to see the upstream pull requests, RailsConf presentations, and blog
posts that we're going to be able to share once we start solving problems
together!
