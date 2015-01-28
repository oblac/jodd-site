# Json Serializer

*Jodd* *Json* serializer converts your objects into JSON strings.
The main class to use is `JsonSerializer`. Workflow is easy:
create an instance of this class, configure it
and then we are ready to serialize objects.
You may re-use the same `JsonSerializer` instance
(i.e. configuration) for more than one serialization.
Let's see more on how serialization works.

## Basic usage

Create the new instance of `JsonSerializer` and pass
an object we want to serialize:

~~~~~ java
	JsonSerializer jsonSerializer = new JsonSerializer();
	String json = jsonSerializer.serialize(object);
~~~~~

Thats it! `JsonSerializer` process our target object according to it's
type. It recognizes arrays, lists, maps, collections, strings,
numbers etc. and returns them in correct JSON format.

If you pass an object, `JsonSerializer` will scan all it's properties
(defined by getters) and create JSON map from it. Each property
of a bean will be also serialized according to it's type and so on.
Of course, `JsonSerializer` detects circular dependencies
(by checking objects identity).

There is one important default behavior of `JsonSerializer`:

Collections (lists, arrays...) are **not** serialized by default.
{: .attn}

This plays well with some 3rd party libraries (like ORM) where
collections represents lazy relationships.

### Path

JSON serialization is recursive: all properties of target object
gets serialized and so on, until the simple types. During the serialization,
`JsonSerializer` browse the 'object graph' of given object. Current
serialization position is determined by the _path_: string that
consist of dot-separated property names up to this position.

Paths are used to reference a property in object graph of a target.
{: .attn}

For example, the path may be `user.work.prefix`. This mean that we can
get it's value in Java by calling: `getUser().getWork().getPrefix()` on
target object.

## Deep serialization

If you want to serialize _everything_, don't worry! Just set the `deep`
flag to `true`:

~~~~~ java
	JsonSerializer jsonSerializer = new JsonSerializer();
	String json = jsonSerializer.deep(true).serialize(object);
~~~~~

Object will be fully serialized now.

## Filtering properties

Serialization process can be fine-tuned: properties can
be included and excluded from serialization. There
are several ways how this can be done.

### Include/Exclude methods

By using `include()` and `exclude()` methods we can include
and exclude property referenced by it's path. Let's take
the following class as an example:

~~~~~ java
public class Person {

	private String name;
	private Address home;
	private Address work;
	private List<Phone> phones = new ArrayList<Phone>();

	// ... and getters and setters
}
~~~~~

If we serialize this class using default `JsonSerializer` we
will get JSON map with 3 keys: `name`, `home` and `work`.
Property `phones` is not serialized by default as it is a list.

We can include `phones` with the following code:

~~~~~ java
	String json = new JsonSerializer
		.include('phones')
		.serialize(object);
~~~~~

In the same way we can exclude a property. For example:

~~~~~ java
	String json = new JsonSerializer
		.exclude('work')
		.include('phones')
		.serialize(object);
~~~~~

Resulting JSON in this case would also be a map with 3 keys:
`name`, `home` and `phones`.

Of course, you can specify deeper include/exclude paths, like:

~~~~~ java
	String json = new JsonSerializer
		.exclude('work')
		.include('phones')
		.exclude('phones.areaCode')
		.serialize(object);
~~~~~

This time we changed how inner object (`Phone`) is serialized.

Include/exclude paths can contain a _wildcard_ (`*`). Wildcard
replaces more properties at once. Wildcard can only replace whole
property names, not partial. Here is how it can be used:

~~~~~ java
	String json = new JsonSerializer
		.exclude('*')
		.include('name')
		.serialize(object);
~~~~~

Resulting JSON map this time contains just one key: `name`, as
all others properties are excluded.

### JSON Annotation

Using include/exclude methods can be cumbersome especially if you
always intend something to be excluded or included. *Json* provides
a way to express this using annotation. The `JSON` annotation can be used
to mark a property (getter or a field) in the object as included by default.

In above example we may say that `Phones` are integral part of
a `Person` and that we should always have them serialized. So
we can do the following:

~~~~~ java
	public class Person {

		private String name;
		private Address home;
		private Address work;
		@JSON
		private List<Phone> phones = new ArrayList<Phone>();

		// ... and getters and setters
	}
~~~~~

That's it! But wait, that's not all :) *Json* supports
two ways how a class can be annotated:

+ In the _default_ mode, `JSON` annotations simply defines
additional properties that have to be included. All other
properties, that are not marked with an annotation, are also
included according to the rules. This mode is usually used
to include collection properties, that are excluded by default.

+ In the _strict_ mode, `JSON` annotation defines **only**
properties that have to be included. All other properties,
that are not marked with an annotation, are **not** included,
even though they should be according to the rules.
Strict mode is enabled by annotating the class with the annotation
and setting the `strict` element to `true`:

~~~~~ java
	@JSON(strict = true)
	public class Person {

		@JSON
		private String name;
		@JSON
		private Address home;
		private Address work;
		@JSON
		private List<Phone> phones = new ArrayList<Phone>();

		// ... and getters and setters
	}
~~~~~

Here property `work` is not serialized as it is not annotated and the
class is serialized in `strict` mode.

Furthermore, by using `JSON` annotation we can change the name of
the generated key, e.g.:

~~~~~ java
	public class Person {

		@JSON
		private String name;
		@JSON(name = "home_address")
		private Address home;

		//...
	}
~~~~~

We have changed the name of the `home` property to appear as `home_address`.

### Excluding types

We can also exclude properties of certain type or that matches certain
type name wildcard pattern. Sometimes we need to serialize complex
beans that contain properties that are meaningless for the serialization,
like streams. We can exclude such properties from getting serialized:

~~~~~ java
	new JsonSerializer()
		.excludeTypes(InputStream.class)
		.serialize(object);
~~~~~

This will exclude properties that are of `InputStream` type. We could also
add the following rule:

~~~~~ java
	new JsonSerializer()
		.excludeTypes(InputStream.class)
		.excludeTypes("javax.*")
		.serialize(object);
~~~~~

where the whole package gets excluded.

## Class name meta data

By default, `JsonSerializer` does **not** outputs
object's class name. However, sometimes we want
to preserve the type of serialized object (especially
if we want to parse the JSON string back into object).
To do this, just enable this feature:

~~~~~ java
	new JsonSerializer()
		.setClassMetadataName("class")
		.serialize(object);
~~~~~

Good thing is that we may pass the class key name.

## JSON Type Serializers

`JsonSerializer` knows to serializes common types.
This knowledge is defined in implementations of `TypeJsonSerializer`.
These implementations know how to serialize certain type.
`TypeJsonSerializerMap` contains default bindings between
types and theirs JSON serializers.

Of course, it is possible to add custom type serializers.
For example, we might want to change how `Date` is serialized:
instead as milliseconds number, we can serialize it as a date string.

Again we have options:) We can bind custom serializer to a type,
so all `Date` properties in our example will be serialized in a custom
way; or we can bind single property to custom serializer, using it's path:

~~~~~ java
	final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
	String json = new JsonSerializer()
			.use("birthdate", new DateJsonSerializer() {
				@Override
				public void serialize(JsonContext jsonContext, Date date) {
					jsonContext.writeString(dateFormat.format(date));
				}
			})
			.serialize(foo);
~~~~~

*Jodd* *Json* comes with default set of type serializers that should cover
all common types and needs. Hower, don't hesitate to build your own type
serializer when needed.


## Global configuration

In all above examples we have been configuring the `JsonSerializer`
instance. If we need to set up permanent changes, that would
apply on whole application, then we would use `JoddJson` class instead.
This is module's class and contains defaults configuration values
for all of above settings.

### Custom JSON annotation

One great thing about configuration is that it is possible
to set custom JSON annotation. If you do not want to use
default annotation from *Jodd* *Json*, then just create
your own annotation and register it. Custom annotation may contain
all or only some elements; and it may contain some custom
additional data.

Power to the people!
