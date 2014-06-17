---
layout: post
title: "Testing Puppet's custom facts with RSpec"
tags:
- puppet
- rspec
- facter
---

As a long-time user of both Puppet and Jenkins, it should not be terribly
surprising to readers that I'm creator of the most downloaded
[puppet-jenkins](http://forge.puppetlabs.com/rtyler/jenkins) module on [Puppet Forge](http://forge.puppetlabs.com).

Maintaining a semi-popular Puppet module is an interesting endeavour. One must
try to maintain some semblance of quality, while still readily accepting
patches from numerous contributors who found a slightly different use-case than
your own. Since acceptance testing of Puppet modules on multiple architectures
is an enormous pain, there's an inherent "running of the gauntlet" with every
release.

The first step to sanity was to start using
[rspec-puppet](http://rspec-puppet.com)
with the module. Thanks to [Jeff McCune](https://github.com/jeffmccune), the
module has had rspec-puppet tests for the past [two
years](https://github.com/jenkinsci/puppet-jenkins/commit/96e981da1cd94629e4b6e0dee3332af0fe24640d).
Because Puppet's DSL (domain-specific language) compiles a "catalog" (an
abstract syntax tree of resources), rspec-puppet allows for some level of
testing of your Puppet code, but it only can assure you that a catalog can be
correctly compiled.

For the purposes of the
[puppet-jenkins](https://github.com/jenkinsci/puppet-jenkins) module, that
covers most  of the code in the module, but our *[custom
facts](http://docs.puppetlabs.com/guides/custom_facts.html)* were left in the
dark.

#### Breakdown of a Fact

In its most basic form, a Fact is the named result of a block of Ruby code on
a machine which is executing that Ruby. The way this is accomplished, like most
things in Ruby projects, is via yet-another-DSL:

    # lib/facter/mymodule.rb
    Facter.add("hello_world") do
      setcode do
        "i'm in your puppet!"
      end
    end


The preceeding code will be auto-loaded by the Facter gem, and executed by the
Puppet agent, exposing `$hello_world` into your manifests with a value of `"i'm
in your puppet!"`

Relatively simple, but there are a few problems:

  * *Untestable*: This code invokes the Facter DSL at the Ruby file's load
    time, not on a specific execution-time invocation. This means if you were
    to add `require 'lib/facter/mymodule.rb'` in an RSpec file, te code would run
    well before your RSpec DSL is even invoked.
  * *Not very modular*: Since all our executable code is wrapped up inside the
    DSL, re-using shared code is difficult, not impossible but hard to do in a
    conventional Ruby style.
  * *Scripts, not software*: Most of the custom facts that I've seen rely on
    `Facter::Util::Resolution#exec` for invoking shell commands, even where
    there are existing Ruby modules and functions that provide the same information.
    This isn't inherently _bad_, but it does lead to treating custom facts more
    like Ruby-styled shell scripts, rather than structured Ruby code.


#### Restructuring the code for testability

In the case of the
[puppet-jenkins](https://github.com/jenkinsci/puppet-jenkins) module's sole
`$jenkins_plugin` Fact, this is what the code [used to look
like](https://github.com/jenkinsci/puppet-jenkins/blob/d1bed59d18cac825f69d4779bd2a82858dfd7894/lib/facter/jenkins.rb).
The goal of the fact is to express the installed plugins and their versions.
Unfortunately Jenkins plugins don't have a version in their filename, but are
instead zip files containing Java bytecode, resources, and a single
`MANIFEST.MF` file, which contains all the necessary meta-data baout the
plugin.

Fortunately, Jenkins unzips this archive and sticks it on the file system when
a plugin is installed, so all the Fact needs to do is peek in a few
directories, simple right?

    if File.directory?(plugins)
      # Get a list of all plugins + versions
      Dir.entries(plugins).select do |plugin|
        if (File.directory?("#{plugins}/#{plugin}") == true) && !(plugin == '..' || plugin == '.')
          begin
            contents = File.read("#{plugins}/#{plugin}/META-INF/MANIFEST.MF")
            contents =~ (/Plugin\-Version:\s+([\d\.\-]+)/)
            version = $1
            jenkins_plugins = "#{plugin} #{version}, " + jenkins_plugins
          rescue
            # Nothing really to do about it, failing means no version which will
            # result in a new plugin if needed
          end
        end
      end
    end

Not only was this code not covered by RSpec, it does so many things, I had to
run it a few times to make sure I fully understood how it would work!

Forget about Facter for a moment, this becomes a classic "restructure for
testability" problem, which was [solved in this
commit](https://github.com/jenkinsci/puppet-jenkins/blob/2b475e4aac927f9abd336388a37872349b894f93/lib/facter/jenkins.rb#L9).

The commit introduces:

  * The `Jenkins::Facter` module with:
    * `#jenkins_home` - resolves an absolute path to the Jenkins home directory
    * `#add_facts` - installs the Fact
  * The `Jenkins::Facter::Plugins` module with:
    * `#directory` - resolves an absolute path to the plugin directory
    * `#manifest_data` - parse a string formatted the way `MANIFEST.MF` files
      are formatted, into a Ruby `Hash`.
    * `#exists?` - determine whether the Jenkins plugin directory exists
    * `#plugins` - compile the list of plugins and versions

That's a lot of methods, with a lot more comments and _test coverage_! Looking
over the code again, I see more opportunities for refactoring; probably because
it's just Ruby code to me now.


#### Testing the Fact


Refactoring into more Ruby-like code allows for easier testing of the Ruby-code
that's powering our Facts, but what about the Facts _themselves_?

Above I mentioned the `#add_facts` method, which is added to avoid adding Facts
when the file is loaded into RSpec. It's relatively straight-forward, just wrap
the previous DSL code in a method.


    # lib/facter/mymodule.rb
    module MyModule
      def self.add_facts
        Facter.add("hello_world") do
          setcode do
            "i'm in your puppet!"
          end
        end
      end
    end

    MyModule.add_facts

You'll notice that at the bottom of the file, `#add_facts` is still invoked.
This is to ensure that the Facts we've defined will still get properly loaded
by the Facter gem when Puppet runs.


We're still not done testing this Fact though! Facter loads facts into a global
collection, which means there's some special sauce that you need to add to your
RSpec tests to make sure that Facter is cleared and properly reloaded for every
example, e.g.:

    describe 'hello_world fact' do
      subject(:fact) { Facter.fact(:hello_world) }

      before :each do
        # Ensure we're populating Facter's internal collection with our Fact
        MyModule.add_facts
      end

      # A regular ol' RSpec example
      its(:value) { should eql("i'm in your puppet!") }

      after :each do
        # Make sure we're clearing out Facter every time
        Facter.clear
        Facter.clear_messages
      end
    end

---

That's more or less all there is to starting to add RSpec-based test coverage
for the custom facts you are including in your Puppet modules. Once you're
writing RSpec, it's easy to stub and mock out as much as necessary to cover all
the variations or cases you might need for your Fact.

All said and done, figuring this out took about 2 hours and in the process of
crafting [this
commit](https://github.com/jenkinsci/puppet-jenkins/commit/2b475e4aac927f9abd336388a37872349b894f93)
the size of our `.rb` file went from ~28 lines of untested Facter DSL to ~115
lines of Ruby with ~160 lines of accompanying RSpec.

Now with each subsequent release of the puppet-jenkins module, I can have a
very high level of confidence that our custom facts will continue to work
correctly without manually testing them in an actual Puppet environment.

That's one less thing to worry about when running the gauntlet, hitting that "Upload Module"
button, and creating a release to Puppet Forge.
