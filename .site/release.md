## [2013-12-19] Release v3.4.10

Performances. Improvements. Fixes. Enjoy!

CHANGED
: Both *Lagarto* and *CSSelly* now uses char[]-based JFLex parser.
This boosts performances.

NEW
: *Madvoc* has new type of interceptors: `ActionFilter`.

CHANGED
: `StringBand` optimized for more speed.

CHANGED
: `FindFile` include patterns now uses OR logic for matching.

FIXED
: In entity-aware mode, `DbOom` now does not add `null`s to the collection

FIXED
: `JtxTransactionManager` now cleans data from thread local when
last transaction is closed.

CHANGED
: Our famous fast buffers just get faster.
{: .release}
