## \[2015-11-11\] Release v3.6.7

Release 3.6.7 is very different. This is mainly a bug-fix on our way to 3.7.
However, we have one more change: Java version bumped up to 7!!!

FIXED
: **\[http\]** Fixed encoding with multipart requests.

NEW
: **\[util\]** Added some `StringUtil` methods.

CHANGED
: **\[madvoc\]** Class loading exception loosened.

CHANGED
: **\[util\]** Extended Class loader has been significantly improved.

CHANGED
: **\[http\]** Replaced the `HttpValuesMap` with `HttpMultiMap`.

CHANGED
: **\[mail\]** Added ParseEML class.

NEW
: **\[util\]** Added `BeanWalker`.

CHANGED
: **\[util\]** Removed sort.

FIXED
: **\[json\]** Fixed special case in parsing.

NEW
: **\[util\]** Enhanced `StringTemplateParser` to support macros with just $.

NEW
: **\[json\]** Added `FileJsonTypeSerializer`.

NEW
: **\[json\]** Added set serialization.

NEW
: **\[util\]** Added `ZipBuilder`.

FIXED
: **\[util\]** Fixed boolean `printf`.

NEW
: **\[json\]** Make JSON parser to be aware of JSON annotations.

FIXED
: **\[util\]** Fixed BCrypt.

NEW
: **\[util\]** Added `PBKDF2Hash` and `MurmurHash3`.

NEW
: **\[props\]** Added method to get profiles list.

NEW
: **\[util\]** Added method to parse internet time.

FIXED
: **\[dboom\]** Fixed issues with hints and collections.

FIXED
: **\[util\]** Fixed `Unsafe` handling.

NEW
: **\[vtor\]** Added message to validation annotation.

FIXED
: **\[petite\]** Fixed Petite wiring.

FIXED
: **\[lagarto\]** Fixed handling of naked ampersends.

FIXED
: **\[http\]** Better handling of the HTTP connections.
{: .release}
