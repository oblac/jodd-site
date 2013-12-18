-----
make-toc:no
-----
# What's coming next?

## Release v3.4.10

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


## Code coverage increase

We have one simple rule: _just increase code coverage by **1%**_. We are constantly increasing code coverage by writing more testcases. Even if the increase is small, it is still a _good thing_ to do.