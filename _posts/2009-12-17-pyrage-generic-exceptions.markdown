--- 
layout: post
title: "Pyrage: Generic Exceptions"
tags: 
- Opinion
- Software Development
- Python
created: 1261116613
---
Earlier while talking to <a id="aptureLink_obXTzaiLXt" href="http://bitbucket.org/which_linden/">Ryan</a> I decided I'd try to coin the term "<a id="aptureLink_kDiulq8xAO" href="http://search.twitter.com/search?q=pyrage">pyrage</a>" referring to some frustrations I was having with some Python packages. The notion of "pyrage" can extend to anything from a constant irritation to a pure "WTF were you thinking!" kind of moment.

Not one to pass up a good opportunity to bitch publicly, I'll elaborate on some of my favorite sources of "pyrage", starting with generic exceptions. While at <a id="aptureLink_KugjVYAv84" href="http://www.crunchbase.com/company/slide">Slide</a>, one of the better practices I picked up from <a id="aptureLink_rgxVh01Btf" href="http://twitter.com/stuffonfire">Dave</a> was the use of specifically typed exceptions to specific errors. In effect:
<code type="python">
    class Connection(object):
        ## Pretend this object has "stuff"
        pass

    class InvalidConnectionError(Exception):
        pass
    class ConnectionConfigurationError(Exception):
        pass
        
    def configureConnection(conn):
        if not isinstance(conn, Connection):
            raise InvalidConnectionError('configureConnection requires a Connection object')
        if conn.connected:
            raise ConnectionConfigurationError('Connection (%s) is already connected' % conn)
        ## etc </code>

Django, for example, is pretty stacked with generic exceptions, using builtin  exceptions like ValueError and AttributeError for a myriad of different kinds of exceptions. <a id="aptureLink_juWqt9ZOeK" href="http://docs.python.org/library/urllib2.html">urllib2's</a> HTTPError is good example as well, overloading a large number 
of HTTP errors into one exception leaving a developer to catch them all, and check the code, a la: <code type="python">
    try:
        urllib2.urlopen('http://some/url')
    except urllib2.HTTPError, e:
        if e.code == 503:
            ## Handle 503's special
            pass
        else:
            raise</code>

Argh. pyrage!
<!--break-->
