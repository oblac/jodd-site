# Decora

*Decora* is web decoration framework to help in creating sites
consisting of pages based on *templates*. This gives a consistent
look/feel, navigation and layout scheme. *Decora* intercepts requests,
process the content and merges it with decorator to create a final page
result.

*Decora* is based on [*Lagarto*](/doc/lagarto/index.html) parser and
therefore is very, very fast.

## Setup

Enable *Decora* filter in `web.xml`\:

~~~~~ xml
	<filter>
		<filter-name>decora</filter-name>
		<filter-class>jodd.decora.DecoraServletFilter</filter-class>
		<init-param>
			<param-name>decora.manager</param-name>
			<param-value>com.uphea.AppDecoraManager</param-value>
		</init-param>
	</filter>
	<filter-mapping>
		<filter-name>decora</filter-name>
		<url-pattern>/*</url-pattern>
	</filter-mapping>
~~~~~

Here we also defines custom `DecoraManager` instance. `DecoraManager` is
responsible if some request should be decorated and resolves decorator
path. By default, `DecoraManager` decorates all requests, all mime types
for all `*.html` action paths. Default decorator is
"`/decora/main.jsp`".

*Decora* may be used offline, too. It is not required to use it in web
environment.
{: .example}

## DecoraManager

`DecoraManager` does two things: determines what requests should be
decorated and resolves decorator path for requests. While determining
what requests should be decorated, there are following options:

* request in general
* content type, mime type, encoding
* status code

Resolving decorators path is very simple: for given request and action
path `DecoraManager` must return decorator path (or `null` if request
does not have to be parsed).

Here is an example of `DecoraManager` that decorates some additional
paths:

~~~~~ java
    public class AppDecoraManager extends DecoraManager {

    	@Override
    	public String resolveDecorator(
                HttpServletRequest request, String actionPath) {
    		if (actionPath.endsWith(".html")) {
    			return DEFAULT_DECORATOR;
    		}
    		if (Wildcard.match(actionPath, "/q/*")) {
    			return DEFAULT_DECORATOR;
    		}
    		return null;
    	}
    }
~~~~~

## Decorator

The decorator is a *template* that contains the common layout and style
that should be applied to some set of pages in the web application. In
decorator file you can define one or more *regions*.

*Decora* regions are defined using `decora` tags, for example:

~~~~~ html
    <!DOCTYPE html>
    <html>
    <head>
    	<title><decora:title>default title</decora:title></title>
    	... more javascript, css, meta etc.
    	<decora:head/>
    </head>
    <body>
    <div id="wrapper">
    	<decora:body/>
    </div>
    </body>
    </html>
~~~~~

Here we used custom decora tags.

*Decora* decorators may be static files or dynamic files, created using
technologies like JSP, freemarker, etc. *Decora* tags are simple text
tags.
{: .attn}

### Standard tags for regions

But this is not the only way how to create *Decora* regions. You can use
any standard HTML tag using *Decora* specific id, for example:

~~~~~ html
    <!DOCTYPE html>
    <html>
    <head>
    	<title><span id="decora-title">default title</span></title>
    	... more javascript, css, meta etc.
    	<decora:head/>
    </head>
    <body>
    <div id="wrapper">
    	<div id="decora-div-main"/>
    </div>
    </body>
    </html>
~~~~~

*Decora* specific id consist of three parts, separated by a dash:
`decora` prefix, tag name and, optionally, tag id. So

## Content regions

Region content is defined in a simple, non-decorated HTML page.

~~~~~ html
    <html>
    <head>
    	<title>Hello Jodd</title>
    	<meta name="description" content="cool jodd page">
    </head>
    <body>
    	<p>Hello <b>Jodd</b>!</p>
    </body>
    </html>
~~~~~

We defined here 3 regions:

* title - defined by \'`title`\' tag
* head - everything between \'`head`\' tags, not including other regions
  (therefore, excluding the \'`title`\').
* body - everything between \'`body`\' tags.

### Standard tags for regions

When decorator is defined using standard HTML tags, the content may be
defined like this:

~~~~~ html
    <html>
    <head>
    	<title>Hello Jodd</title>
    	<meta name="description" content="cool jodd page">
    </head>
    <body>
    	<div id="main">
    		Hello <b>Jodd</b>!
    	</div>
    </body>
    </html>
~~~~~

Note that the \'`main`\' region is defined by the `div` tag with
specified `id`.

## Result

The resulting content is decorator page merged with the content by
replacing region definitions with its content.

