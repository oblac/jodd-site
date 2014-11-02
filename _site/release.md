## [2014-11-02] Release v3.6.2

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

FIXED
: **[json]** Fix the lookup order of custom and default type serializers.

NEW
: **[core]** Added digest methods for files.

NEW
: **[http]** Added socket timeout to the API.

NEW
: **[http]** Added missing HTTP methods. Added few more convenient methods.

FIXED
: **[http]** Track removed cookies in `HttpBrowser`.

FIXED
: **[lagarto]** Fixed some parsing issues.

CHANGED
: **[http]** Upload is now memory-efficient.

NEW
: **[http]** Added upload monitor

FIXED
: **[lagarto]** Fixed JVM crash on `null` argument.

CHANGED
: **[madvoc]** Replaced *Madvoc* config flag `injectionErrorThrowsException` with `*Injector.silent`.

CHANGED
: **[core]** Making `BeanUtil` more silent with better performances.

CHANGED
: **[madvoc]** Removed `RequestScopeInjector.Config`. Breaking change!
{: .release}
