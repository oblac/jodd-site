# Injection

**Injection** is the process of setting action object properties from
various scopes. Similarly, **outjection** is the process of setting
attributes of various scopes with values of action object properties.
Injection is usually executed by some interceptor (such:
`ServletConfigInterceptor`) before action method invocation, while
outjection is executed after the invocation, before result rendering.

Injection and outjection is performed by so-called **injectors**.
Injectors are simple Java classes that contains all necessary logic,
usually for single scope.

All injectors scan action object for injection points. Injection point
is a spot annotated with `@In` and/or `@Out` annotations. There are
three possible spots that can be an injection point:

+ object property - you can put annotation either on just field or on
  access method (getter/setter). It is a good practice to just annotate
  the fields, to keep the action class small and clean.
+ inner class property - you can group your injection properties into inner
  classes, and then use this class as action method argument.
  This approach make sense when your action class contains few action methods
  and each one has a lot of properties to process. btw, it does not have
  to be an inner class, but its the best practice.
+ action method arguments - and finally, you can annotate method arguments.
  This way your action method is complete handler. However, this approach
  has few drawbacks, more on that later.

Since this is just a matter of semantics, we will discuss these little
bit later.

## Scopes

*Madvoc* recognize following scopes, defined by `ScopeType`:

* `REQUEST` - HTTP request scope: request attributes and
  parameters. *Madvoc* detects multi-part requests and encapsulates
  uploaded files.
* `SESSION` - HTTP session scope: session attributes.
* `COOKIE` - read/set cookies.
* `BODY` - read HTTP body.
* `APPLICATION` - servlet context scope.
* `SERVLET` - special scope for injecting servlet-related
  objects (request, session...). Servlet objects may be used directly or
  via map adapter.
* `CONTEXT` - special scope for injecting *Madvoc* components.

Scope is defined with `@Scope` annotation.

## @In

Properties annotated with `@In` annotation are marked as injection
targets.

Example:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@In
    	MutableInteger data;

    	@In
    	private String name;
    	public void setName(String name) {
    		this.name = name + "xxx";
    	}

    	@Action
    	public void world() {
    	}
    }
~~~~~

Above code shows several injection features. First, property `data` is defined just as class field (no setter/getter). Notice that *Madvoc* performs implicit type conversion to the target type. Ssecond property shows how its setter will be invoked during the injection and will change the injection value.

### Entity mapping

Very often input forms matches entities (aka domain objects, dto
objects, entity beans...). *Madvoc* offers easy way to map input
parameters to entity objects.

For example, some POJO object `Person` has simple properties: name, data
etc. Now, there is a form where application user enters data for the
person. If the form input fields are named in the following way:

~~~~~ html
    <form action="...">
    	name: <input type="text" name="p.name"><br>
    	data: <input type="text" name="p.data"><br>
    	<input type="submit">
    </form>
~~~~~

Request parameters `p.name` and `p.data` may be mapped in the
following way:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@In("p")
    	Person person;

    	@Action
    	public void world() {
    	}
    }
~~~~~

Request injectors will create a new instance of `Person` (since `create`
element of `@In` is `true` by default) and inject values for name and
data properties. Of course, in the real life, input fields would be
named more meaningfully as `person.xxx` instead of `p.xxx`.

### Entity list mapping

*Madvoc* offers way to map list of entity data in similar manner. For
example, some input form may contain list of `Person` objects, where
each person element is named as: `ppp[index].xxx`:

~~~~~ html
    <form action="...">
    	name 1: <input type="text" name="ppp[0].name"><br>
    	data 1: <input type="text" name="ppp[0].data"><br>
    	name 2: <input type="text" name="ppp[1].name"><br>
    	data 2: <input type="text" name="ppp[1].data"><br>
    	...
    	<input type="submit">
    </form>
~~~~~

This form may be mapped in the several ways:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@In("ppp")
    	List<Person> plist;

    	@In("ppp")
    	Person[] parray;

    	@In("ppp")
    	Map<String, Person> pmap;

    	@Action
    	public void world() {
    	}
    }
~~~~~

*Madvoc* recognizes correct type from generics declaration! Of course,
in the real-life, input fields would be named more meaningfully as
`person.xxx` instead of `ppp.xxx`.

### Context and Servlet scope

*Madvoc* context and servlet scopes provide more data to the action object. It allows to inject the following:

* servlet objects: when `@In` property is type of `HttpServletRequest`,
  `HttpSession`, `ServletContext`. Property name is ignored, just
  property type is considered.
* adapter map for servlet objects: when `@In` property is named as:
  `requestMap`, `sessionMap `or `contextMap`, corresponding map adapter
  will be injected in the property. Of course, it is expected that
  property type is `Map`.
* *Madvoc* components: it is possible to inject any of registered
  internal *Madvoc* components.

Example:

~~~~~ java
    @MadvocAction
    public class MiscAction {

    	@In @Scope(SERVLET)
    	Map<String, Object> sessionMap;

    	@In("requestMap") @Scope(SERVLET)
    	Map<String, Object> rmap;

    	@In @Scope(SERVLET)
    	Map<String, Object> contextMap;

    	@In @Scope(SERVLET)
    	HttpServletResponse servletResponse;

    	...
~~~~~

## Results & Injectors

Injection is performed not only on action objects, but on results
handlers and injectors. Both results and injectors are instantiated
lazy, on their first usage. After the instantiation, *Madvoc* controller
will perform the injection, but only for `APPLICATION` and `CONTEXT`
scopes.

## @Out

Similar as for injection, `@Out` annotation is used on action object
properties that has to be outjected to the scopes.

## Injection points in inner classes

When your action has more then one action method, the number of `@In` and `@Out` properties may be big, and usually, some fields are shared for both methods. Such action class does not look pretty and you might loose a track what is injected/outjected for each action method.

For this reason, *Madvoc* supports to group `@In` and `@Out` properties into separated classes that will be parameter(s) for action method. In other words, you may do the following refactoring, from this:

~~~~~ java
	@MadvocAction
	public class MyAction {
		@In String one;
		@Out int two;
		...
		public void view() {}
	}
~~~~~

to this:

~~~~~ java
	@MadvocAction
	public class MyAction {

		class ViewData {
			@In String one;
			@Out int two;
			...
		}
		public void view(ViewData viewData) {}
	}
~~~~~

We just made an inner class that simply groups parameters of one action method. This way you can separate input and outputs between action methods in the same action class.

You may have more the one action method parameter. And you can use inner classes or static classes, or even separate classes for grouping parameters.

## Injection points as action method parameters

Finally, you can use action method parameters as injection points. Example from above:

~~~~~ java
    @MadvocAction
    public class MyAction {
        @In String one;
        @Out int two;
        ...
        public void view() {}
    }
~~~~~

can be written as:

~~~~~ java
    @MadvocAction
    public class MyAction {
        public void view(
            @In String one,
            @Out MutableInteger two) {}
    }
~~~~~

There is one more thing to be careful with: you can't use immutable classes as output injection points. For example, you can't outject `int` or a `String`. All objects have to be created before method is called, so any change after is simply not visible to outside of the method. Thats why we had to use here `MutableInteger` as we can change its value during the method execution.
