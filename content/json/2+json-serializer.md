# Json Serializer

`JsonSerializer` serializes objects into JSON strings. Create an instance of the serializer, configure it and you're done! You may re-use the `JsonSerializer` instances (i.e. configurations). Let's see more on how serialization works.

## Basic usage

Create the new instance of `JsonSerializer` and pass an object to serialize:

~~~~~ java
	JsonSerializer jsonSerializer = new JsonSerializer();
	String json = jsonSerializer.serialize(object);
~~~~~

or as a one-liner:

~~~~~ java
	String json = JsonSerializer.create().serialize(object);
~~~~~

Thats it! `JsonSerializer` process the target object according to it's type. It recognizes arrays, lists, maps, collections, strings, numbers etc. and returns them in correct JSON format.

If you pass an object, `JsonSerializer` will scan all it's properties (defined by getters) and create JSON map from it. Each property of a bean will be also serialized according to it's type and so on. Of course, `JsonSerializer` detects circular dependencies (by checking objects identity).

There is one important default behavior of `JsonSerializer`:

Collections (lists, arrays...) are **not** serialized by default.
{: .attn}

This plays well with some 3rd party libraries (like ORM) where collections represents lazy relationships.

### Path

JSON serialization is recursive: all properties of target bean gets serialized and so on. During the serialization, `JsonSerializer` browse the 'object graph' of given object. Current serialization position is determined by the _path_: a string that consist of dot-separated property names up to the current position.

Path is a reference of a property in object's graph.
{: .attn}

For example, the path may be `user.work.prefix`. This mean that we can get it's value in Java by calling: `getUser().getWork().getPrefix()` on target object.

## Deep serialization

If you want to serialize _everything_, including the collections, don't worry! Just set the `deep` flag to `true`:

~~~~~ java
	String json = jsonSerializer.create().deep(true).serialize(object);
~~~~~

Object will be fully serialized. If all your use-cases uses deep serialization, it's easy to enable it globally in the [configuration](configuration.html).

## Class name meta data

By default, `JsonSerializer` does **not** outputs object's class name. However, sometimes we want to preserve the type of serialized object (especially if we want to parse the JSON string back into object). To do this, just enable this feature:

~~~~~ java
	JsonSerializer.create()
		.setClassMetadataName("class")
		.serialize(object);
~~~~~

This feature can be enabled to be default, too.

## JSON Type Serializers

`JsonSerializer` knows to serializes primitives, collections, strings, integers and various Java types that are commonly used as bean properties. For each type, there is a `TypeJsonSerializer` instance that defines how type is serialized to a JSON.

It is possible to add custom serializer for a type. We can:

+ register custom serializer for a type, so all instances of this type would be registered the same way, or
+ we can bind a property path to custom serializer:

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

*Jodd* *Json* comes with default set of type serializers that should cover all common types and needs. However, don't hesitate to build your own type serializer when needed.

## Pretty JSON

Default JSON output is not human readable as it does not have any line break. There is a pretty version of a serializer that returns beautiful JSON:

~~~~~ java
	JsonSerializer serializer = new PrettyJsonSerializer();
	//...
~~~~~

or as one-liner:

~~~~~ java
	JsonSerializer.createPrettyOne()
	//...
~~~~~

User can control the indentation size and used character.
