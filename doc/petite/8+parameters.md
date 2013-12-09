# Parameters

<div class="doc1"><js>doc1('petite',20)</js></div>
It is possible to define container parameters that will be injected into
its beans after the wiring and before the init method invocation.
Parameter is defined with the `String` name and value of any type.

By default, parameters are injected before init method invocation. In
some cases, some init methods has to be invoked before setting the
parameters. That is done by setting the `firstOff` element of
`@PetiteInitMethod`, to indicate that init method has to be invoked
before parameters injection.

## Convention

Parameters are bind to the container using the convention: parameter
name starts with the bean name. Example:

~~~~~ java
    PetiteContainer pc = new PetiteContainer();
    pc.registerBean(Foo.class);                 // registered as "foo"
    pc.defineParameter("foo.name", "FOONAME");
    ...
    Foo foo = (Foo) pc.getBean("foo");
    foo.getName();                              // "FOONAME"
~~~~~

## Parameter References

Sometimes, one parameter has to be injected in several different beans.
In order to prevent repeating, it is possible to use parameter
references. Parameter reference is a parameter name surrounded with
\'`${}`\' that points to some other parameter. It can occur anywhere in
the value string. Nested references are supported as well. Example:

~~~~~ java
    PetiteContainer pc = new PetiteContainer();
    pc.registerBean(Foo.class);                     // registered as "foo"
    pc.defineParameter("foo.name", "${name}");      // ref -> name
    pc.defineParameter("name", "${name${num}}");    // ref -> name2
    pc.defineParameter("num", "2");
    pc.defineParameter("name2", "FOONAME");

    ...
    Foo foo = (Foo) pc.getBean("foo");
    foo.getName();                                  // "FOONAME"
~~~~~

Resolving references is optional and, by default, is turned on.

*Petite* container doesn't detect circular dependencies when resolving
parameters.
{: .attn}

References can be escaped with single \'`\`\' character, while \'`\\`\'
removes escaping effect and are resolved to single backslash.

References are resolved late, on their first injection.

## Loading from map

It is possible to load parameters from any `Map` implementation, such as
`Properties`.

