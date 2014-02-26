# Methref

*Methref* is a tool that gives you strong-type references to method names.

Sometimes you need to refer to a method in our code using their
names. Usually in this cases, method names are stored as strings
and they are not immune to method name changes and typing errors.

*Methref* is a tiny and cool utility, build on
[*Proxetta*](/doc/proxetta/index.html), that provides strongly-typed
references to method names. Here is how it works.

## Strongly-typed method name references

Here are two examples how *Methref* can be used:

~~~~~ java
    Methref<Str> m = Methref.on(Str.class);  // create Methref tool
    
    // example #1
    m.to().boo();
    m.ref());                               // returns String: 'boo'

    // example #2
    m.ref(m.to().foo()));                   // returns String: 'foo'
~~~~~

In both cases, `Methref` object is created first for target class which
method we are looking for. `Methref` objects are cached internally,
so there will be no performance penalty on using it all over the code.

In first example, method is called separately from place where it's name
is returned. In second example, all that is done in one line. Anyway,
calling `to()` returns proxified instance of target class (cached).
Then, by simple target method invocation in combination with `m.ref()`,
the method name is returned! And that is all - now, when target method name
is changed (e.g. using refactoring in IDE), no other action regarding
new method name is required.

Two important things to remember:

1.  Although there is a target method invocation, **method code is NOT
    executed**! Proxy just returns <code>null</code> or a method name
    if methods return type is a <code>String</code>.
2.  *Methref* instances are not thread safe and should be not shared;
    create new `Methref` where needed.

## Methods that return String

When method returns a <code>String</code> there is even a shortcut!
Such methods will return method name as a result. For example:

~~~~~ java
    Methref.on(Str.class).to().foo();			// returns 'foo'
~~~~~

Or even shorter:

~~~~~ java
    Methref.onto(Str.class).foo();              // returns 'foo'
~~~~~

## Methods with arguments

Of course, *Methref* supports methods with arguments: since method code
is not invoked, any method argument value may be used until syntax is
correct:

~~~~~~ java
    Methref.onto(Str.class).foo2(null, 0);
~~~~~~

If method is overloaded, use some constants for your arguments to distinguish
between methods.

Enjoy!

[1]: http://en.wikipedia.org/wiki/Convention_over_configuration
