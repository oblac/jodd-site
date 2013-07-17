# Methref: method name references

Sometimes there is a need to refer methods in our code using their
names. For example, when using property names to build some ORM
criteria, or when using some [CoC][1] framework, like
*Madvoc*, to point to some method out of current class and so on.
Usually, method names are stored as strings and such are not immune of
method name change refactorings.

*Methref* is a tiny, tiny utility, build on
[*Proxetta*](/doc/proxetta/index.html), that provides strongly-typed
references to method names. Here is how it works.

## Strongly-typed method name references

Here is an example of method reference:

~~~~~ java
    Methref<Str> m = Methref.on(Str.class);     // create Methref tool
    m.ref(m.method().boo()));                   // will return String: 'boo'
    m.ref(m.method().foo()));                   // will return String: 'foo'
~~~~~

First, a `Methref` object is created using the class that contains
target method. `Methref` objects are cached internally, so there will be
no performance penalty on using it all over the code.

Lines #2 and #3 of above example shows how to get method names.
`m.method()` returns proxified instance of target class. Then, by simple
target method invocation in combination with `m.ref()`, the method name
is returned! And that is all - now, when target method name is changed
(e.g. using refactoring in IDE), no other action regarding new method
name is required.

Two important things to remember:

1.  Although there is a target method invocation, **method code is NOT
    executed**!
2.  *Methref* instances are not thread safe and should be not shared;
    instead new `Methref` should be created where needed.

## Methods that return String

Above example will work on methods with all kind of return types,
including primitive types. However, when target method returns a
`String`, there is a shorter and more convenient one-liner usage:

~~~~~ java
    Methref.sref(Str.class).foo();			// will return 'foo'
~~~~~

## Methods with arguments

Of course, *Methref* supports methods with arguments: since method code
is not invoked, any method argument value may be used until syntax is
correct:

~~~~~~ java
    Methref.sref(Str.class).foo2(null, null);
~~~~~~

## Void methods

When method returns a `void`, *Methref* has to be used like this:

~~~~~ java
    Methref m = Methref.on(Str.class);
    m.method().voo();
    m.ref();				// will return String 'voo'
~~~~~

[1]: http://en.wikipedia.org/wiki/Convention_over_configuration
