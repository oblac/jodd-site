# History

Recent history, release notes and previous releases.

<%= @items['/partials/release.md'].compiled_content %>

## 2016-03-24 Release v3.7.x

Release 3.7.

## 2015-11-11 Release v3.6.7

Release 3.6.7 is very different. This is mainly a bug-fix on our way to 3.7.
However, we have one more change: Java version bumped up to 7!!!

FIXED
: **http** Fixed encoding with multipart requests.

NEW
: **util** Added some `StringUtil` methods.

CHANGED
: **madvoc** Class loading exception loosened.

CHANGED
: **util** Extended Class loader has been significantly improved.

CHANGED
: **http** Replaced the `HttpValuesMap` with `HttpMultiMap`.

CHANGED
: **mail** Added ParseEML class.

NEW
: **util** Added `BeanWalker`.

CHANGED
: **util** Removed sort.

FIXED
: **json** Fixed special case in parsing.

NEW
: **util** Enhanced `StringTemplateParser` to support macros with just $.

NEW
: **json** Added `FileJsonTypeSerializer`.

NEW
: **json** Added set serialization.

NEW
: **util** Added `ZipBuilder`.

FIXED
: **util** Fixed boolean `printf`.

NEW
: **json** Make JSON parser to be aware of JSON annotations.

FIXED
: **util** Fixed BCrypt.

NEW
: **util** Added `PBKDF2Hash` and `MurmurHash3`.

NEW
: **props** Added method to get profiles list.

NEW
: **util** Added method to parse internet time.

FIXED
: **dboom** Fixed issues with hints and collections.

FIXED
: **util** Fixed `Unsafe` handling.

NEW
: **vtor** Added message to validation annotation.

FIXED
: **petite** Fixed Petite wiring.

FIXED
: **lagarto** Fixed handling of naked ampersends.

FIXED
: **http** Better handling of the HTTP connections.
{: .release}

## 2015-05-25 Release v3.6.6

It seems that this month we cleaned up some important bugs,
thanks to our awesome community!

FIXED
: **http** Fixed special case when content-length and chunked encoding exists.

NEW
: **util** `getResourceAsStream` now has a boolean argument to disable the cache.

CHANGED
: **util** Zip methods now returns resulting zip `File`.

FIXED
: **methref** Fixed parallel access, added `Pathrefs`.

FIXED
: **mail** Fixed parsing with `MailAddress`.

NEW
: **mail** Added `startTlsRequired` and `plaintextOverTLS()`.

NEW
: **mail** Added debug mode option and strict email address flag.

CHANGED
: **bean** `BeanCopy` got some slight modifications and improvements.

CHANGED
: **madvoc** Execution of inteceptors, filters and actions is significantly simplified.
{: .release}


## 2015-03-21 Release v3.6.5

It seems that this month we cleaned up some important bugs,
thanks to our awesome community!

NEW
: **http** `HttpBrowser` now accepts local path on 30x.

NEW
: **http** Added default headers to `HttpBrowser`.

FIXED
: **madvoc** Fixed action string in case of proxified classes.

FIXED
: **servlet** Reset `content-length` in GZip stream.

FIXED
: **lagarto** Reset `content-length` in *Lagarto* filter.

FIXED
: **decora** Reset `content-length` in *Decora* filter.

NEW
: **htmlstapler** Added `randomDigestChars` option to bundles manager.

NEW
: **bean** Added methods to `BeanCopy` for better fluent interface.

NEW
: **bean** Added `BeanUtil#setProperty` with all options as arguments.

CHANGED
: **bean** Removed `this*` reference.

NEW
: **props** Added extracting of inner map in the *Props*.
{: .release}


## 2015-02-05 Release v3.6.4

Another month, another fix-pack. This time, however, we have some number of
changes, so please be sure to go over the list.

NEW
: **mail** Method `sendMail()` now returns MessageID.

CHANGED
: **proxetta** Removed hierarchy level from `MethodInfo`.

FIXED
: **proxetta** Using ASM5 all the way, fixed issues with default methods on Java8.

CHANGED
: **core** Small change with `getComponentType()`, added index.

CHANGED
: **core** `RandomStringUtil` changed to `RandomString` class.

CHANGED
: **core** `ValueHolder` is now an interface; added `ValueProvider`.

FIXED
: **http** Added support for `Numbers` and `Booleans` as form objects.

FIXED
: **core** Fixed `isHostUnix()` false positive value on Mac OS X.

CHANGED
: **servlet** Updated `ServletUtil` to read parameter values in a proper way.

FIXED
: **lagarto** Added support for `String[]` in the `FormTag`.

FIXED
: **proxetta** Fixed casting issue and classes with default packages.

FIXED
: **gradle** BOM file was empty

FIXED
: **servlets** Fix `GzipResponseWrapper` for Servlets 3.1 by adding method `setContentLengthLong()`.

FIXED
: **json** Fixed special case when using custom annotations and strict mode.
{: .release}


## 2009-05-05 Release v3.0

*Jodd* started new life on new web address: http://jodd.org
{: .release}
