# Injection

**Injection** is setting action object properties from various _scopes_. Similarly, **outjection** is setting attributes of various scopes from values of action object properties. Injection is usually executed by some interceptor (such: `ServletConfigInterceptor`) before action method invocation, and outjection is executed after the invocation, before result rendering.

Injection and outjection is performed by the **scope**. *Madvoc* scope is a class that simply performs injection and outjection using the values available in some context; such as: request, session, *Madvoc* components... It is perfectly acceptable to add and use custom scopes!

Injection and outjection works on _injection points_. Injection point is a spot annotated with `@In` and/or `@Out` annotations. There are three possible spots that can be an injection point:

+ object's property - you can put annotation either on just field or on access method (getter/setter). It is a good practice to just annotate the fields, to keep the action class small and clean.
+ inner class property - you can group your injection properties into inner classes, and then use this class as action method argument. This approach make sense when your action class contains few action methods and each one has a lot of properties to process. Btw, it does not have to be an inner class, but its the best practice.
+ action method arguments - and finally, you can annotate method arguments. This way your action method is complete handler. However, this approach has few drawbacks, more on that later.


## @In

Properties annotated with `@In` annotation are injection targets. Example:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@In
    	MutableInteger data;

    	@In
    	private String name;
    	public void setName(String name) {
    		this.name = name + "jodd";
    	}

    	@Action
    	public void world() {
    	}
    }
~~~~~

The first property (`data`) is defined just as class field (no setter/getter). Notice that *Madvoc* performs implicit type conversion to the target type. Second property shows how its setter will be invoked during the injection and will change the injection value.

### Entity mapping

Very often input forms matches entities (aka domain objects, dto objects, entity beans...). *Madvoc* offers easy way to map input parameters to entity objects.

For example, some POJO object `Person` has simple properties: name, data etc. Now, there is a form where application user enters data for the person. If the form input fields are named in the following way:

~~~~~ html
    <form action="...">
    	name: <input type="text" name="p.name"><br>
    	data: <input type="text" name="p.data"><br>
    	<input type="submit">
    </form>
~~~~~

Request parameters `p.name` and `p.data` may be mapped in the following way:

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

Request injectors will create a new instance of `Person` and inject values for `name` and `data`.

### Mapping to list of entities

*Madvoc* offers way to map list of entity data in similar manner. For example, some input form may contain list of `Person` objects, where each person element is named as: `ppp[index].xxx`:

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

*Madvoc* recognizes correct type from generics declaration.

## Results & Injectors

Injection is performed not only on action objects, but on results handlers and injectors. In other words, each *Madvoc* _web component_ will be considered for injection. For some web components, like actions, we can use any available scope to inject from. For others, we can use only Madvoc and servlet context scope.

## @Out

`@Out` annotation is used on action object properties that has to be outjected to the scopes.

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
