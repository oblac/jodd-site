# FAQ

Everything you always wanted to know about *Email* (but were afraid to ask).


## How to parse EML files?

What if you have your emails stored in EML files? Not a problem! Use
`EMLParser.create().parse()`. It accepts both file or files content as an input and
returns `ReceivedEmail` of parsed EML message.


## Gmail and new messages count?

Gmail does not support the Recent flags on messages. Since the
`getNewMessageCount()` method counts messages with the RECENT flags, *Jodd*
will not (yet) find any such messages on Gmail servers
(hence always returning value 0).


## How to parse and validate an email address?

*Jodd* offer a great class for parsing and validating emails: `EmailAddress`.
It works per RFC2822 standard. This class can be trusted to only
provide authenticated results. Since the standard is quite complex,
it is not a perfect yet, but it works much better then other solutions.


## I am getting an exception when receiving emails?

It may happens that email receiving fails if you have different java-mail libraries on your classpath.
For example, on Apache CXF there is `geronimo-javamail_1.4_spec-1.7.1.jar` and it conflicts
with the *Jodd* *Email*.


## Is embed attachment always supposed to be inline?

Here is how we see it:

+ `inline` and `content-ID` can be set separately.
+ embedded images should be set using `Content-Disposition`. Of course, setting `content-ID` is required if you want to use them.
+ we could not find any reference of `inline` without a `content-ID`.

The answer is Yes - embedded attachment sets both `content-ID` and `inline`.