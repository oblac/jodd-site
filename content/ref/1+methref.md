# Methref

*Methref* is a tool that gives you strong-type references to method names.

Sometimes you need to refer to a method in our code using their
names. Usually in this cases, method names are stored as strings
and they are not immune to method name changes and typing errors.

*Methref* is a tiny and cool utility, build on
[*Proxetta*](/proxetta/), that provides strongly-typed
references to method names. Here is how it works.

## Simple way

~~~~~ java
    Methref.of(Str.class).name(Str::boo);
    // returns String: 'boo'
~~~~~

First we create `Methref` object and call method `name` on method reference.
Could it be simpler?:)

If a method has arguments, just pass whatever: usually `null` or zeros:

~~~~~~ java
    Methref.of(Str.class).name((str) -> str.hello(null, 0));
    // returns 'hello'
~~~~~~

Two important things to remember:

1.  Although there is a target method invocation, **method code is NOT
    executed**! Proxy just returns `null` or a method name
    if methods return type is a `String`.
2.  Create new `Methref` where needed. However, they can be stored and reused.

## Separate way

With _Methref_ you can actually do a lot of magic :) Previous, simple usage can
be split into several steps:

~~~~~~ java
    Methref m = Methref.of(Str.class);

    // get proxy
    Str str = m.proxy();

    // invoke method
    str.foo();

    // get invoked method name
    String name = m.lastName();
~~~~~~

This approach is made for cases when method invocation happens in different
place of your code, where you don't want to expose `Methref`.

## Detect Methref

Imagine that you are creating several `Methref` in one place of code. Then, user
of your code will call method on one of those proxies, but you don't
have control on which. There is a way to detect the `Methref` from the proxy by
calling method `isMyProxy`. Furthermore, there is a `static` method `lastName(instance)`
that works like the `Methref#lastName()`.

## Where this can be used?

Like I said, it can be used for magic :) Believe or not, with `Methref` you can
create, for example, strongly typed SQL-alike syntax directly with your code.

Enjoy!

[1]: http://en.wikipedia.org/wiki/Convention_over_configuration
