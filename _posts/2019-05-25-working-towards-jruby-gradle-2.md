---
layout: post
title: "Marching towards JRuby/Gradle 2.0"
tags:
- jrubygradle
- jruby
- gradle
---


[JRuby/Gradle](http://jruby-gradle.org) is one of the few open source projects
which I created that _actually_ resonates with people. One that I find myself
continuing to work on, despite not using it in my day-to-day work. JRuby/Gradle is a
collection of Gradle plugins which make it easy to build, test, manage and
package Ruby applications. By combining the portability of JRuby with Gradle’s
excellent task and dependency management, JRuby/Gradle provides high quality
build tooling for Ruby and Java developers alike. With my fellow maintainer,
[Schalk
Crojn&eacute;](https://github.com/ysb33r), I started working towards the [2.0
milestone](https://github.com/jruby-gradle/jruby-gradle-plugin/milestone/27).


I have tried to name each release after a different German city, a callback to
some JRubyConf EU events many years ago where Schalk, [Christian
Meier](https://github.com/mkristian), 
[Colin
Surprenant](https://github.com/colinsurprenant), and I had the good fortune to
meet up and work together. Since two point zero is so very exciting, I thought
I would name it after a very exciting city: Stuttgart (_the joke being that
it's about as exciting as a bowl of cold oatmeal_).

With two point zero, we have an opportunity to make major backwards compatible
changes and adopt newer APIs provided by Gradle underneath. We're also taking
the opportunity to remove support for older end-of-lifed JRuby versions, namely
JRuby 1.7.x, and all the gnarly code which was necessary to support those
versions.


I don't have a date in mind for releasing 2.0.0, but it will likely happen
within the next month or so, depending on how my own hobby-hacking schedule
shapes up.

---

I recently started playing around with the idea of combining Ruby with [Apache
Spark](https://spark.apache.org) under the moniker
"[redspark](https://github.com/jruby-gradle/redspark)." To get started with
the project I made use of JRuby/Gradle and I was almost giddy with excitement
at how _easy_ building fat `.jar` files with Ruby was, and how quickly I was
able to get a Ruby-based Spark job running. The code below is an example which
I am working with. There are still some bugs with how
Ruby objects are serialized and re-constituted on Spark worker nodes. The
redspark project has already fulfilled the main goal for JRuby/Gradle: making
it easy to bring the best of the Ruby and Java worlds together.


On to two point zero!


```ruby
#!/usr/bin/env ruby
#
# To run, first execute `./gradlew jrubyJar` to package the jar, then call
# `./run.sh` to send the jar to a local spark cluster installation
#

java_import 'org.apache.spark.sql.SparkSession'
java_import 'org.apache.spark.api.java.function.FilterFunction'
java_import 'org.apache.spark.api.java.function.ForeachFunction'

logfile = 'build.gradle'
spark = SparkSession.builder.appName('Simple Application').getOrCreate
data = spark.read.textFile(logfile).cache()

class BeeForeach
  include org.apache.spark.api.java.function.ForeachFunction
  def call(item)
    puts "foreaching item: #{item}"
  end
end
class BeeFilter
  include org.apache.spark.api.java.function.FilterFunction
  def call(item)
    puts "filtering item: #{item}"
  end
end

puts "about to filter"
alphas = data.distinct
#
# Failure caused while deserializing on the spark worker
#
# java.lang.ClassCastException: cannot assign instance of
# scala.collection.immutable.List$SerializationProxy to field
# org.apache.spark.rdd.RDD.org$apache$spark$rdd$RDD$$dependencies_ of typ
#betas = data.filter(BeeFilter.new).count

# Failure caused while deserializting on the spark worker
#
# java.lang.ClassNotFoundException: org.jruby.gen.BeeForeach_799252494
betas = data.foreach(BeeForeach.new).count

# Failure caused while serializing on the spark master
#
# java.io.IOException: can not serialize singleton object
#betas = data.filter { |line| line.contains('b') }.count
puts "filtered"

puts
puts "Hello from Ruby, we read #{logfile}"
puts " and found #{alphas} 'a' characters"
puts " and #{betas} 'b' characters"
puts 

spark.stop()
```
