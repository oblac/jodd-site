---
javadoc: 'paramo'
---

# Paramo

Java compiler doesn't store method parameter names in class file and we
can't retrieve them using reflection. Actually, the names are stored in
the `LocalVariableTable` attribute of the method, if a class is compiled
with debug symbols on (i.e., javac -g). The `LocalVariableTable`
attribute is not accessible using reflection, but it can be read using
bytecode parsing library like ASM.

*Paramo* is a little tool that extracts method or constructor parameter
names from bytecode debug information in runtime.

*Paramo* works only if debug information is available in class files
(compile with: `javac -g` ).

## Usage

Using *Paramo* is very simple: just pass `Method` or `Constructor` to
the static method `Paramo#resolveParameters`. It returns
`MethodParameter[]` array with method parameter information, or an empty
array if method/constructor does not have any parameter.

`MethodParameter` is simple POJO that holds two information about the
method parameter:

* parameter name
* bytecode signature, including the generic information!

Method` resolveParameters` does not cache anything; every time invoked
it will examine the bytecode again. For efficient usage, wrap it and
cache results.
{: .attn}

In contrast to the rest of *Jodd*, *Paramo* is written to be 'raw',
without many helper methods. This is done by purpose, since getting
parameter names is usually part of some higher-level logic, that should
wrap it in the way that serves the best to that logic.

## Examples

Let's say we have the following class:

~~~~~ java
	public static class Foo {
		public Foo(String something) {}

		public void hello() {}

		public void two(String username, String password) {}
	}
~~~~~

We will assume that we got references to `Method`s and `Constructor`
using reflection (and with tool such `ReflectUtil#findMethod`). Now,
lets read parameter names:

~~~~~ java
    MethodParameter[] s = Paramo.resolveParameters(constructor);
    System.out.println(s.length);           // 1
    System.out.println(s[0].getName());     // something
~~~~~

~~~~~ java
    MethodParameter[] s = Paramo.resolveParameters(helloMethod);
    System.out.println(s.length);           // 0
~~~~~

~~~~~ java
    MethodParameter[] s = Paramo.resolveParameters(twoMethod);
    System.out.println(s.length);           // 2
    System.out.println(s[0].getName());     // username
    System.out.println(s[1].getName());     // password
~~~~~
