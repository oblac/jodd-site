# Class Finder & Scanner

Finding a class or a resource on classpath is sometimes very useful for
configuration process of some framework. *Jodd* provides two powerful
tools: `ClassFinder` and, its subclass, `ClassScanner`.

## ClassFinder

`ClassFinder `contains main logic (based on `FindFile`) for finding
classes (and resources) on provided classpath. `ClassFinder` scans JARs
(including those linked via manifest file) and filter founded entities.
When matched class or resource (i.e. entry) is found, callback method is
invoked.

For scanning files and folders, see [file finder](findfile.html).
{: .example}

`ClassFinder` contains can be fine tunes using following properties:

* `systemJars` - list of system jars (i.e. wildcard templates), that are
  always excluded. It's a static property.
* `excludedJars` - list of excluded jars (i.e. wildcard templates) that
  will be excluded, if specified.
* `includedJars` - list of jars that has to be included.
* `excludedEntries` - list of exclude entry wildcard paths.
* `inclduedeEntries` - list of included entries.
* `includeResources` - if set to `true`, all files on the classpath will
  be scanned, not only classes.
* `ignoreException` - specifies if exception should be thrown on
  scanning errors or ignored.

Besides these properties, user can change the default filtering behavior
by overriding methods `acceptJar()` and `acceptEntry()`.

Scanning is invoked by calling one of `scanUrls` or `scanPaths` methods.
Note that all these methods are protected, because `ClassFinder` is
designed to be used as a base scanning class for custom scanners.

`ClassFinder` may also open class input stream by using
`InputStreamProvider` passed to callback method, so the callback method
may read actual content of class or resource. Once opened, `InputStream`
does not have to be closed in callback method, since `ClassFinder` does
that.

`ClassFinder` is used internally by many *Jodd* frameworks, for
automatic configurations. It usually reads classes on classpath and
scans them for some annotations.

## ClassScanner

For somewhat convenient usage - especially as anonymous class - there is
`ClassScanner`. It extends `ClassFinder` and offers few scanning methods
as public. Here is the usage example:

~~~~~ java
    ClassScanner cs = new ClassScanner() {
        @Override
        protected void onClassName(EntryData entryData) {
            InputStream inputStream = entryData.openInputStream();
            byte[] bytes = StreamUtil.readAvailableBytes(inputStream);
            System.out.println("---> " +
                entryData.getName() + ':' + entryData.getArchiveName()
                + "\t\t" + bytes.length);
        }
    };
    cs.includeResources(true);
    cs.scan("/some/classpath");
~~~~~
