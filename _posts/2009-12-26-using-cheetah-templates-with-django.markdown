--- 
layout: post
title: Using Cheetah templates with Django
tags: 
- Software Development
- Cheetah
- Python
created: 1261859471
---
Some time ago after reading a post on [Eric Florenzano's blog](http://www.eflorenzano.com/blog/post/cheetah-and-django/) about hacking together support for <a id="aptureLink_OfHfDIpuSN" href="http://en.wikipedia.org/wiki/CheetahTemplate">Cheetah</a> with <a id="aptureLink_0oRd4dQsSK" href="http://en.wikipedia.org/wiki/Django%20%28web%20framework%29">Django</a>, I decided to add "proper" support for Cheetah/Django to Cheetah v2.2.1 (released June 1st, 2009). At the time I didn't use Django for anything, so I didn't really think about it too much more.

Now that I work at <a id="aptureLink_AYRRV0XTwi" href="http://www.crunchbase.com/company/apture">Apture</a>, which uses Django as part of its stack, Cheetah and Django playing nicely together is more attractive to me and as such I wanted to jot down a quick example project for others to use for getting started with Cheetah and Django. You can find the [django_cheetah_example](http://github.com/rtyler/django_cheetah_example) project on GitHub, but the gist of how this works is as follows.

### Requires

 * [Django](http://www.djangoproject.com/)
 * [Cheetah](http://cheetahtemplate.org) (>= v2.2.1)

### Getting Started

For all intents and purposes, using Cheetah in place of Django's
templating system is a trivial change in how you write your *views*. 

After following the Django [getting started](http://docs.djangoproject.com/en/1.1/intro/tutorial01/) 
documentation, you'll want to create a directory for your Cheetah templates, such 
as `Cheetar/templates`. Be sure to `touch __init__.py` in your template 
directory to ensure that templates can be imported if they need to.

Add your new template directory to the `TEMPLATE_DIRS` attribute
in your project's `settings.py`. 

Once that is all set up, utilizing Cheetah templates in Django is just 
a matter of a few lines in your view code:
<code type="python">
    import Cheetah.Django

    def index(req):
        return Cheetah.Django.render('index.tmpl', greet=False)</code>

**Note**: Any keyword-arguments you pass into the `Cheetah.Django.render()` 
function will be exposed in the template's "searchList", meaning you can
then access them with $-placeholders. (i.e. `$greet`)

With the current release of Cheetah ([v2.4.1](http://pypi.python.org/pypi/Cheetah/2.4.1)), there isn't support for using pre-compiled Cheetah templates with Django (it'd be trivial to put together though) which means `Cheetah.Django.render()` uses Cheetah's dynamic compilation mode which can add a bit of overhead since templates are compiled at runtime (your mileage may vary).
<!--break-->
