-----
make-toc:no
release:on
-----
# What's coming next?

## Release v3.4.6

We worked on *Lagarto* parser.

NEW
: Added `+=` assignment operator for *Props*.

NEW
: Added `HttpBrowser` class for easier *HTTP* usage and session tracking.

CHANGED
: All parameters (query, form and header) in *HTTP* now allow duplicate entries.

NEW
: Added 'HTML plus' parsing mode that can handle malformed HTMLs better.

CHANGED
: *Lagarto DOM* architecture improved, allowing custom DOM builder implementations.
{: .release}


## Code coverage increase

We have one simple rule: _just increase code coverage by **1%**_. We are constantly increasing code coverage by writing more testcases. Even if the increase is small, it is still a _good thing_ to do.