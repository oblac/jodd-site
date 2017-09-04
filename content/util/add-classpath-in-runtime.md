# Add to classpath in runtime

Two known facts first. Classpath is defined on JVM startup, before
application starts. Second, when some class has to be loaded
dynamically, default system class loader will search for it on this
classpath.

However, sometimes it would be nice to be possible to **extend** the
classpath in the **runtime**. Once when classpath is extended, then it
would be possible to dynamically load classes from added folders/JARs,
in the absolutely same way as when the classpath is defined during the
JVM startup. Unfortunately, Java doesn't allow classpath to be changed
(extended) in the runtime.

But *Jodd* provides a hack for that. Using `ClassLoaderUtil` methods
`addFileToClassPath()` and `addUrlToClassPath()` it is possible to
extend classpath in runtime, by adding files or URLs of new
folders/JARs. Simply as that:

~~~~~ java
	String addonClasspath = "/some/path/not/already/on/classpath";
	ClassLoaderUtil.addFileToClassPath(addonClasspath);

	Class c = Class.forName("FooClass");     // load class anyhow
	Object o = c.newInstance();              // start using it...
~~~~~

While adding is possible, it is not possible to remove items from the
classpath.

## Defining classes in the runtime

Instead of adding a classpath and then loading new classes from it,
*Jodd* is possible to **define** classes in the run time, just from
their file content. The procedure is simple: read class file from file
system into byte array that is to be provided to `defineClass()`.
Previous example may be written as:

~~~~~ java
	String classPath = "/some/path/to/class/file/not/on/classpath/Foo.class";
	byte[] classBytes = FileUtil.readBytes(classPath);

	Class c = ClassLoaderUtil.defineClass("FooClass", classBytes);
	Object o = c.newInstance();					// start using it...
~~~~~

Again, this is a *Jodd* hack and not something Java allows.

## Comparison

What is the difference between these two approaches? The first one
really extends the classpath, so all classes on the added path
implicitly becomes visible. Second approach does not extend the
classpath, but adds each class manually. It requires more work if more
classes are needed, and order of class defining is important (because of
dependencies). However, class can be read from any source (file system,
network,...) and can be in any format (encrypted, zipped...).

## Hack alert!

Both methods are hacks. Although they should (and will) work, user must
be aware that the results may be different then expected.
