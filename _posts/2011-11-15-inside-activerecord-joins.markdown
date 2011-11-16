---
layout: post
title: Inside ActiveRecord Joins, a quick note
tags:
- ruby
- rails
- activerecord
- programming
---

There was once a time when I prided myself on my ignorance of SQL Joins,
foolishly proclaiming "if I need to use a JOIN, I've already screwed up."

I've slightly changed my opinions since then, mostly because I can no longer
afford to avoid JOINs. Sometimes harsh reality is the best cure for young
idealism.

Anywho, what was my point again about joins?

Ah yes, joins in [ActiveRecord](http://rubygems.org/gems/activerecord). While
ActiveRecord is a very solid ORM gem for Ruby, it is not without it's quirks.
Most of which come down to "magic" behavior or defaults you've assumed
incorrectly. As much as I would like to pontificate on the odd `method_missing`
magic ActiveRecord developers seem to love, this post is more about the latter.

In general, JOINs involve two tables, JOINing together the tables typically for
a nested query of some form or fashion. For an example, let's use this make believe query:

{% highlight sql %}
    SELECT `guests`.* FROM `guests` JOIN `plates` \
        ON plates.guest_id = guests.id WHERE \
        (guests.favorite = 'sushi' OR plates.content = 'sushi');
{% endhighlight %}


There are five basic JOINs in SQL land, and in this context they mean:

* **LEFT JOIN**: Find all the rows in `guests`, even if they don't have a corresponding `plates` row, then apply sub-query.
* **RIGHT JOIN**: Find all rows in `plates`, even if they don't have a corresponding `guests` row, then apply sub-query.
* **INNER JOIN**: Find rows *only* if `guests` has a corresponding `plates` row.
* **STRAIGHT JOIN**: Find your way to the DBA's desk and receive your punishment.
* **NATURAL JOIN**: I'll be honest, I don't fully understand what a natural join does.


Back in ActiveRecord land, let's imagine I want to create a
[named\_scope](http://apidock.com/rails/ActiveRecord/NamedScope/ClassMethods/named_scope),
which in Rails 3 has been deprecated in favor of just
[scope](http://apidock.com/rails/ActiveRecord/NamedScope/ClassMethods/scope),
I'd write code something like this:

{% highlight ruby %}
    class Guest < ActiveRecord::Base
      has_one :plate
      # ...
      named_scope :with_food, lambda { |food| {
                    :conditions => ["guests.favorite = ? OR plates.content = ?", food, food],
                    :joins => :plate
                }}
    end
{% endhighlight %}

Underneath the hood, ActiveRecord generates a query *almost* exactly like the
one above with one subtle difference. "`JOIN`" is instead an "`INNER JOIN`"
which means my query will *not* return a Guest object for any guests who do not
already have a plate object.


The "solution" is to use a `LEFT JOIN`, which is unfortunately rather gnarly.
There may be a better way to perform alternate JOINs in ActiveRecord, but I
don't yet of one:

{% highlight ruby %}
    class Guest < ActiveRecord::Base
      has_one :plate
      # ...
      named_scope :with_food, lambda { |food| {
                    :conditions => ["guests.favorite = ? OR plates.content = ?", food, food],
                    :joins => "LEFT JOIN `plates` ON plates.guest_id = guests.id"
                }}
    end
{% endhighlight %}

Basically if you want to use anything other than a simple `INNER JOIN`, you've
got to enter it in yourself. At a certain point ActiveRecord throws up its
hands and says "Look, buddy, I have no idea what you're trying to do here.
Enter your own damn SQL."


