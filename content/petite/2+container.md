# Container

*Petite* container manages registered beans: it takes care about
lifecycle and **scope** of **registered** beans and resolves their
dependences, i.e. **wires** them together. These are the three key aspects of
*Petite*:

+ Registration,
+ Wiring, and
+ Scope.


## Registration

Registration is all about how to register your beans and components into the *Petite* container.

`PetiteContainer` provides the single method for registering beans:
`registerPetiteBean()` that takes following arguments:

* `type` - beans type, must be specified.
* `name` - beans name. If `null` the name will be resolved from the class.
* `scopeType` - bean scope. If `null` the scope will be resolved from the class.
* `wiringMode` - defines wiring mode. Also may be omitted.
* `define` - if set to `true`, injection points will be resolved.

This may be overwhelming, so just pay attention to first two arguments for now: the `type` and `name` (and provide `null`s to all others).

### Developer-friendly registration

There is a developer-friendly alternative for beans registration.
Instead of using `registerPetiteBean()` you may use `PetiteRegistry` class
that offers nice, fluent interface for easier registration.

### Registration using short type name

*Petite* beans may be named any way how you like it. However, there are two common scenarios, i.e. _naming convention_ that frees you from writing bean names explicitly. The first scenario is to use uncapitalized short name of bean type, which is the default *Petite* naming convention:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    // bean "foo"
    petite.registerPetiteBean(Foo.class, null, null, null, false);
    // bean "bar"
    petite.registerPetiteBean(Bar.class, null, null, null, false);
~~~~~

or, using alternative way:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    PetiteRegistry registry = PetiteRegistry.of(petite);

    registry.bean(Foo.class).register();    // "foo"
    registry.bean(Bar.class).register();    // "bar"
~~~~~

Either way, our two beans are registered into the container. Beans are
just simple POJOs:

~~~~~ java
    public class Foo {
    	Bar bar;
    	public void foo() {
    		bar.boo();
    	}
    }

    public class Bar {
    	public void boo() {}
    }
~~~~~

Registered beans can be lookuped by their names from container:

~~~~~ java
    Foo foo = petite.getBean("foo");
~~~~~

Simple as that ;) Wait, don't call `foo.foo()` yet! By default `PetiteContaienr` needs annotations to resolve dependencies.

### Registration using full type name

The second common scenario, i.e. a naming convention, is to use the full name of a bean type when the bean name is not provided.

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    petite.config().setUseFullTypeNames(true);

    // register beans as before
~~~~~

The registration part stays the same - we just configured *Petite* to use full types names:

~~~~~ java
    Foo foo = petite.getBean("org.jodd.Foo");
~~~~~

Good practice is not to mix naming convention when registering beans. Decide which one to use before development of your application starts.
{: .attn}


## Initialization methods

*Petite* may invoke so-called **init methods** before bean instance is returned from the container. Init methods are no-argument methods marked with annotation `@PetiteInitMethod`. Example:

~~~~~ java
    public class Bar {
    	...
    	@PetiteInitMethod
    	void init() {}
    }
~~~~~

By default, *Petite* will invoke init methods in unpredictable order (depends on JVM). Usually, it is the declaration order of methods in the class, but we can not guarantee that.

It is possible to specify the execution order of init methods, by setting `@PetiteInitMethod` element `order`. Order is a simple integer number. If order value is negative, those methods will be invoked last, starting from lesser number. For example, if methods are ordered as: `-1` and `-3`, the first will be invoked the method marked with order `-3`. Method marked with `-1` will be executed last. If order is not used, method will be invoked after the first ones (marked with positive order number) and the last ones (marked with negative order).

There are three different invocation strategies, that defines when init methods will be actually invoked:

+ `POST_CONSTRUCT` - invoked just after a bean is created, before wiring and parameters injection.
+ `POST_DEFINED` - invoked after bean has been wired with other beans, but before parameters injection
+ `POST_INITALIZED` - invoked after bean has been completely initialized, after the [parameters injection](parameters.html). This is the default strategy.

## Automatic registration

In all above examples, beans were registered into *Petite* container manually. But that is not the only way how we can do it. *Petite* offers automatic registration using `AutomagicPetiteConfigurator`: it will scan the classpath for all classes annotated with `@PetiteBean` annotation and automatically register them. Class scanning of `@PetiteBean` is quite fast: only the byte content is examined, so no other class is loaded during this process then the marked ones. It is possible to narrow the searched class path and fine-tune the scanning. Example:

~~~~~ java
    @PetiteBean
    public class Foo {
    ...
    @PetiteBean
    public class Bar {
    ...
~~~~~

Petite automagic:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    new AutomagicPetiteConfigurator(petite).configure();
~~~~~

Now all *Petite*'s beans founded on the classpath will be registered in the container.

It is perfectly fine to combine automatic and manual configurations. `@PetiteBean` annotation is also considered during manual bean registration, so marked beans may be also manually registered just by class reference, other properties will be read from the annotation's elements.

## @PetiteBean

`@PetiteBean` is a simple *Petite* bean marker that contains just few elements:

* `value` - defines bean's name; by default bean name equals to
  uncapitalized bean class name.
* `scope` - bean's scope, by default it is `DefaultScope`.
* `wiring` - wiring mode (explained next).

Although `@PetiteBean` annotation is used for automatic registration, it will be also considered during manual registration!


## Accessing bean properties

It is possible to write and read property values of beans from the *Petite* context. This functionality is similar to `BeanUtil`, except it is applied on *Petite* context:

~~~~~ java
	PetiteContainer pc = new PetiteContainer();
	pc.registerBean(PojoBean.class, "pojo", null, null, false);

	pc.setBeanProperty("pojo.foo1", "value");
	pc.getBeanProperty("pojo.foo2");

	pc.setBeanProperty("pojo.bean2.foo3", Integer.valueOf(173));
~~~~~

The only difference from `BeanUtil` is that first part of the property path (`pojo`) is actually the name of a registered bean.
