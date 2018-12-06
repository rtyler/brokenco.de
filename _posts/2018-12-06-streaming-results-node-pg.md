---
layout: post
title: "Streaming HTTP data with PostgreSQL and ExpressJS"
tags:
- javascript
- expressjs
- postgresql
---

One of the [little applications](https://github.com/jenkins-infra/uplink) which
I built earlier this year ended up more useful than I originally anticipated.
Useful enough to have hit its first performance bottleneck! Performance
problems I generally grumble "nice problem to have" which profiling and
refactoring, but in this case I know what the performance problem was, but
lacked the appropriate solution.

This little application, Uplink, receives anonymous telemetry information from
short-lived "trials" defined within the [Jenkins core
application](https://github.com/jenkinsci/jenkins). The entire end-to-end system is
defined by the design document
[JEP-214](https://github.com/jenkinsci/jep/blob/master/jep/214/README.adoc).
What the JEP does not describe is how we use and analyze the data on the other
end. At the moment the "data science" behind Uplink has been exporting large
dumps of JSON information from Uplink, and then bash scripting the heck out of
it. As time has gone on the amount of data ingested, and therefore exportable,
has increased quite a bit. This growth in data has required numerous iterations
on the "Export" functionality, whilst everything else remained largely
unchanged.

**First iteration**

The first cut at "export" functionality was as simple and straightforward as
possible:

1. Receive authorized "Export" HTTP request
1. Send the database `SELECT * FROM events WHERE ...`
1. Receive results
1. Format an HTTP response with the right `Content-Disposition` headers, etc.


This worked for much longer than I honestly thought it would. The Node
application lives close enough to the database to retrieve large datasets
within an HTTP timeout and deliver those to the client. Once the **total**
dataset exceeded a couple hundred megabytes, things stopped working.

**Second iteration**

The consumer of this data was, and still is a single person wielding bash
scripts a'plenty. To keep things as simple as possible, we changed the frontend
to require that any "Export" define a date range to export. Initially the Data
Scientist&trade; would request a whole week at a time, and when that started
working, would request individual daily exports instead. Eventually this too
stopped working, somewhere around a daily dataset size of a couple of hundred
megabytes.


**Third iteration**

Clearly loading big stupid `SELECT * FROM` result sets into the application to
format and serve them to clients was not scalable. For the third iteration I
resolved to implement a direct stream from the database through the web
application to the client. In effect, I wanted the PostgreSQL database
connection to give me results _immediately_ which would then be written
directly to the HTTP output stream; no in-memory storage.

I discovered a very useful Node package to solve the first part of the problem:
[pg-query-stream](https://github.com/brianc/node-pg-query-stream/#pg-query-stream).
The pg-query-stream package uses a database-side cursor to avoid the need to
create large datasets in memory on the database or web application.

The "trick", which to be honest isn't a very incredible trick since Node
streams are designed to be pluggable in this way, was to connect the
`pg-query-stream` directly to ExpressJS `Response` which looks like a writable
stream. To form a proper HTTP response, the ExpressJS handler must first write
the response code and headers, for which `response.send()` will not work, so
`response.writeHead` is used instead:


```javascript
const query = new QueryStream('SELECT * FROM events WHERE ...');
const datastream  = dbConnection.query(query);

response.writeHead(200, {
    'Content-Disposition' : `attachment; filename=${req.body.type}-${req.body.startDate}.json`,
    'Content-Type': 'application/json',
});

/*
 * Pipe the data to JSONStream to convert to a proper JSON string first.
 *
 * Once it has been formatted, _then_ pipe to the ExpressJS response object
 */
datastream.pipe(JSONStream.stringify(false)).pipe(response);
datastream.on('end', () => { response.end(); ])
```
(_You can view the actual code used [here](https://github.com/jenkins-infra/uplink/blob/7a4b6377552d901b850c4c39570a67dd86b0a209/src/controllers/export.ts#L19-L32)_)

---

This approach is, as far as I can tell, "infinitely" scalable. So long as the
database can stream data to the Node application, the Node application will
continue to write data into the response for the end-user.

I was so worried that I was going to have to find some way to generate bulk
files on the server with some background job processing system, or something
else equally complex. I'm thrilled that the solution simply required connecting
one streamy thing to another streamy thing, which Node is quite well suited
for.

Neat!

