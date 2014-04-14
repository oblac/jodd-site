## [2014-03-27] Release v3.5.1

This release is full of small changes, fixes and improvements.

CHANGED
: Remove all `*AndClose()` *DbOom* methods and add `autoClose()` mode instead.

FIXED
: Improved `setPreparedStatementObject()` in *DbOom*.

CHANGED
: Join few classes to `PreparableInterceptor` in *Madvoc*.

NEW
: `Printf` improved (contribution!).

NEW
: Added support for trailers headers in chunked transfer for *HTTP*.

NEW
: Added `ParsedSql` holder and removed chunks cache in *DbOom*.

NEW
: Added `getSetterRawComponentType()` to `Setter`.

NEW
: Added `CollectionConverter` in type converter tool. Added `convertToCollection()` method, too.

NEW
: Added log in *Madvoc* when injection fails, or throw an exception.

NEW
: Method `hasRootProperty()` added to `BeanUtil`.

CHANGED
: *Madvoc* `@Actions.method()` is now case-insensitive.

CHANGED
: More *Madvoc* internals have been refactored and optimized.

NEW
: *Madvoc* action methods now can have arguments!

CHANGED
: *Madvoc* injectors refactored, added `Injector` and `Outjector` interface and
new `InjectorManager` component.

CHANGED
: Removed `@In.remove()` and `@In.create()` in *Madvoc*.

NEW
: `ServletDispatcherResult` now supports multiple extensions: `jspf` and `jsp`.
Added `AbstractTemplateViewResult` as base template *Madvoc* result.

FIXED
: Fixed NPE in *HTTP* when response body is `null` and when 'Content-Length'
is missing.
{: .release}
