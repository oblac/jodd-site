# Documentation

Welcome to *Jodd* documentation! *Jodd* project goes to much effort
to produce the best documentation possible. Documentation consist of
core concepts explained in depth, but also with simple examples or overview
of existing tools. It also examples on performing common tasks, such
setting up frameworks, build project etc.

Documentation is written in **kramdown** (excellent markdown extension).
You can find and even read our documentation on [GitHub](https://github.com/oblac/jodd-site).
Feel free to contribute!

Please browse [API](/api/index.html) for more information and examine
test-cases for more examples. Do not hesitate to [contact support](../contact.html)
for [more documentation](needmore.html) on specific subject!

We are trying hard keep documentation to up to date with current code;
still be aware that there may be some differences between how code works
and whats described here. If you notice such flaws, please let us know;
we will fix it for you!
{: .attn}

Need more documentation on certain topics? [Ask for it!](needmore.html)


## Search

Some documentation is stored in [JavaDoc](/api/index.html). Since there are large
number of utilities and tools in *Jodd*, the best way to find something
is to search the API for it. Just enter below what you are looking for:

<form action="http://jodd.org/sphider/search.php" method="GET" class="para">
<input type="text" name="query" value="" style="border: 1px solid #888;
font-size:1.6em; padding:4px; background-color:#F0F0F0; color: #555;
width: 550px; margin-left: 50px;"> <input type="hidden" name="search" value="1" />
<input type="submit" value="Search!" style="border: 2px solid #666; padding:8px;"/>
</form>

## Table of Contents

<div markdown="1" style="padding-left:40px; padding-right:40px;" id="doc">
About Jodd.

### Jodd utilities

[BeanUtil](/doc/beanutil.html) - fastest bean manipulation library around.

Cache - set of common cache implementation.

[Printf](/doc/printf.html) - formatted value printing, as in C.

[JDateTime](/doc/jdatetime.html) - elegant usage and astronomical precision in one time-manipulation class.

[Email](/doc/email.html) - sending and receiving emails.

[Props](/doc/props.html) - enhanced `Properties` replacement.

[Type Converter](/doc/typeconverter.html) - converting types.

[StringUtil](/doc/stringutil.html) - more then 100 of additional String utilities.

[StringTemplateParser](/doc/stringtemplateparser.html) - simple string template parser.

[Finding, scanning, walking files](/doc/findfile.html) - few easy ways.

[Class finder](/doc/class-finder.html) - find classes on classpath.

[Wildcard](/doc/wildcard.html) - using wildcards.

[Servlets](/doc/servlets.html) - various servlets-related tools.

[Jodd tag library](/doc/taglibrary.html) - new power to the JSP.

[Form tag](/doc/formtag.html) - automagically populates forms.

[Reference Map and Set](/doc/reference-map-set.html) - reference aware map and set.

[Class loading in Jodd](/doc/class-loading-in-jodd.html) - great ways for loading classes.

[Fast buffers](/doc/fast-buffers.html) - really fast appendable storage.

[HTTP](/doc/http.html) - tiny, raw HTTP client.

### Madvoc

Elegant web MVC framework that uses CoC in a pragmatic way to simplify web application development.

<js>doc1('madvoc')</js>

### Petite

Slick and lightweight DI container that supports sufficient most of features offered by other containers.

<js>doc1('petite')</js>

### Proxetta

The fastest proxy creator with unique approach for defying pointcuts and advices.

<js>doc1('proxetta')</js>

### DbOom

Efficient and thin layers that significantly simplifies writing of database code.

<js>doc1('db')</js>

### JTX

Enjoyable transaction manager.

<js>doc1('jtx')</js>

### Paramo

Extracts method and constructor parameter names.

<js>doc1('paramo')</js>

### VTor

Validation framework.

<js>doc1('vtor')</js>

### Lagarto

HTML parser.

<js>doc1('lagarto')</js>

### HtmlStapler

Transparent HTML resource bundles.

<js>doc1('htmlstapler')</js>

### Decora

Web decorator framework.

<js>doc1('decora')</js>

### CSSelly

CSS3 selectors parser.

<js>doc1('csselly')</js>

### Jerry

jQuery in Java.

<js>doc1('jerry')</js>


### Misc

[Methref](/doc/methref.html) - strongly-typed method name references.

[SwingSpy](/doc/swingspy.html) - inspection of swing component hierarchy.

### Examples

[Uphea](/uphea/index.html) - real-world web application example built on *Jodd* framework.

[Quickstart](/doc/quickstart/index.html) - start experiencing *Jodd* right away.

[Build web applications with Jodd](example/index.html)
- tutorial that gives step-by-step instructions how to build web
application using *Jodd*. Along it also provides some best-practices
using *Jodd* frameworks.


### Tips, Tricks & Best practice

[Logging](/doc/logging-jodd.html), make *Jodd* logs to your logging framework.

[Add to classpath](/doc/add-classpath-in-runtime.html) with `ClassLoaderUtil` in runtime.

Learn how to [remove session id](/doc/remove-session-id.html) from URL for more security.

*Jodd* can be used on [Android](/doc/android.html), too!


### Performance

[Benchmarks](performance.html) - overview of all available performance tests.


### API

[Jodd API](/api/index.html) javadoc.

</div>