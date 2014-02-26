# Jodd Joy

Are you building your web application with *Jodd* and want some more
*Joy* in your development? You are on the right place! *Jodd* *Joy* is an
application template built on *Jodd* that combines the best *Jodd*
practices with pragmatic approach, assuming requirements that, as we
think, match the most web applications out there.

If you are building a web app that uses one database with
transactions, that can be run out of web container, that needs I18N
support, has some resources protected, uses Ajax and JSON, and
validation; consider using *Joy* application template.

Parts of *Joy* code might migrate to the main libraries once
they become mature.
{: .attn}

## With Joy...

### AppCore

The core class that starts all *Jodd* frameworks and configures them 
to work together.

### Authentication layer

Authentication and simple authorization layer, ready to be used.
It consist of few interceptors, tags, actions and utilities.

### AppDao

*Petite* ready component, based on `GenericDao` but with an
id generator included.

### Madvoc

There are few *Madvoc* addons: JSON actions, Post annotation,
some interceptors...

### JSPP

Preprocessor for JSPs. Works better then static JSP include
as you can provide arguments.

### Db Pager

Database pager - semi automatic tool that will page your queries.

### And more...

* Various crypting coders and hashes (Threefish, MurmurhHash...)
* I18N tools
* Validation tools

## Installation

Just put `jodd-joy.jar` on the classpath or as the dependency.

## Example

See [uphea](/uphea/index.html) - it is built with help of *Joy*.

