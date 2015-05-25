## \[2015-05-25\] Release v3.6.6

It seems that this month we cleaned up some important bugs,
thanks to our awesome community!

FIXED
: **\[http\]** Fixed special case when content-length and chunked encoding exists.

NEW
: **\[util\]** `getResourceAsStream` now has a boolean argument to disable the cache.

CHANGED
: **\[util\]** Zip methods now returns resulting zip `File`.

FIXED
: **\[methref\]** Fixed parallel access, added `Pathrefs`.

FIXED
: **\[mail\]** Fixed parsing with `MailAddress`.

NEW
: **\[mail\]** Added `startTlsRequired` and `plaintextOverTLS()`.

NEW
: **\[mail\]** Added debug mode option and strict email address flag.

CHANGED
: **\[bean\]** `BeanCopy` got some slight modifications and improvements.

CHANGED
: **\[madvoc\]** Execution of inteceptors, filters and actions is significantly simplified.
{: .release}
