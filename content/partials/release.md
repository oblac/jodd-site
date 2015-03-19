## \[2015-03-21\] Release v3.6.5

It seems that this month we cleaned up some important bugs,
thanks to our awesome community!

NEW
: **\[http\]** `HttpBrowser` now accepts local path on 30x.

NEW
: **\[http\]** Added default headers to `HttpBrowser`.

FIXED
: **\[madvoc\]** Fixed action string in case of proxified classes.

FIXED
: **\[servlet\]** Reset `content-length` in GZip stream.

FIXED
: **\[lagarto\]** Reset `content-length` in *Lagarto* filter.

FIXED
: **\[decora\]** Reset `content-length` in *Decora* filter.

NEW
: **\[htmlstapler\]** Added `randomDigestChars` option to bundles manager.

NEW
: **\[bean\]** Added methods to `BeanCopy` for better fluent interface.

NEW
: **\[bean\]** Added `BeanUtil#setProperty` with all options as arguments.

CHANGED
: **\[bean\]** Removed `this*` reference.

NEW
: **\[props\]** Added extracting of inner map in the *Props*.
{: .release}
