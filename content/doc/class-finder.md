# Class Finder & Scanner

Finding one or many classes or resources on the classpath is often needed.
*Jodd* provides two powerful tools: `ClassFinder` and, its subclass,
`ClassScanner`.

## ClassFinder

`ClassFinder `contains main logic (based on `FindFile`) for finding
classes (and resources) on classpath or simply on set of files. `ClassFinder`
scans JARs (including those linked via manifest file) and filter founded
entities. When matched class or resource (i.e. entry) is found, callback
method is fired.

For scanning just files and folders, see [file finder](findfile.html).

`ClassFinder` can be fine tuned using following properties:

* `systemJars` - list of system jars (i.e. wildcard templates), that are
  always excluded. It is a static property. By default, system jars are
  already set to exclude common JDK jars on Mac, Linux and Windows.
* `excludeJars` - list of excluded jars (i.e. wildcard templates) that
  will be excluded, if specified.
* `includeJars` - list of jars that has to be included.
* `excludeEntries` - list of exclude entry wildcard paths.
* `includeEntries` - list of included entries.
* `includeResources` - if set to `true`, all files on the classpath will
  be scanned, not only classes.
* `ignoreException` - specifies if exception should be thrown on
  scanning errors or simply ignored.

Rules for `include*` and `exclude*` are powered by our powerful
[InExRules](inc-exc-rules.html) engine.

Besides these properties, user can change the filtering behavior
by overriding methods `acceptJar()` and `acceptEntry()`.

Scanning is invoked by calling one of `scanUrls` or `scanPaths` methods.
Note that all these methods are protected, because `ClassFinder` is
designed to be used as a base scanning class for custom scanners.

For every founded class file (or a resource), `onEntry` method is fired.
It gets an instance of `EntryData` - class that wraps currently founded
class or a resource. `ClassFinder` may also open input stream of an entry
by using `openInputStream` method. Now you can read it's actual content.
Once opened, `InputStream` does not have to be closed in callback method,
since `ClassFinder` does that for you.

`ClassFinder` is used internally by many *Jodd* frameworks, for
automatic configurations. It usually reads classes on classpath and
scans them for some annotations.

## ClassScanner

For somewhat convenient and quick work you can use `ClassScanner`. It
extends `ClassFinder` and just offers few scanning methods as public methods.
Here is the usage example:

~~~~~ java
    ClassScanner cs = new ClassScanner() {
        @Override
        protected void onEntry(EntryData entryData) {
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

Simple, right! Here is another example how you can e.g. list all resources
of some webjar:

~~~~~ java
    URL url = ClassLoaderUtil.getResourceUrl(
        "/META-INF/resources/webjars/jquery");

    File containerFile = FileUtil.toContainerFile(url);

    ClassScanner classScanner = new ClassScanner() {
        @Override
        protected void onEntry(EntryData entryData) throws Exception {
            System.out.println(entryData.getName());
        }
    };

    classScanner.setIncludeResources(true);
    classScanner.scan(containerFile);
~~~~~

Easy as that :)