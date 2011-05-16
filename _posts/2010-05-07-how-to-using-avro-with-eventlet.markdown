--- 
layout: post
title: "How-to: Using Avro with Eventlet"
tags: 
- software development
- python
- apture
nodeid: 282
created: 1273250700
---
Working on the plumbing behind a sufficiently large web application I find
myself building services to meet my needs more often than not. Typically I
try to build single-purpose services, following in the unix philosophy, cobbling
together more complex tools based on a collection of distinct building blocks.
In order to connect these services a solid, fast and easy-to-use RPC library is
a requirement; enter [Avro](http://hadoop.apache.org/avro/).

----

*Note:* You can skip ahead and just start reading some source code by cloning my
[eventlet-avro-example](http://github.com/rtyler/eventlet-avro-example) repository
from GitHub.

----

Avro is part of the Hadoop project and has two primary components, data serialization
and RPC support. Some time ago I chose Avro for serializing all of <a id="aptureLink_LDwxZTTwKh" href="http://www.apture.com">Apture's</a> metrics and logging
information, giving us a standardized framework for recording new events and processing
them after the fact. It was not until recently I started to take advantage of Avro's
RPC support when building services with <a id="aptureLink_a4wlc7Bdkp" href="http://eventlet.net/doc/">Eventlet</a>. I've talked about Eventlet [before](http://unethicalblogger.com/posts/2010/01/new_years_python_meme), but
to recap:

> Eventlet is a concurrent networking library for Python that allows you to change how you run your code, not how you write it

What this means in practice is that you can write highly concurrent network-based
services while keeping the code "synchronous" and easy to follow. Underneath
Eventlet is the "<a id="aptureLink_FICZSkfldQ" href="http://pypi.python.org/pypi/greenlet">greenlet</a>" library which implements coroutines for Python, which
allows Eventlet to switch between coroutines, or "green threads" whenever a network
call blocks.


Eventlet meets Avro RPC in an unlikely (in my opinion) place: WSGI. Instead of building
their own transport layer for RPC calls, Avro sits on top of HTTP for its transport
layer, POST'ing binary data to the server and processing the response. Since Avro can sit on top of HTTP, we can use [eventlet.wsgi](http://eventlet.net/doc/modules/wsgi.html) for building a fast, simple RPC server.
<!--break-->
### Defining the Protocol
The first part of any Avro RPC project should be to define the protocol for RPC calls.
With Avro this entails a JSON-formatted specification, for our echo server example,
we have the following protocol:

    {"protocol" : "AvroEcho",
    "namespace" : "rpc.sample.echo",
    "doc" : "Protocol for our AVRO echo server",
    "types" : [],
    "messages" : {
        "echo" : {
            "doc" : "Echo the string back",
            "request" : [
                    {"name" : "query", "type" : "string"}
                    ],
            "response"  : "string",
            "errors" : ["string"]
        },
        "split" : {
            "doc" : "Split the string in two and echo",
            "request" : [
                    {"name" : "query", "type" : "string"}
                    ],
            "response"  : "string",
            "errors" : ["string"]
        }
    }}


The protocol can be deconstructed into two concrete portions, type definitions and
a message enumeration. For our echo server we don't need any complex types, so the
`types` entry is empty. We do have two different messages defined, `echo` and `split`.
The message definition is a means of defining the actual remote-procedure-call,
services supporting this defined protocol will need to send responses for both kinds
of messages. For now, the messages are quite simple, they expect a `query` parameter
which should be a string, and are expected to return a string. Simple.

(This is defined in [protocol.py](http://github.com/rtyler/eventlet-avro-example/blob/master/protocol.py) in the Git repo)


### Implementing a Client
Implementing an Avro RPC client is simple, and the same whether you're building a
service with Eventlet or any other Python library so I won't dwell on the subject.
A client only needs to build two objects, an "HTTPTransceiver" which can be used
for multiple RPC calls and grafts additional logic on top of `httplib.HTTPConnection`
and a "Requestor".

    client = avro.ipc.HTTPTransceiver(HOST, PORT)
    requestor = avro.ipc.Requestor(protocol.EchoProtocol, client)
    response = requestor.request('echo', {'query' : 'Hello World'})

You can also re-use for same `Requestor` object for multiple messages of the same
protocol. The three-line snippet above will send an RPC message `echo` to the server
and then return the response.

(This is elaborated more on in [client.py](http://github.com/rtyler/eventlet-avro-example/blob/master/client.py) in the Git repo)


### Building the server
Building the server to service these Avro RPC messages is the most complicated
piece of the puzzle, but it's still remarkably simple. Inside the `server.py` you
will notice that we call `eventlet.monkey_patch()` at the top of the file. While not
strictly necessary inside the server since we're relying on `eventlet.wsgi`for
writing to the socket. Regardless it's a good habit to get into when working with
Eventlet, and would be required if our Avro-server was also an Avro-client, sending
requests to other services. Focusing on the simple use-case of returning responses
from the "echo" and "split" messages, first the WSGI server needs to be created:

    listener = eventlet.listen((HOST, PORT))
    eventlet.wsgi.server(listener, wsgi_handler)

The `wsgi_handler` is a function which accepts the `environment` and `start_response`
arguments (per the WSGI "standard"). For the actually processing of the message,
you should refer to the `wsgi_handler` function in `server.py` in the example
repository.

    def wsgi_handler(env, start_response):
        ## Only allow POSTs, which is what Avro should be doing
        if not env['REQUEST_METHOD'] == 'POST':
            start_response('500 Error', [('Content-Type', 'text/plain')])
            return ['Invalid REQUEST_METHOD\r\n']

        ## Pull the avro rpc message off of the POST data in `wsgi.input`
        reader = avro.ipc.FramedReader(env['wsgi.input'])
        request = reader.read_framed_message()
        response = responder.respond(request)

        ## avro.ipc.FramedWriter really wants a file-like object to write out to
        ## but since we're in WSGI-land we'll write to a StringIO and then output the
        ## buffer in a "proper" WSGI manner
        out = StringIO.StringIO()
        writer = avro.ipc.FramedWriter(out)
        writer.write_framed_message(response)

        start_response('200 OK', [('Content-Type', 'avro/binary')])
        return [out.getvalue()]

The only notable quirk with using Avro with a WSGI framework like
`eventlet.wsgi` is that some of Avro's "writer" code expects to be given a raw
socket to write a response to, so we give it a `StringIO` object to write to and
return that buffer's contents from `wsgi_handler`. The `wsgi_handler` function
above is "dumb" insofar that it's simply passing the Avro request object into the
"responder" which is responsible for doing the work:

    class EchoResponder(avro.ipc.Responder):
        def invoke(self, message, request):
            handler = 'handle_%s' % message.name
            if not hasattr(self, handler):
                raise Exception('I can\'t handle this message! (%s)' % message.name)
            return getattr(self, handler)(message, request)

        def handle_split(self, message, request):
            query = request['query']
            halfway = len(query) / 2
            return query[:halfway]

        def handle_echo(self, message, request):
            return request['query']


All in all, minus comments the server code is around 40 lines and fairly easy to
follow (refer to [server.py](http://github.com/rtyler/eventlet-avro-example/blob/master/server.py) for the complete version). I personally find Avro to be straight-forward enough and enjoyable to work with, being able to integrate it with my existing Eventlet-based stack is just icing on the cake after that.

If you're curious about some of the other work I've been up to with Eventlet, [follow me on GitHub](http://github.com/rtyler) :)
