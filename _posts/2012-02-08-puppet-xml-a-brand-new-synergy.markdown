---
layout: post
title: "Puppet/XML: A Brand New Synergy"
tags:
- stupidhacks
- programming
- puppet
---

During on of the last talks of the last day of [FOSDEM](http://www.fosdem.org),
some person asked in one of the tracks (paraphrased):

> "*Why do we need tools like Puppet or Chef when we have XML?*"

This question was relayed to me second-hand, so I apologize if I'm butchering
it. The question itself is so mind-boggling that I can only assume one of three
things about the asker:

* He/she is a rather talented troll
* He/she has some crucial misunderstandings about configuration management, in
  which case I'm hoping somebody politely explained things.
* He/she understands CM but has a serious fetish for XML.

---

Regardless of their intention, I have them to thank for inspiring what might
be the innovation breakthrough of 2012:

### Puppet/XML

I've long found Puppet's DSL syntax to be too sparse, easy to type and
semantically boring, take for example this block:

    class users {
        group {
            "tyler" :
                ensure => present;
        }
        user {
            "tyler" :
                require => Group["tyler"],
                ensure  => present;
        }
    }

How terrible! Let's turn that into **Puppet/XML!**

    <?xml version="1.0"?>
    <puppet>
        <classes>
            <class name="users">
                <resources>
                    <group name="tyler">
                        <ensure>present</ensure>
                    </group>
                    <user name="tyler">
                        <requires>
                            <require>Group["tyler"]</require>
                        </requires>
                        <ensure>present</ensure>
                    </user>
                </resources>
            </class>
        </classes>
    </puppet>

Not only is that easier to understand, it's more enterprise ready!

Currently **Puppet/XML** is in pre-alpha and in [this repository on
GitHub](https://github.com/rtyler/puppet/tree/puppetxml). Thus far it's only
been tested with `puppet apply` (i.e. standalone mode) under
[Vagrant](http://www.vagrantup.com), an example run is below:

    [default] Running Puppet with /tmp/vagrant-puppet/manifests/base.ppx...
    stdin: is not a tty
    Thanks for using Puppet/XML - A brand new synergy

    info: Retrieving plugin
    info: Applying configuration version '1328719113'
    notice: /Stage[main]/Users/User[tyler]/ensure: created
    notice: /Stage[main]//Node[default]/Group[puppet]/ensure: created
    info: Creating state file /var/lib/puppet/state/state.yaml
    notice: Finished catalog run in 0.62 seconds


Stay tuned for new innovations and more middleware that your enterprise can
leverage to help meet your business objectives.

---

***Disclaimer:*** Unfortunately the code currently relies on transcribing the
Puppet/XML to Puppet's "native" DSL, this means more complex things like
conditionals and function calls are not yet supported. After spending about an
hour and a half trying to generate the appropriate `Puppet::AST` structures, I
gave up and went the route which guaranteed lulz sooner.
