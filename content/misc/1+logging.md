# Logging in Jodd

*Jodd* uses simple logging facade for logging. By default, logging
is disabled. To turn it on, set logger factory of implementation
you want to use, for example:

~~~~~ java
    LoggerFactory.setLoggerProvider(Slf4jLogger.PROVIDER);
~~~~~

This way *Jodd* modules does not depend on logging implementation.
Currently, *Jodd* provides following logging implementations:

* Commons Logger
* JDK logger
* SLF4J logger
* `SimpleLogger` - simple logger that outputs logs to console, convenient
for development.

Please refer to official documentation of Logger that you want to use
in your application. If you still haven't
choose a logging framework, consider uses [SLF4J][1] and [LOGback][2].

[1]: http://www.slf4j.org/
[2]: http://logback.qos.ch/
