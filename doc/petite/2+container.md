# Container

<div class="doc1"><js>doc1('petite',20)</js></div>
*Petite* container manages registered beans: it takes care about
lifecycle and **scope** of **registered** beans and resolves their
dependences, i.e. **wires** them. These are the three key aspects of
*Petite*: registration, wiring and scope. More details follows.


## Registration

*Petite* must be aware of beans it manages. Therefore, beans first
have to be registered into *Petite* container.

`PetiteContainer` provides single method for registering beans:
`registerPetiteBean()` that takes following arguments:

* `type` - beans type, must be specified
* `name` - beans name. If `null` the name will be resolved from the class.
* `scopeType` - bean scope. If `null` will be resolved from the class.
* `wiringMode` - defines wiring mode. Also may be omitted.
* `define` - if set to true, injection points will be resolved

At this moment that is too much, so just pay attention to first two arguments:
`type` and `name` (and provide `null`s to all others).


## User-friendly registration

There is one more developer-friendly alternative for beans registration.
Instead of using `registerPetiteBean()` you may use `PetiteRegistry` class
that offers nice, fluent interface for easier registration. You will see
this in next examples.

### Registration using short type name

You may name your beans any way you like it. However, there are two common
scenarios, i.e. naming convention that frees you from writing
bean names explicitly. The first scenario is to use uncapitalized short name of
bean type, which is default *Petite* naming convention:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    petite.registerPetiteBean(Foo.class, null, null, null, false);
    petite.registerPetiteBean(Boo.class, null, null, null, false);
~~~~~

or, alternatively:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    PetiteRegistry registry = new PetiteRegistry(petite);
    
    registry.bean(Foo.class).register();
    registry.bean(Bar.class).register();
~~~~~

Either way, two beans are registered into the container. Beans are
just simple POJOs:

~~~~~ java
    public class Foo {

    	Boo boo;

    	public void foo() {
    		boo.boo();
    	}
    }

    public class Boo {

    	public void boo() {}
    }
~~~~~

Registered beans can be lookuped by their names from container:

~~~~~ java
    Foo foo = (Foo) petite.getBean("foo");
~~~~~

Simple as that ;)

### Registration using full type name

The second common scenario, i.e. naming convention, is to use
full name of bean type when bean name is not provided.

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    pc.getConfig().setUseFullTypeNames(true);

    petite.registerPetiteBean(Foo.class, null, null, null, false);
    petite.registerPetiteBean(Boo.class, null, null, null, false);
~~~~~

As you see, the registration part didn't change - we just configured
*Petite* to use full types names. Lookup is changed:

~~~~~ java
    Foo foo = (Foo) petite.getBean("org.jodd.Foo");
~~~~~

Good practice is not to mix these two ways of registering beans. Decide
which one to use before start developing your application.
{: .attn}

Generally, you can use short names for \'closed\' application; use full names
for bigger application, especially if it is open for enhancements by its users.
Of course, nothing stops you to use your own naming convention :)


## Wiring properties

When bean instance is created for the first time, *Petite* wires it with other
registered beans. Process of wiring is injection of requested references
into defined **injection points**.

By default, *Petite* looks for injection points in bean's class
annotated with `@PetiteInject`. In previous example, although there is
actual dependency in `Foo` class, container will not resolved it, since
no annotation is used. To make previous example work, `Foo`
class needs to be changed:

~~~~~ java
    public class Foo {

    	@PetiteInject
    	Boo boo;

    	public void foo() {
    		boo.boo();
    	}
    }
~~~~~

*Petite* will now resolve dependency by injecting it in the annotated
injection point. If annotation doesn't specify the bean name, it will
be resolved.

Using setter methods for property injection points is not necessary,
although it may be used if desired. If setter exist, *Petite* will inject
required reference using a setter method, even if annotation is
on defined on property field.

*Petite* knows how to handle circular dependencies during the wiring.

## Resolving bean references

If bean name is not explicitly set by annotation on injection point, *Petite*
will try to resolve the name. By default, bean name is resolved using
the following values in given order:

1.  property name
2.  uncaptialized short field type name
3.  long type name

This order and values are fully configurable in *Petite*
configuration. For example, it is possible to use only property name
when resolving beans, or type full name; or to change above order.

In previous example, *Petite* will lookup for beans named: `boo` and
`org.jodd.Boo` (`boo` is not searched twice, since steps #1 and #2 have the
same name). The first bean found will be injected into the marked
injection point.

## Wiring methods

*Petite* also may use method injection points for wiring. Any method
marked with `@PetiteInject` annotation is method injection point.
References will be injected through any number of method arguments:

~~~~~ java
    public class Foo {

    	@PetiteInject
    	void injectBoo(Boo boo) {...}

    	public void foo() {
    		boo.boo();
    	}
    }
~~~~~

By default, reference names are resolved in the same way as for
properties. Note that argument names are available using *Paramo*
(another *Jodd* tool for resolving method argument names from bytecode), but
only if classes are compiled in debug mode. To inject differently named
references, they have to be specified in value element of
`@PetiteInject` annotation, separated by comma.

~~~~~ java
    public class Foo {

    	@PetiteInject("boo, one")
    	void injectBoo(Boo boo, ServiceOne one) {...}

    	public void foo() {
    		boo.boo();
    	}
    }
~~~~~

## Wiring constructors

Similarly, *Petite* provides wiring using constructor injection points.
In above example, `Foo` class may be modified as:

~~~~~ java
    public class Foo {

    	final Boo boo;

    	@PetiteInject
    	public Foo(Boo boo) {
    		this.boo = boo;
    	}

    	public void foo() {
    		boo.boo();
    	}
    }
~~~~~

As for method injection points, constructor injection points uses
resolved in the same way as for methods and parameters. Bean names also
may be specified as annotation value comma separated string (as for the
method injection points).

Constructor injection points have some limitations. There must be just
one constructor injection point for bean. If no constructor is
annotated, *Petite* will take either the only available constructor
either the default one (when class has more then one constructor).

## Scopes

With *Petite* it is also possible to control the **scope** of the
objects created from a particular bean definition. Within bean scope
there is one and only one instance associated with the bean name. Scopes
are defined during the registration and container then maintains
instances within the scopes. When bean is lookuped by its name, *Petite*
will return instance that is unique for bean's scope.

*Petite* supports several scopes, however, it is possible and easy to
create new ones.

Two most common and used scopes are: `ProtoScope` and `SingletonScope`.
`SingletonScope` is also the default scope, used when not specified
explicitly. Beans of this scope are unique for the whole *Petite*
container and will be instantiated by container only once. On the other
hand, beans of `ProtoScope` are instantiated every time when lookuped.

Scope is defined during bean registration:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    petite.registerBean(Foo.class, null, ProtoScope.class, null, false);
    petite.registerBean(Boo.class, null, null, null, false);
~~~~~

or alternatively:

~~~~~ java
    registry.bean(Foo.class).scope(ProtoScope.class).register();
    registry.bean(Boo.class).register();
~~~~~

Now, each time when `foo` is lookuped from the container, a new
instance of `Foo` class will be created. And each time *Petite* will
inject the same instance of `Boo` class, since scope of \'boo\' bean is
(implicitly set as) `SingletonScope`.

Here is the list of available *Petite* scopes:

* `ProtoScope` - beans are created each time requested.
* `SingletonScope` - beans are singletons for the container.
* `SessionScope` - beans are singletons in current HTTP session. To have
  this feature, `HttpSessionListenerBroadcaster` and
  `RequestContextListener` must be used.
* `ThreadLocalScope` - beans are unique in current thread.

## Init methods

*Petite* may invoke so-called **init methods** before bean instance is
returned from container. Init methods are no-argument methods marked
with annotation `@PetiteInitMethod`. Example:

~~~~~ java
    public class Boo {
    	...

    	@PetiteInitMethod
    	void init() {}
    }
~~~~~

By default, *Petite* will invoke init methods in unpredictable order
(depends on JVM). Usually, it is the declaration order of methods in the
class, but we can not guarantee that.

It is possible to specify the execution order of init methods, by
setting `@PetiteInitMethod` element `order`. Order is a simple integer
number. If order value is negative, those methods will be invoked last,
starting from lesser number. For example, if methods are ordered as: -1
and -3, the first will be invoked method marked with order -3 and -1
will be the last method. If order is not used, method will be invoked
after the first ones (marked with positive order number) and the last
ones (marked with negative order).

There are three different invocation strategies, that defines when init
methods will be actually invoked: 2.  `POST_CONSTRUCT` - invoked just
after bean is created, before wiring
    and parameters injection.
 4.  `POST_DEFINED` - invoked after bean has been wired with other
beans,
    but before parameters injection
 6.  `POST_INITALIZED` - invoked after bean has been completely
    initialized, after the [parameters injection](/doc/petite/parameters.html). This is default.

## Automatic registration

In all above examples, beans were registered into *Petite* container
manually. Moreover, *Petite* offers automatic registration using
`AutomagicPetiteConfigurator`\: it will scan the classpath for all
classes annotated with `@PetiteBean` annotation and will automatically
register them. Class scanning of `@PetiteBean` is quite fast: only byte
content is examined, so no other class is loaded during this process
then marked ones. Then, it is possible to narrow the searched class path
and so on. Example:

~~~~~ java
    @PetiteBean
    public class Foo {
    ...

    @PetiteBean
    public class Boo {
    ...
~~~~~

Petite automagic:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    AutomagicPetiteConfigurator petiteConfigurator = new AutomagicPetiteConfigurator();
    petite.configure(petiteConfigurator);
~~~~~

Now all *Petite*\'s beans founded on the classpath will be registered in
the container.

It is perfectly fine to combine automatic and manual configurations.
`@PetiteBean` annotation is also considered during manual bean
registration, so marked beans may be also manually registered just by
class reference, other properties will be read from the annotation's
elements.

## @PetiteBean

`@PetiteBean` is a simple *Petite* bean marker that contains just few
elements:

* `value` - defines bean's name; by default bean name equals to
  uncapitalized bean class name.
* `scope` - bean's scope, by default it is `DefaultScope`.
* `wiring` - wiring mode (more later).

Although `@PetiteBean` is used for automatic registration, it will be
also checked during manual registration!

## Wiring modes

*Petite* supports several wiring modes of registered beans:

* `NONE` - no wiring, used in (rare) cases to prevent any possible
  wiring at all.
* `DEFAULT` - wiring mode is set by *Petite* container configuration.
* `STRICT` - strict wiring affects only property injection points. When
  strict mode is active, *Petite* only considers annotated fields (with
  `@PetiteInjection`) and throws an exception if required reference
  doesn't exist.
* `OPTIONAL` - relaxed version of previous mode also inject only with
  annotated fields, but doesn't throw any exception for missing
  references.
* `AUTOWIRE` - tries to inject value in all bean fields. Missing
  references are ignored. Since all fields are examined, this mode is
  slightly slowest of all above. If field is annotated, injection
  information will be resolved from annotation, as usual.

Wiring mode of a bean may be defined independently from container.

## Accessing bean properties

It is possible to write and read property values of beans from *Petite*
context. This functionality is similar to `BeanUtil`, except it is
applied on *Petite* context:

~~~~~ java
	PetiteContainer pc = new PetiteContainer();
	pc.registerBean(PojoBean.class, "pojo", null, null, false);

	pc.setBeanProperty("pojo.foo1", "value");
	pc.getBeanProperty("pojo.foo2");

	pc.setBeanProperty("pojo.bean2.foo3", Integer.valueOf(173));
~~~~~

The only difference from `BeanUtil` is that first part of the property
path (`pojo`) is actually the name of a registered bean.
