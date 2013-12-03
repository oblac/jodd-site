## [2013-12-03] Release v3.4.9

If we have to choose one word to describe this release, that would be **optimization**. We did many changes under the hood, to optimize
performances and reduce memory usage.

NEW
: Added new flag to `LagartoDOMBuilder` for log level of parsing errors.

CHANGED
: The whole **interceptor** API has been revamped. Now data is stored
in significantly less space. `BeanUtil` modified to use changed code.

CHANGED
: `AccessibleIntrospector` renamed to `CachedInterceptor` that now can be configured instead.

FIXED
: Added content length detection for **Http**.

NEW
: Added `changeTimeZone` to `JDateTime` for convenient time zone traveling.

FIXED
: Test have been fixed to work in different eniroments, like Travis.

FIXED
: `CSSelly` definition of CSS pseudo functions fixed to match standards.

NEW
: Added `select` method to `NodeSelector` that accept pre-compiled CSS selectors.

NEW
: Added `JoddArrayList`, better `ArrayList` that can grow in both directions (but not circular).

FIXED
: `URLDecoder` now has two methods for decoding query and the rest of the URI.

FIXED
: Fixed `FileUploadHeader.getFileName()` to return correct name.

NEW
: **Props** keys are now ordered! Added powerful iterator to **Props**.

FIXED
: **Email** fields for FROM, TO, CC etc supports I18N names.

FIXED
: Characters in **Props** keys now can be escaped, too.

NEW
: `HttpBrowser` now detects status codes 303 and 307.
{: .release}
