-----
make-toc:no
-----
# What's coming next?

## Release v3.6.1

Bug fixes. Minor changes. We promise we gonna release more often.

CHANGED
: **[mail]** Multiple addresses now should be added by repeated call to
address-related methods.

CHANGED
: **[mail]** Email address-related methods now accept two arguments:
for personal name and for email address. Moreover, they accept
`EmailAddress` and `InternetAddress`.

NEW
:  **[madvoc]** When `@RestAction` value starts with macro, add action
method name to the path.

NEW
:  **[json]** Added loose mode for parsing.

FIXED
:  **[json]** Fixed using integers in some cases for *Json* parser.

FIXED
:  **[json]** Fixed parsing bug that may occur with long strings and late escapes.
{: .release}


## Code coverage increase

We have one simple rule: _just increase code coverage by **1%**_.
We are constantly increasing code coverage by writing more testcases.
Even if the increase is small, it is still a _good thing_ to do.