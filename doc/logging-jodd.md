# Logging in Jodd

*Jodd* uses [SLF4J][1] for logging. The Simple Logging
Facade for Java or (SLF4J) serves as a simple facade or abstraction for
various logging frameworks, e.g. `java.util.logging`, **log4j** and
**logback**, allowing the end user to plug in the desired logging
framework at deployment time.

Please refer to [SLF4J documentation][2] for more info on
binding it into your existing logging framework. If you still haven't
choose a logging framework, consider [LOGback][3].

Only *Jodd* frameworks uses logging. We are not logging aggressively,
instead, we tried to put logging only on important points and things
that happens far in background. In that manner, for example, exceptions
are not logged - it is expected that some above layer that is using
*Jodd* frameworks handles (and logs) exceptions.

## Quick Solution

If you don't have time to study **SLF4J** and just want to be able use
*Jodd* frameworks, than do the following.

1.  Go to [http://www.slf4j.org/download.html][4] and download **SLF4J**
    distribution package.
2.  Put `slf4j-api-X.X.X.jar` on the classpath
3.  If you don't want any logging, just put `slf4j-nop-X.X.X.jar` on
    the classpath.
4.  Otherwise, go to [http://logback.qos.ch/download.html][5] and
    download **LOGback** distribution package.
5.  Put `logback-core.jar` and `logback-classic.jar` on the classpath.


[1]: http://www.slf4j.org/
[2]: http://www.slf4j.org/manual.html
[3]: http://logback.qos.ch/
[4]: http://www.slf4j.org/download.html
[5]: http://logback.qos.ch/download.html
