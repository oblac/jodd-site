# How HtmlStapler works?

<div class="doc1"><js>doc1('htmlstapler',22)</js></div>
Each HTML page is parsed (using **fast** *Lagarto* parser) and all
javascript and CSS links are collected. The first resource link of the
same type (javascript/css) is replaced with a link to
`HtmlStaplerServlet`. All other links of the same type are removed from
the page.

After parsing, *HtmlStapler* copies the content of all collected links
into a single file, called the **bundle** file. These bundle files,
therefore, contains the content of all javascript/CSS (i.e. resource)
files that a page loads.

In other words, each set of resource files is wrapped in its unique
single bundle file. If two pages loads the same resource files, they
will share the same bundle file. The order of resources on page is
important (by default) i.e. if two pages load the same resources in
different order, they will not share the same bundle (this is
configurable, however).

Each bundle has its own unique id, a **bundle id**. It is actually a
SHA-256 digest of the string that contains all resource links. Bundle id
is also a file name of the bundle file stored on file system.

Resource content is downloaded/copied as it is, without any
modification. Anyhow, *HtmlStapler* provides a hook to additionally
process this content. For example, javascript and CSS can be minimized
with some 3rd party tool before stored in a bundle file.

Once bundle files are stored on file system, they will be recognized
next time when server is (re)started. Therefore, bundle files will be
not created again if a bundle file with the same bundle id (i.e. the
file name) already exist on file system. To enforce new bundles on each
server start, call `reset()` method after `HtmlStaplerBundlesManager` is
created.

## Working Strategies

*HtmlStapler* may work in two ways, i.e. strategies, called
`ACTION_MANAGED` and `RESOURCES_ONLY`. The difference is if the relation
between page url and its bundle id is stored in memory, or if bundle id
is resolved each time per page.

## ACTION\_MANAGED strategy

In this strategy, bundles manager (a component of *HtmlStapler*) saves
relation between page and its resource bundles. For each request action
path, resolved bundle ids are stored in memory, so next time when page
is called there will be no additional processing at all.

First time when bundle is created, the page is fully parsed and the
bundle receives a temporary id (a simple number) that is used on very
first page loading. From that point, *HtmlStapler* binds the real bundle
id to the action path and all further page loads will use real bundle
id.

`ACTION_MANAGED` strategy stores relations between bundle files and
requested pages. This strategy gives top performances, but consumes
memory. Be careful if web application has big number of dynamic links -
`OutOfMemoryException` may be thrown at some point in time.
{: .attn}

### Reducing memory usage

*HtmlStapler* stores bundle id for each action path i.e. page of web
application. Since many pages share the same resources, they will also
share the same bundle id instances.

However, some web applications use REST-like urls for the same page, but
for different content. For example, a web application that shows daily
forecast, might have urls like: `/weather/2011/10/28/SanFrancisco`. The
number of such urls may be virtually infinitely, so *HtmlStapler* may
throw `OutOfMemoryException` at one point.

To solve this issue within this strategy, user should override
`resolveRealActionPath()` and return the main action path for dynamic
ones, i.e. `/weather.html`.

## RESOURCE\_ONLY strategy

In this strategy, bundles manager doesn't store relations between page
and bundle ids. Instead, the bundle id is resolved each time page is
called from collected set of links. Of course, bundle file is created
just for the first time, if it already does not exist on the file system
under the same bundle name.

`RESOURCE_ONLY` strategy resolves bundle id every time page is loaded.
This is very pragmatic strategy that gives slightly slower performances,
but there is no additional memory consumption.
{: .attn}

