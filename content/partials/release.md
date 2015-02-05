## \[2015-02-05\] Release v3.6.4

Another month, another fix-pack.

NEW
: **\[mail\]** Method `sendMail()` now returns MessageID.

CHANGED
: **\[proxetta\]** Removed hierarchy level from `MethodInfo`.

FIXED
: **\[proxetta\]** Using ASM5 all the way, fixed issues with default methods on Java8.

CHANGED
: **\[core\]** Small change with `getComponentType()`, added index.

CHANGED
: **\[core\]** `RandomStringUtil` changed to `RandomString` class.

CHANGED
: **\[core\]** `ValueHolder` is now an interface; added `ValueProvider`.

FIXED
: **\[http\]** Added support for `Numbers` and `Booleans` as form objects.

FIXED
: **\[core\]** Fixed `isHostUnix()` false positive value on Mac OS X.

CHANGED
: **\[servlet\]** Updated `ServletUtil` to read parameter values in a proper way.

FIXED
: **\[lagarto\]** Added support for `String[]` in the `FormTag`.

FIXED
: **\[proxetta\]** Fixed casting issue and classes with default packages.

FIXED
: **\[gradle\]** BOM file was empty

FIXED
: **\[servlets\]** Fix `GzipResponseWrapper` for Servlets 3.1 by adding method `setContentLengthLong()`.

FIXED
: **\[json\]** Fixed special case when using custom annotations and strict mode.
{: .release}
