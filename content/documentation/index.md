# Documentation

## What can I expect from Jodd?

Take a deep breath and hold it:

> Developer-friendly experience + Excellent performance +
Small memory footprint and code-base; under <%= @config[:jodd][:size] %> MB +
Fast redeployments, matter of seconds + Web framework +
Lightweight DI container + Unique proxy creator +
Thin database layers + Template SQL + Transactions manager +
JSON (de)serialization +
Validation framework + HTML parser +
Decoration framework + Fastest bean library +
Type conversion +
Elegant and precise time class + Properties replacement +
Tiny HTTP client + Many carefully selected utilities... and more!

Now you can breath out :)

## About

[About Jodd](/about) - an effective one-page you will love :)

[Jodd overview in 5 minutes](http://oblac.github.io/jodd) - *Jodd* frameworks overview in 5 minutes.

[Jodd micro-frameworks in 30 minutes](http://joddframework.org) - example of using *Jodd* micro-frameworks.

## Jodd utilities

[BeanUtil](/beanutil) - fastest bean manipulation library around.

Cache - set of common cache implementation.

[Printf](/util/printf.html) - formatted value printing, as in C.

[JDateTime](/jdatetime) - elegant usage and astronomical precision in one time-manipulation class.

[Type Converter](/util/typeconverter.html) - converting types.

[StringUtil](/util/stringutil.html) - more then 100 of additional String utilities.

[StringTemplateParser](/util/stringtemplateparser.html) - simple string template parser.

[Finding, scanning, walking files](/util/findfile.html) - few easy ways.

[Class finder](/util/class-finder.html) - find classes on classpath.

[Wildcard](/util/wildcard.html) - using wildcards.

[Servlets](/util/servlets.html) - various servlets-related tools.

[Jodd tag library](/util/taglibrary.html) - new power to the JSP.

[Form tag](/util/formtag.html) - automagically populates forms.

[Class loading in Jodd](/util/class-loading-in-jodd.html) - great ways for loading classes.

[Fast buffers](/util/fast-buffers.html) - really fast appendable storage.

[Include-Exclude rules](/util/inc-exc-rules.html) - small rule engine for filtering resources.

[Dir Watcher](/util/dir-watcher.html) - watching directory for file changes.

## Jodd tools

[Email](/util/email.html) - sending and receiving emails.

[Props](/props) - enhanced `Properties` replacement.

[HTTP](/http) - tiny, raw HTTP client.

[Methref](/util/methref.html) - strongly-typed method name references.

## Jodd micro-frameworks

### Madvoc

Elegant web MVC framework that uses CoC in a pragmatic way to simplify web application development.

<%= doc_list_all(@item, '/madvoc/') %>

### Petite

Slick and lightweight DI container that supports sufficient most of features offered by other containers.

<%= doc_list_all(@item, '/petite/') %>

### Proxetta

The fastest proxy creator with unique approach for defying pointcuts and advices.

<%= doc_list_all(@item, '/proxetta/') %>

### DbOom

Efficient and thin layers that significantly simplifies writing of database code.

<%= doc_list_all(@item, '/db/') %>

### Json

Poweful JSON serializer and parser.

<%= doc_list_all(@item, '/json/') %>

### JTX

Enjoyable transaction manager.

<%= doc_list_all(@item, '/jtx/') %>

### Paramo

Extracts method and constructor parameter names.

<%= doc_list_all(@item, '/paramo/') %>

### VTor

Validation framework.

<%= doc_list_all(@item, '/vtor/') %>

### Lagarto

HTML parser.

<%= doc_list_all(@item, '/lagarto/') %>

### HtmlStapler

Transparent HTML resource bundles.

<%= doc_list_all(@item, '/htmlstapler/') %>

### Decora

Web decorator framework.

<%= doc_list_all(@item, '/decora/') %>

### CSSelly

CSS3 selectors parser.

<%= doc_list_all(@item, '/csselly/') %>

### Jerry

jQuery in Java.

<%= doc_list_all(@item, '/jerry/') %>

## Jodd Labs

[Jodd Joy](/joy) - Start coding your web applications right away, using best Jodd practices integrated into thin application layer.

## Misc

### Integration

[Jodd & OSGi](/util/osgi.html) - Learn how to use *Jodd* modules as OSGi bundles.

[Jodd as JBoss AS 7 module](/util/jodd-jboss7-module.html) - make JBoss module out of *Jodd* jars.

### Examples

[Uphea](/uphea/) - real-world web application example built on *Jodd* framework.

[Quickstart](/quickstart/) - start experiencing *Jodd* right away.

[Build web applications with Jodd](/example/index.html)
- tutorial that gives step-by-step instructions how to build web
application using *Jodd*. Along it also provides some best-practices
using *Jodd* frameworks.


### Tips, Tricks & Best practice

[Logging](/util/logging-jodd.html), make *Jodd* logs to your logging framework.

[Add to classpath](/util/add-classpath-in-runtime.html) with `ClassLoaderUtil` in runtime.

Learn how to [remove session id](/util/remove-session-id.html) from URL for more security.

*Jodd* can be used on [Android](/util/android.html), too!


### Performance

[Benchmarks](/util/performance.html) - overview of all available performance tests.


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
