## [2013-07-26] Release v3.4.5

Wow, still alive. Another set of improvements and some new features.
Also, the documentation was converted to markdown.
Hope you gonna enjoy this.

NEW
: Added `ExtendedURLClassLoader`.

CHANGED
: Methods `merge` removed from `ArrayUtil` in favor of `join`.

FIXED
: Getting generic raw type information significantly improved.

CHANGED
: Another change with `FindFile` towards unified usage regardless the implementation.

NEW
: *LagartoDOM* introduce renderer for customized HTML output.

CHANGED
: Each node in *LagartoDOM* has a reference to DOM builder instance.

CHANGED
: Improved and simplified way how *LagartoDOM* was fixing unclosed tags.

FIXED
: `BeanUtil` uses more generic raw types information.

CHANGED
: All introspectors have gone through refactoring and optimization.

NEW
: Add new property `ignoreMacros` to *Props*.

NEW
: *Madvoc* allows multiple roots to be mapped to different paths.

CHANGED
: *Proxetta* now uses `$$` in class names as a marker.

FIXED
: Several issues have been fixed with *Proxetta*

NEW
: Added delegating wrapper to *Proxetta* for dynamically loaded classes.

NEW
: Added JRE detection to `SystemUtil`.

FIXED
: Fixed issue with flushing streams in `ObjectUtil`.

FIXED
: *Props* was not initialized in certain use cases.

CHANGED
: Migrated to Gradle 1.6. All QuickStart projects migrated to Gradle.
{: .release}
