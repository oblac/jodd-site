# Wiring components

When bean instance is created for the first time, *Petite* wires it with other registered beans. **Wiring** in *Petite* is the injection of required references into defined **injection points**.

## Wiring properties

By default, injection points in *Petite* components are marked with `@PetiteInject`. In our example, so far, container did not resolved the dependency since no annotation is used. To make previous example work, the `Foo` class needs to mark the injection point:

~~~~~ java
    public class Foo {
    	@PetiteInject
    	Bar bar;

    	public void foo() {
    		bar.boo();
    	}
    }
~~~~~

*Petite* now resolves dependency by injecting it in the annotated injection point. If annotation itself doesn't specify the bean name, it will be resolved from the injection point name (here thats field name).

Using setter methods for property injection point is not necessary, although they are used if defined. If a setter exist, *Petite* will inject required reference using a setter method, even if annotation is declared on a property field.

*Petite* knows how to handle circular dependencies during the wiring.

## Implicit bean references

If a bean reference name is not explicitly set by the annotation on an injection point, *Petite* will try to resolve the name. By default, bean name is resolved using the following values in given order:

1. property name,
2. uncapitalized short field type name,
3. long type name.

This order and values is fully configurable in *Petite* configuration. For example, it is possible to use only property names when resolving beans, or type's full name; or to change above order.

Knowing this, in the previous example *Petite* lookups for the following bean names:

1. `bar`
2. `bar` (ignored as equals to #1)
3. `org.jodd.Bar`

The first bean found will be injected into the marked injection point.

## Wiring methods

*Petite* also may use method injection points for wiring. Any method marked with `@PetiteInject` annotation is method injection point. References will be injected through any number of method arguments:

~~~~~ java
    public class Foo {

    	@PetiteInject
    	void injectBar(Bar bar) {...}
        ...
    }
~~~~~

By default, reference names are resolved in the same way as for properties. Note that argument names are available using *Paramo* (another *Jodd* tool for resolving method argument names from bytecode), but only if classes are compiled in debug mode. To inject differently named references, they have to be specified in value element of `@PetiteInject` annotation, separated by a comma.

~~~~~ java
    public class Foo {

    	@PetiteInject("bar, one")
    	void injectBoo(Bar bar, Zar zar) {...}
        ...
    }
~~~~~

You can ignore argument names (and not use *Paramo*) and rely only on argument types.

### Using method arguments

There is a better way to markup the method - just by putting annotation on the arguments. Above example can be rewritten like this:

~~~~~ java
    public class Foo {

        void injectBoo(
            @PetiteInject Bar bar,
            @PetiteInject("one") Zar zar) {...}
        ...
    }
~~~~~

The results is (almost) the same.


## Wiring constructors

*Petite* may wire beans and components using constructor. In the above example, `Foo` class may be modified as:

~~~~~ java
    public class Foo {

    	final Bar bar;

    	@PetiteInject
    	public Foo(Bar bar) {
    		this.bar = bar;
    	}

    	public void foo() {
    		bar.boo();
    	}
    }
~~~~~

As for method injection points, constructor injection points are resolved in the same way as of methods and parameters. Annotating constructor arguments works too!

Constructor injection points have some limitations. There must be just one constructor injection point of a bean. If no constructor is annotated, *Petite* will take either the only available constructor, either the default one (when class has more then one constructor).


## Wiring modes

*Petite* supports several wiring modes of registered beans:

+ `NONE` - no wiring, used in (rare) cases to prevent any possible
  wiring at all.
+ `DEFAULT` - wiring mode is set by *Petite* container configuration.
+ `STRICT` - strict wiring affects only property injection points. When
  strict mode is active, *Petite* only considers annotated fields (with
  `@PetiteInjection`) and throws an exception if required reference
  doesn't exist.
+ `OPTIONAL` - relaxed version of previous mode also inject into
  annotated fields, but doesn't throw any exception for missing
  references.
+ `AUTOWIRE` - tries to inject value in all bean fields. Missing
  references are ignored. Since all fields are examined, this mode is
  slightly slowest of all above. If field is annotated, injection
  information will be resolved from annotation, as usual.

Wiring mode of a bean may be defined independently from container.
