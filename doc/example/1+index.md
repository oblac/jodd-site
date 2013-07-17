# Build web applications with Jodd

<div style="background:url(goal.jpg) no-repeat left; margin:40px 60px 40px 60px; padding: 10px 10px 10px 50px; font-size:1.3em; border: 1px solid #CCC;" markdown="1">
Goal to make: a skeleton for blazing fast web application, coded from
scratch in just **60** minutes, **0** XML files and starting with just
**1MB** of jar files. Service layer: may be used and tested outside of
web container, supports declarative transactions and is made of pure
POJOs. Database layer: supports entity mapping, uses native sql and
offers generic dao. Finally, skeleton has to be a frame for rapid
further development.
</div>

For complete, up-to-date, real-world example, with documented source, please check
[uphea](/uphea/index.html).
{: style="font-size:22px; color:#336; line-height: 26px; border: 2px solid #ccf; padding: 12px; font-weight:bold; margin: 36px;"}

This tutorial gives step-by-step instructions how to build web
application using *Jodd*. Along it also provides some best-practices
using *Jodd* frameworks.

This is just one way of how to build web applications with *Jodd*; what
matters here is the **concept** and not the concrete values, structures
or configuration used in example.
{: .example}

Attention: this example is not trivial one since it covers many
different topics of web development. It would be good if you have some
basic information about *Jodd* components before proceeding with the
example. The subject of the example is how to configure and prepare
infrastructure for development, so don't be mislead with the amount of
presented information - working with *Jodd* is simple, but not simpler.
{: .attn}

Here goes a short overview of each step.

## Preparation

As for any web application, we need servlet container installed, such as
[Apache Tomcat][1]{: .external}. We also assume that database server of
choice is already installed (e.g. [MySql][2]{: .external} or [H2][3]{:
.external} or [Oracle XE][4]{: .external} or ...) and ready to use. If
not, than you can download [HSQLDB][5]{: .external} or [H2DB][3]{:
.external}, embeded database that require no installation.

For this example, we need just the following jars:

* `jodd-*.jar` (&lt; 1.2 Mb)
* `asm-3.2.jar` (&lt; 40K)
* `slf4j-api-1.6.4` and `slf4j-simple-1.6.4.jar` (30K)
* jdbc connector or emebeded database
* servlets 2.5 jars (150K), only for compilation

Next, lets choose the architecture of our web application: we will have
three separated layers: view, services and data. Service layer is not
coupled with the presentation and may be executed (and tested) from the
command line, if needed. Transactions are therefore declared on service
layer. Data layer is written following DAO pattern. Presentation view is
just preparing and calling services and parsing results back.
All-in-all, nothing special, just a common three-layer web application.

## Get Things Done in 60 minutes

### [View with Madvoc](view-with-madvoc.html) (10 min)

Although presentation layer is usually not the first thing to develop,
we start this example with *Madvoc*.

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
