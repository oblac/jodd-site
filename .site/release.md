## [2013-10-14] Release v3.4.8

Many fixes. Sad day for bugs, great day for us :)

FIXED
: Added fallback logic for `renameTo` usage in `FileUtil`.

NEW
: Added offset to every `Node` in *Lagarto DOM*.

CHANGED
: Added `LagartoParserContext` for `start()` method in `TagVisitor` in *Lagarto*.

CHANGED
: `TypeConverter#convert` does not throw `ClassCastException` anymore, but `TypeConversionException`.

FIXED
: All array converters have been upgraded.

NEW
: Added `resultTypePrefix` for all *Madvoc* results.

CHANGED
: Migrated to Gradle v1.8.

FIXED
: Fixed a bug in *Props* with preset default profiles before loading.

FIXED
: Fixed NPEs on missing email attachment name, or FROM field.

FIXED
: Added support for non-english emial attachment names.

FIXED
: Add default email attachment encoding if not specified.
{: .release}
