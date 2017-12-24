# Jodd development in details

<%= render '/_deprecated.html' %>

Next pages will describe development of web applications in more details.
Here we will not use *Jodd* *Joy* application template. Instead, we will
build it from the scratch.

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
example. Also don't be mislead with the amount of
presented information - working with *Jodd* is simple, but not simpler.
{: .attn}

Ok, here goes a short overview of each step.

## Preparation

As for any web application, we need servlet container installed, such as
[Apache Tomcat][1]. We also assume that database server of
choice is already installed (e.g. [MySql][2] or [H2][3]
or [Oracle XE][4] or ...) and ready to use. If
not, than you can download [HSQLDB][5] or [H2DB][3],
 embedded database that require no installation.

This example needs just the following jars:

* latest `jodd-*.jar` (1.7 Mb)
* `slf4j-api-1.x.jar` and `slf4j-simple-1.x.jar` for logging (30K)
* jdbc connector or embedded database
* servlets jars (150K), only for compilation

Once you have set all this, you will be ready to continue.

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

## Bonus

### [Auth with interceptors](auth-with-interceptors.html) (10 min)

Control page access with *Madvoc* interceptors.

### [Tx over actions](tx-over-actions.html) (10 min)

Different architecture approach, just for fun... or real!?

[1]: http://tomcat.apache.org/
[2]: http://www.mysql.com/
[3]: http://www.h2database.com
[4]: http://www.oracle.com/technology/products/database/xe/index.html
[5]: http://hsqldb.org/
