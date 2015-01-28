# Jodd on Android

*Jodd* can be used on Android (and other Java embedded devices), too!

The following classes from <var>jodd-core</var> can not run:

* `jodd.util.ObjectXmlUtil` - for reading/writing object from/to XML
  files.
* `jodd.util.JmxClient` - jmx client
* `jodd.util.ClipboardUtil` - system clipboard tools

Of course, feel free to strip down *Jodd* jars and include only classes
you use, to save precious device space.

## Jodd Mobile

We have made the **mobile** version of *Jodd*; a single jar that
contains only selected utilities and tools from modules
<var>jodd-core</var> and <var>jodd-bean</var>; keeping it less then
**300** KB in size.

