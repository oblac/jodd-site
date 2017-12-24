# ClassScanner

Finding one or many classes or resources on the classpath is often needed.
*Jodd* provides powerful classpath scanning tool: `ClassScanner`.

`ClassScanner` should work in Java 9. jodd-core is a Multi-Release JAR.
{: .attn}

`ClassScanner` scans JARs (including those linked via `Manifest.MF` file)
and filter founded entities. When matched class or resource (i.e. entry) is found,
callback method is fired.

Example:

~~~~~ java
    ClassScanner classScanner = new ClassScanner();
    classScanner.onEntry(entryData -> {
        // process entry data
    })
    .scan(classpathFiles);
~~~~~

`EntryData` that represents single element of scanning, basically a founded class. Note that class is **not** loaded! This is only a reference to a class file! You don't have to load class in order to match it; you can simply find the bytecode signature in it (util method provided: `bytecodeSignatureOfType`).

~~~~~ java
    ClassScanner cs = new ClassScanner();
    cs.onEntry(entryData -> {
            InputStream inputStream = entryData.openInputStream();
            byte[] bytes = StreamUtil.readAvailableBytes(inputStream);
            System.out.println("---> " +
                entryData.getName() + ':' + entryData.getArchiveName()
                + "\t\t" + bytes.length);
        }
    })
    .includeResources(true);
    .scan("/some/classpath");
~~~~~

## Configuration

* `excludeJars` - list of excluded jars (i.e. wildcard templates) that
  will be excluded, if specified.
* `includeJars` - list of jars that has to be included.
* `excludeEntries` - list of exclude entry wildcard paths.
* `includeEntries` - list of included entries.
* `includeResources` - if set to `true`, all files on the classpath will
  be scanned, not only classes.
* `ignoreException` - specifies if exception should be thrown on
  scanning errors or simply ignored.

Rules for `include*` and `exclude*` are powered by our powerful `InExRules` engine.

Besides these properties, user can change the filtering behavior
by overriding methods `acceptJar()` and `acceptEntry()`.

Scanning is invoked by calling one of `scanUrls` or `scanPaths` methods.
Note that all these methods are protected, because `ClassFinder` is
designed to be used as a base scanning class for custom scanners.

`ClassFinder` is used internally by many *Jodd* frameworks, for
automatic configurations. It usually reads classes on classpath and
scans them for some annotations.
