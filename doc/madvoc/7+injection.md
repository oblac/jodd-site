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

All injectors scan action object for properties annotated with `@In` and
`@Out` annotations. Action object properties may have accessors methods
(getters and setters), but this is not necessary - even more, it is
recommended just to use default scoped plain fields. Action then becomes
very clean and much smaller.

## Scopes

*Madvoc* recognize following scopes:

* `ScopeType.REQUEST` - HTTP request scope: request attributes and
  parameters. *Madvoc* detects multi-part requests and encapsulates
  uploaded files.
* `ScopeType.SESSION` - HTTP session scope: session attributes.
* `ScopeType.APPLICATION` - servlet context scope.
* `ScopeType.SERVET` - special scope for injecting servlet-related
  objects (request, session...). Servlet objects may be used directly or
  via map adapter.
* `ScopeType.CONTEXT` - special scope for injecting *Madvoc* components.

## @In

Properties annotated with `@In` annotation are marked as injection
targets. This annotation has the following elements:

* `value` - name of scope value, if different then property name;
* `create` - specifies if fields should be created if not found (if they
  are `null`);
* `remove` - specifies if value should be removed from the scope, if
  possible, after injection;
* `scope` - indicates the scope, default is `ScopeType.REQUEST`.

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

Above code shows several injection features. First, property \'data\' is
defined just as class field (no setter/getter). Then, it shows that
*Madvoc* performs implicit type conversion to the target type. This is
done using [`BeanUtil`](/doc/beanutil.html), Madvocs bean manipulator.
Then, second property shows how its setter will be invoked during the
injection and will change the injection value.

## Entity mapping

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

Request parameters \'p.name\' and \'p.data\' may be mapped in the
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
named more meaningfully as \'person.xxx\' instead of \'p.xxx\'.

## Entity list mapping

*Madvoc* offers way to map list of entity data in similar manner. For
example, some input form may contain list of `Person` objects, where
each person element is named as: \'ppp\[index\].xxx\':

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
\'person.xxx\' instead of \'ppp.xxx\'.

## Context and Servlet scope

*Madvoc* context and servlet scope are special scopes. Their purpose is
to provide special data to the action object. It allows to inject the
following:

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

    	@In(scope = ScopeType.SERVLET)
    	Map<String, Object> sessionMap;

    	@In(value="requestMap", scope = ScopeType.SERVLET)
    	Map<String, Object> rmap;

    	@In(scope = ScopeType.SERVLET)
    	Map<String, Object> contextMap;

    	@In(scope = ScopeType.SERVLET)
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
properties that has to be outjected to the scopes. `@Out` annotation has
only two elements: `value` and `scope`, with the same meaning as of
`@In`.

## @InOut

Just a shortcut for both `@In` and `@Out` annotations. May be useful
when property name differs from scope value name.

