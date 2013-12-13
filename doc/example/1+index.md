# Build web applications with Jodd

<div class="doc1"><js>doc1('example',22)</js></div>
Let's build a skeleton for blazing fast web application, coded from scratch in
less then **60** minutes, with **0** XML files and starting with less then
**1.5 MB** of jar files. Make a service layer that can be used and tested 
outside of web container, have support for declarative transactions and use
pure POJOs. For database layer: support entity mapping, uses native SQL
and build generic DAO. This example may be a good start for your future
developments :)


## Other Examples

If you have less time or you want to jump right into the *Jodd* you might
consider trying: [Jodd QuickiStart](http://jodd.org/doc/quickstart/index.html).
This is a collection of empty, but predefined collections, build with
some or all *Jodd* frameworks. 

On the other hand, if you want more complex, real-world example, you might
check [Uphea](/uphea/index.html). It's an example of real web application,
so you can analyze all kind of different *Jodd* usages.


## About

This tutorial gives easy-to-follow step-by-step instructions how to build web
application using *Jodd*. Along it provides some best-practices
for using *Jodd* frameworks.

This is just one way of how to build web applications with *Jodd*; what
matters here is the **concept** and not the concrete values, structures
or configuration used in example.

Attention: this example is easy, but not trivial; it covers many
different topics of web development. It would be good if you have some
basic information about *Jodd* components before proceeding with the
example. The goal of the example is to configure *Jodd* microframeworks
for development. Don't be mislead with the amount of
presented information - working with *Jodd* is simple, but not simpler.
{: .attn}

Ok, here goes a short overview of each step.

## Preparation

As for any web application, we need servlet container installed, such as
[Apache Tomcat][1]{: .external}. We also assume that database server of
choice is already installed (e.g. [MySql][2]{: .external} or [H2][3]{:
.external} or [Oracle XE][4]{: .external} or ...) and ready to use. If
not, than you can download [HSQLDB][5]{: .external} or [H2DB][3]{:
.external}, embedded database that require no installation.

For this example, we need just the following jars:

* `jodd-*.jar` (&lt; 1.3 Mb)
* `slf4j-api-1.x.jar` and `slf4j-simple-1.x.jar` (30K)
* jdbc connector or embedded database
* servlets 2.5 jars (150K), only for compilation

Next, lets divide our web application in three separated layers: view, services and data. Service layer is not
coupled with the presentation and may be executed (and tested) from the
command line, if needed. Transactions are therefore declared on service
layer. Data layer is written following DAO pattern. Presentation view is
just preparing and calling services and parsing results back.

## Get Things Done in 60 minutes

### [View with Madvoc](view-with-madvoc.html) (10 min)

Although presentation layer is usually not the first thing to develop,
we start this example with introduction to *Madvoc*.

### [Serve with Petite](serve-with-petite.html) (15 min)

After adding the basic view layer skeleton, we can continue with the
real stuff: the business layer. We will organize business components
using *Petite*.

### [Store with Db](store-with-db.html) (20 min)

It's time for data! Let's combine the power and simplicity in one,
using *Db* and *DbOom*.

### [Tx with Proxetta](transactions-with-proxetta.html) (15 min)

Wrap services with transactions handling code using *Proxetta*.

## Bonuses

### [Auth with interceptors](/doc/example/auth-with-interceptors.html) (10 min)

Control page access with *Madvoc* interceptors.

### [Tx over actions](/doc/example/tx-over-actions.html) (10 min)

Different architecture approach, just for fun... or real!?

[1]: http://tomcat.apache.org/
[2]: http://www.mysql.com/
[3]: http://www.h2database.com
[4]: http://www.oracle.com/technology/products/database/xe/index.html
[5]: http://hsqldb.org/
