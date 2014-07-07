---
layout: post
title: "Profiling of remote JVMs with VisualVM and JConsole"
tags:
- jvm
- jruby
- visualvm
---

**Note:** I originally posted this
[here](http://hackers.lookout.com/2014/06/profiling-remote-jvms/), on the
[Lookout hackers blog](http://hackers.lookout.com). I encourage you to check
the blog out and follow [@LookoutEng](https://twitter.com/lookouteng).

---

Recently I found myself hosting a bit of a "bake-off competition" between
servlet containers for JRuby applications here at
[Lookout](https://www.lookout.com/about/careers).


The goal of the bake-off was to determine whether we should host some
[warbled](https://github.com/jruby/warbler) JRuby applications in Tomcat or
Jetty. Not having a huge amount of experience, or bias, towards one or the
other I elected to run a simple [Hello
Warld](https://github.com/rtyler/hellowarld) application in both and see how
well the containers performed.


### The Bake-Off Environment

For the bake-off of servlet containers I used to identical EC2 instances. EC2
instances were chosen instead of running both containers on my local machine to
keep the machines consistent, isolated and more representative of the
environment we would be running webapps in. The test bed specs were:

 * Ubuntu 12.04 LTS
 * `m1.small` instance size (hey, I'm not made of money!)
 * us-west-2 region
 * A security group with everything open to the other machines in that security
   group. This is important for later.
 * OpenJDK 7 (u55)

The machines were then provisioned with the Tomcat 7 and Jetty 6 respectively,
only because those were available directly from the native packages on Ubuntu 12.04.

Both containers were also set up to perform hot-deploys; a feature which relies
on live-reloading of an application without restarting the JVM.


### Problems, ahoy!

After performing a number of successive hot-deploys in Tomcat, I found my logs
clobbered with the following errors:

~~~
Exception in thread "RMI TCP Connection(idle)" java.lang.OutOfMemoryError: PermGen space
Exception in thread "RMI TCP Connection(idle)" java.lang.OutOfMemoryError: PermGen space
Exception in thread "RMI TCP Connection(idle)" java.lang.OutOfMemoryError: PermGen space
~~~

The actual problem here will need to be covered in another blog post, but
something fishy was clearly going on with hot-deployments in Tomcat.


## Profiling in the cloud

My favorite tool for understanding a running JVM is
definitely [VisualVM](http://visualvm.java.net/), with
[JConsole](http://docs.oracle.com/javase/6/docs/technotes/guides/management/jconsole.html)
running in a close second place. Fortunately, both tools are quite easy to set
up for connecting to remote JVMs.


### Setting up jstatd

Previously I mentioned the importance of the EC2 security group. It's important
that port **1099** is open within the security group. This is the port
[jstatd](http://docs.oracle.com/javase/7/docs/technotes/tools/share/jstatd.html)
runs on by default. `jstatd` is what will provide VisualVM with live
instrumentation data from the JVMs running on the machines.


It's also important to provide a liberal security policy file to `jstatd`. If
this were anything more than a simple test implementation, I would recommend a
more restrictive policy, but we're optimizing for easiness here, so a wide open
policy is fine:

~~~
grant codebase "file:${java.home}/../lib/tools.jar" {
    permission java.security.AllPermission;
};
~~~

Save the policy above into a file named `jstatd.policy`, which we can run
on each machine:

~~~
ec2-tomcat% sudo jstatd -J-Djava.security.policy=./jstatd.policy &
~~~

~~~
ec2-jetty% sudo jstatd -J-Djava.security.policy=./jstatd.policy &
~~~

### JMX for interactivity

`jstatd` only gives us half the picture we want. We also want
[JMX](http://www.oracle.com/technetwork/java/javase/tech/javamanagement-140525.html)
to be configured for both containers to allow us to extract more information
and interact with the running JVMs.


Again, we'll set up very liberal security policies since this is for testing
only! The native packages for both containers put a file in `/etc/defaults`
which contains a `JAVA_OPTS` variable, to which the following should be added:

~~~
-Dcom.sun.management.jmxremote \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.authenticate=false \
-Dcom.sun.management.jmxremote.port=1098
~~~

After restarting the container processes, they will now have the right JMX
settings and we should be able to finally be able to connect VisualVM or
JConsole to the JVMs.



### Proxying for connectivity

In order to give tools running locally on my machine access to these processes
running inside of a security group within EC2, I'll rely on `ssh`'s ability to
provide a SOCKS5 proxy;

~~~
kiwi% ssh -D 9696 ubuntu@ec2-66-166-66-66.us-west-2.compute.amazonaws.com
~~~

This will provide a path for both VisualVM and JConsole to use when accessing
the JMX information (port 1098) and the `jstatd` information (port 1099) on the
machines running inside of a security group within EC2. While not wholly
necessary, exposing these ports to the wide-open internet seems like a Bad
Idea&trade;.


#### Running JConsole with a proxy

JConsole doesn't have any GUI configuration for a proxy, so it's necessary to
set some command line parameters:

~~~
kiwi% jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=9696
~~~

Once JConsole is up and running, you only need to enter the EC2 hostname and
appropriate JMX port (1098) to connect to the running JVM:

![JConsole with EC2
hostnames](http://hackers.lookout.com/images/post-images/profiling-remote-jvms/jconsole-with-proxy.png)

After clicking "Connect", JConsole will use the SSH-based proxy to connect to
the host, and you should be able to poke around with a real live JVM:

![JConsole connected to
EC2](http://hackers.lookout.com/images/post-images/profiling-remote-jvms/jconsole-connected-remotely.png)


### Running VisualVM with a proxy

Unlike JConsole, VisualVM allows for a GUI-based configuration of a SOCKS
proxy:

![VisualVM proxy
configuration](http://hackers.lookout.com/images/post-images/profiling-remote-jvms/visualvm-proxy-conf.png)

With the proxy configuration saved, we can then add a remote host by
right-clicking on "Remote" and selecting "Add remote host".

![Adding remote VisualVM
host](http://hackers.lookout.com/images/post-images/profiling-remote-jvms/adding-remote-host-visualvm.png)


Provided `jstatd` is running on the remote host, your SSH-based proxy is
running and the remote JVM is running, you should be able to connect to the
remote JVM and start profiling it like you would a local JVM!

![Profiling Tomcat
remotely](http://hackers.lookout.com/images/post-images/profiling-remote-jvms/profiling-tomcat-remotely.png)

---

Both JConsole and VisualVM give you access to a lot of the instrumentation data
available from a running Java Virtual Machine, but neither will magically
identify or solve performance problems. There's still more work to be done to
triage and ultimately resolve those kinds of issues, but at least these tools
give you the information you need to know what's going on, and [knowing is half
the
battle](http://cdn.churchm.ag/wp-content/uploads/2014/03/knowing-is-half-the-battle.jpg).


