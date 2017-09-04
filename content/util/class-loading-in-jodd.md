# Class loading in Jodd

There is one very cool tool in *Jodd*: `ClassLoaderUtil#loadClass()`.
This method tries to load a class for given class name in the best way
possible, trying several different approaches. Here are more details.

First it tries to load a class using provided class loader (if it is
provided, of course).

If this fails or if classloader is not provided, class will be loaded
using current threads context class loader.

If this fails for some reason, *Jodd* will try to use callers class
loader.

*Jodd* detects if all classloader are the same and will not repeat the
loading if so. For example, if current threads context class loader is
the same to callers class loader, it will not load class twice in case
of failure.

Finally, if everything else fails, *Jodd* tries `Class.forName()`.

But `ClassLoaderUtil#loadClass()` is not special only because of
fail-safe approach for loading classes. It is also able to load
primitive classes, so `loadClass("int")` would return `int.class`. And
that's not all: it knows to load **array** classes as well! For
example, `loadClass("int[]") `returns `int[].class`;
`loadClass("java.lang.String[]")` returns `String[].class`.

Note: `Class.forName` is important here for loading array classes for
JDK >= 6.

