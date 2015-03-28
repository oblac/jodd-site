# Documentation

## What can I expect from Jodd?

Take a deep breath and hold it:

> Developer-friendly experience + Excellent performance +
Small memory footprint and code-base; under 1.5 MB +
Fast redeployments, matter of seconds + Elegant web framework +
Slick and lightweight DI container + The fastest and unique proxy creator +
Efficient and thin database layers + Transactions manager +
Powerfull and fast JSON (de)serialization +
Focused validation framework + Fast and versatile HTML parser +
Decoration framework based on templates + Fastest bean library +
Type conversion +
Elegant and precise time class + Powerful properties replacement +
Tiny and raw HTTP client + Many carefully selected utilities... and more!

Now you can breath out :)

## About

[About Jodd](/about) - an effective one-page you will love :)

[Jodd overview in 5 minutes](http://oblac.github.io/jodd) - *Jodd* frameworks overview in 5 minutes.

[Jodd micro-frameworks in 30 minutes](http://joddframework.org) - example of using *Jodd* micro-frameworks.

[Jodd modules](modules.html) - learn how *Jodd* is organized into the modules.

## Jodd utilities

[BeanUtil](beanutil.html) - fastest bean manipulation library around.

Cache - set of common cache implementation.

[Printf](printf.html) - formatted value printing, as in C.

[JDateTime](jdatetime.html) - elegant usage and astronomical precision in one time-manipulation class.

[Type Converter](typeconverter.html) - converting types.

[StringUtil](stringutil.html) - more then 100 of additional String utilities.

[StringTemplateParser](stringtemplateparser.html) - simple string template parser.

[Finding, scanning, walking files](findfile.html) - few easy ways.

[Class finder](class-finder.html) - find classes on classpath.

[Wildcard](wildcard.html) - using wildcards.

[Servlets](servlets.html) - various servlets-related tools.

[Jodd tag library](taglibrary.html) - new power to the JSP.

[Form tag](formtag.html) - automagically populates forms.

[Class loading in Jodd](class-loading-in-jodd.html) - great ways for loading classes.

[Fast buffers](fast-buffers.html) - really fast appendable storage.

[Include-Exclude rules](inc-exc-rules.html) - small rule engine for filtering resources.

[Dir Watcher](dir-watcher.html) - watching directory for file changes.

## Jodd tools

[Email](email.html) - sending and receiving emails.

[Props](props.html) - enhanced `Properties` replacement.

[HTTP](http.html) - tiny, raw HTTP client.

[Methref](methref.html) - strongly-typed method name references.

[SwingSpy](swingspy.html) - inspection of swing component hierarchy.

## Jodd micro-frameworks

### Madvoc

Elegant web MVC framework that uses CoC in a pragmatic way to simplify web application development.

<%= doc_list_all(@item, '/doc/madvoc/') %>

### Petite

Slick and lightweight DI container that supports sufficient most of features offered by other containers.

<%= doc_list_all(@item, '/doc/petite/') %>

### Proxetta

The fastest proxy creator with unique approach for defying pointcuts and advices.

<%= doc_list_all(@item, '/doc/proxetta/') %>

### DbOom

Efficient and thin layers that significantly simplifies writing of database code.

<%= doc_list_all(@item, '/doc/db/') %>

### Json

Poweful JSON serializer and parser.

<%= doc_list_all(@item, '/doc/json/') %>

### JTX

Enjoyable transaction manager.

<%= doc_list_all(@item, '/doc/jtx/') %>

### Paramo

Extracts method and constructor parameter names.

<%= doc_list_all(@item, '/doc/paramo/') %>

### VTor

Validation framework.

<%= doc_list_all(@item, '/doc/vtor/') %>

### Lagarto

HTML parser.

<%= doc_list_all(@item, '/doc/lagarto/') %>

### HtmlStapler

Transparent HTML resource bundles.

<%= doc_list_all(@item, '/doc/htmlstapler/') %>

### Decora

Web decorator framework.

<%= doc_list_all(@item, '/doc/decora/') %>

### CSSelly

CSS3 selectors parser.

<%= doc_list_all(@item, '/doc/csselly/') %>

### Jerry

jQuery in Java.

<%= doc_list_all(@item, '/doc/jerry/') %>

## Jodd Labs

[Jodd Joy](joy) - Start coding your web applications right away, using best Jodd practices integrated into thin application layer.

## Misc

### Integration

[Jodd & OSGi](osgi.html) - Learn how to use *Jodd* modules as OSGi bundles.

[Jodd as JBoss AS 7 module](jodd-jboss7-module.html) - make JBoss module out of *Jodd* jars.

### Examples

[Uphea](/uphea/index.html) - real-world web application example built on *Jodd* framework.

[Quickstart](quickstart/index.html) - start experiencing *Jodd* right away.

[Build web applications with Jodd](example/index.html)
- tutorial that gives step-by-step instructions how to build web
application using *Jodd*. Along it also provides some best-practices
using *Jodd* frameworks.


### Tips, Tricks & Best practice

[Logging](logging-jodd.html), make *Jodd* logs to your logging framework.

[Add to classpath](add-classpath-in-runtime.html) with `ClassLoaderUtil` in runtime.

Learn how to [remove session id](remove-session-id.html) from URL for more security.

*Jodd* can be used on [Android](android.html), too!


### Performance

[Benchmarks](performance.html) - overview of all available performance tests.


### Reports

[Jodd API](/api/index.html) javadoc.

[Test results](/test/index.html).

[Coverage reports](/test/coverage-report/index.html).


## About Documentation

We put big effort to produce quality documentation.
*Jodd* documentation covers core concepts of *Jodd* micro frameworks
in depth, but also gives overview and examples for many tools.

Although we are trying hard to keep documentation up to date with the
code base, there may be differences between how code works
and whats described.
{: .attn}

Documentation is written in **kramdown** (excellent markdown extension).
You can find and even read our documentation on
[GitHub](https://github.com/oblac/jodd-site), too. Feel free to contribute!

Need more documentation on certain topics? Don't hesitate to ask for it!

Thank you!
