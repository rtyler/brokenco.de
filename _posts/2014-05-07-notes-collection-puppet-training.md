---
layout: post
title: A loose collection of notes from Puppet training
tags:
- puppet
- puppetlabs
---

Last week, [Kohsuke](https://github.com/kohsuke) and I participated in a Puppet
training and consulting event on behalf of the
[Jenkins](https://jenkins-ci.org) project. Fortunately, or unfortunately
depending on how you look at it, we both had some amount of Puppet knowledge
going into the sessions, but neither of us had actually deployed a `puppet
master` before, let alone used the Puppet Enterprise Console. I've written good
bits of Puppet **code**, I've not made *good use* of Puppet though.

Below is a more or less unedited list of my notes taken during the entirety of
the week.

---

### Puppet Basics/Advanced Training

#### Installing Puppet Enterprise on Master

 * Install cloud provisioner
 * Puppet has its own CA built into it, don't use upstream/certificate
   authority certificates for Puppet to Puppet communications
 * PostgreSQL is vendored by Puppet Enterprise

#### Installing the Puppet Enterprise on an Agent

 * Creating certificates can be done by the agent automatically, but the
   signing should be done on the master
 * Console can sign certs too through the UI
 * `puppet --test` will actually apply the changes, `--noop` is required to not
   actually enforce a catalog
 * `tag` on a resource or `tag()` to tag a class


#### Puppet Enterprise Console notes

 * 1-2 background tasks backed up and waiting means that something is probably
   broken.
 * Unresponsive node means that we likely have a dead node or that a node was
   not running a puppet agent
 * _Live Management_ builds on top of MCollective


#### Node Classification

 * node classification uses the agent node's name/certname (so use a FQDN)
 * node classification and our modules in the training VM, the modules we've
   built are the same "name" but are being deployed into different environment
   paths on the puppet master

#### Resources

 * `puppet describe <resourcetype>` for docs
 * should look into the puppetlabs/postgresql module for managing databases
 * exported resources, what order are those executed in relation to the
   collection?
 * Should look into nanliu/staging to making untars sane

##### Resource Relationships

 * Can use `contains` for containing class relationships instead of needing to
   use the anchor pattern


##### Language constructs

 * Scoping of variables in classes will generally be shared with `include`
   except for the `params class` pattern ,which is just about the only place to
   use `inherit` non-stupidly
 * catalog diff tool from zach smith would be useful for diffing ehether scope
   changes in old versus new puppet code
 * Using resource defaults in a class scope (such as `File { owner => 'apache' }`
   works well, but should be paired with a shared example to make sure things
   are enforced for subsequent `file` resources in the specs
 * For conditionals `undef`, `''`, `false` are falsey for the conditionals
 * Functions always execute on the master when the catalog is compiled
 * `regsubst` might be a good funciton to replace the puppet-jenkins use of
   `inline_template`

#### ERB Templates

 * `<%= @foo -%>` the `-%>` chomps the trailing newline
 * `templates` directory of the modules is where these should go.
 * `template` can take multiple files and concatenate them together

#### Defined types

 * Scope lookup inside defined types works such that: defined type scope ->
   calling class scope -> node scope -> global scope
 * Using `purge => true` on resources will make sure that we remove resources
   that are not managed. Good for making sure spurious configuration doesn't
   find its way onto production machines

#### Hiera

 * Need to use `hiera()` in the manifests
 * Any facter fact that is available can be jammed into the hiera hierarchy
 * PuppetDB reporting/etc might include hiera-sourced secrets that were logged from a catalog
   run on a machine
 * hiera-based class parameters should be in the file as `ntp::time_server`
 * `hiera_array` interesting for pulling all matching values for a key down
   (e.g. a list of servers)
 * `hiera_hash` and `create_resources` make a lot of sense for how we should
   manage users

#### Relationships

 * `subscribe` and `notify` can be short-handed with `<~` and `~>`

#### Augues

 * `augtool` can be used from the command line to inspect the tree of a file on
   the file system before referring to it in Puppet with the `augeas` type
 * [augeas.net](http://augeas.net)



#### Troubleshooting

 * `puppet agent --configprint vardir` where lots of puppet agent/master state
   is stored
 * `statedir` contains all the information from the last run, etc.
 * `last_run_report.yaml` might contain secrets from the last run
 * Agent initiates connection to master, 443 and 8140 (console and agent
   traffic respectively) should be open on master, not on agents
 * `puppet node deactivate` will clean up exported resources from a dead
   machine. "unexport all exported resources"
 * `/var/log/pe-*/*.log` will have all the relevant logs on the master.
   `/var/log/messages` is likely going to be where logs are on agents


----


### Rapid Deployment Support/Training

 * `r10k deploy` always runs on the puppet master, usually from a git
   post-receive hook
 * The r10k control repository can be a local file://git or git://git repo
 * profiles as a concept pull in modules with some business logic within them
 * profiles should probably be where the hiera lookups of data should occur
 * roles contain no logic at all
 * node classification with just assigning roles provides a simpler abstraction



#### Deployment pipeline iteration 0

 * feature branches created for jenkins-infra and then sending a pull request
 * `staging` branch should be PRed to, with the puppet master tooling running
   no-op deployments on all agents
 * merging to production should automatically deploy to puppet master and nodes


#### Secrets management

 * Private "keys repository" holding keys on github
 * hiera-eyaml as the default data provider for hiera on the puppetmaster
 * encrypted blobs can/should go into jenkins-infra.git/hieradata


#### Testing notes

 * rspec-puppet cannot be configured with an array as the module path


#### Misc notes

 * Setting up agent: ` curl -k https://puppet:8140/packages/current/install.bash | bash`
 * The puppet master can also act as an apt repository for puppet packages

