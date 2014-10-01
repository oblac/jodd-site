## [2014-10-01] Release v3.6.1

Everybody loves fixes and improvements.

FIXED
: **[lagarto]** Fixed parsing in some special case of truncated HTMLs.

FIXED
: **[lagarto-web]** Form tag now works with multipart requests.

NEW
: **[http]** Added `HttpProgressListener`.

NEW
: **[http]** Added method to force multipart requests.

NEW
: **[proxetta]** Added `targetMethodAnnotation()` and `targetClassAnnotation()`
macro methods for *Proxetta*.

NEW
: **[proxetta]** Pass classloader info to the `TargetClassInfoReader`.

CHANGED
: **[bean]** `propertyFieldPrefix` for `CachingIntrospector` is now array of strings.

NEW
: **[core]** Added `ClassMap`.

NEW
: **[core]** Added `DirWatcher`.

CHANGED
: **[core]** Removed `jodd.io.filter` package.

CHANGED
: **[core]** Method `StringUtil.substring` is now full safe.

CHANGED
: **[core]** Using smart mode for `FindFile` and configurators.

FIXED
: **[core]** `ClassFinder` don't throw exceptions if flag is set.

CHANGED
: **[mail]** Multiple addresses now could be added by repeated call to
address-related methods.

CHANGED
: **[mail]** Email address-related methods now accept two arguments:
for personal name and for email address. Moreover, they accept
`EmailAddress` and `InternetAddress`.

NEW
: **[madvoc]** *Madvoc* configuration `defaultActionName` changed
to `defaultActionResult` that accept `Class`.

CHANGED
: **[madvoc]** When `@RestAction` value starts with macro, add action
method name to the path.

NEW
: **[json]** Added loose mode for parsing.

FIXED
: **[json]** Fixed using integers in some cases for *Json* parser.

FIXED
: **[json]** Fixed parsing bug that may occur with long strings and late escapes.
{: .release}
