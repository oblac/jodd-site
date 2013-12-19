# Jodd Joy

Are you building your web application with *Jodd* and want some more
*Joy* in your development? You are on the right place! *Jodd* *Joy* is an
application template built on *Jodd* that combines the best *Jodd*
practices with pragmatic approach, assuming requirements that, as we
think, match the most web applications out there.

So, if you are building a web app that uses one database with
transactions, that can be run out of web container, that needs I18N
support, has some resources protected, uses Ajax and JSON, and
validation; consider using *Joy* application template.

## Inside Joy

* `DefaultAppCore` - application initialization, for both stand-alone
  and web mode
* Various crypting coders and hashes (Threefish, MurmurhHash...)
* Authentication layer: interceptors, tags, action and utils.
* Common database `Entity` and generic `AppDao`.
* I18N tools
* Various *Madvoc* enhacements: json actions, post annotation,
  interceptors ...
* Database pager
* Validation tools

## Installation

Just put `jodd-joy.jar` on the classpath.

## Example

See [uphea](/uphea/index.html) - it is built with help of *Joy*.

## Note

In time, some *Joy* code might migrate to the main libraries.

