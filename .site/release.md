## [2014-02-21] Release v3.5

After two months of heavy work, sweat and tears, we
released a new, shiny version of Jodd. It's hard
to summarize all the effort in just few words; so let's say we
hope new Jodd works more beautiful then ever before.
We would also love to thank all our contributors -
without them Jodd would not be this good.

This release contains some major changes, but nothing too dramatic
not to upgrade:) Do not hesitate to contact us for any reason.

FIXED
: Generated table references appends '_' in *DbOom*.

NEW
: Added `GenericDao` to *DbOom*.

NEW
: Added `@DbMapTo` annotation (incubation feature).

CHANGED
: `ReferenceMap` removed.

NEW
: Added JSPP - JSP pre-processor (incubation feature).

CHANGED
: Result paths now include the path as well! ATTENTION: your app
may break if you were using `#` in your results - try to put one
more `#`, since there is one more path chunk to skip.

CHANGED
: Removed default aliases in *Madvoc*.

CHANGED
: Removed `ActionPathMapper` in *Madvoc*.

NEW
: Added `Result` to *Madvoc* for easier referencing target paths.

CHANGED
: `Methref` simplified.

CHANGED
: `ActionResult#render` significantly simplified.

CHANGED
: Removed `@Action#result` as not really needed for *Madvoc*.

NEW
: Added `@RenderWith` annotation fro *Madvoc*. Return values
now can specify result class.

CHANGED
: In *Madvoc*, `ActionResult` is not interface any more.

FIXED
: Fixed some encoding-related issues with email addresses.

NEW
: Added 'keep-alive' support for *Http*.

NEW
: Added `RequestScope` for *Petite*.

NEW
: `Printf` has new `0b` prefix.

FIXED
: Some `Printf` issues with printing and rounding float numbers fixed.

CHANGED
: Removed `DefaultScope` setting for *Petite*.

NEW
: Added destroyable methods for *Petite*.

CHANGED
: Added `SessionMonitor` instead of `SessionMapListener`.

FIXED
: Fixed some gzip encoding problems with *Http*.

CHANGED
: Removed *Madvoc* supplement actions as they may fill up the memory.

NEW
: Added copy operator for *Props*.

NEW
: Added `useActiveProfilesWhenResolvingMacros` for *Props*.

NEW
: Minor change in `GZipFilter`, allow to match all extensions.

NEW
: *Http* supports various PROXYs.

CHANGED
: `SessionScope` now works only with `RequestContextListener`!

NEW
: Added connection provider for *Http*.

NEW
: Added <var>jodd-log</var> module and removed direct dependency on 'slf4j'.
Now all logging is done via our module.

CHANGED
: Removed bean loaders. Use `BeanCopy` tool instead.

CHANGED
: Removed JSP functions. There were too many functions, users instead should
define custom JSP functions using our utilities.
{: .release}
