# Fine-tune Json Serialization

So far we have seen that `JsonSerializer` excludes the collections, and that this behavior is controlled by the `deep` flag. There is more sophisticated way on how to configure what to serialize. Serialization process can be fine-tuned: properties can be included and excluded. There are several ways how to do this.

## Include/Exclude methods

By using `include()` and `exclude()` methods we can include and exclude a property referenced by it's path. Let's take the following class as an example:

~~~~~ java
	public class Person {

		private String name;
		private Address home;
		private Address work;
		private List<Phone> phones = new ArrayList<Phone>();

		// ... and getters and setters
	}
~~~~~

If we serialize this class using default `JsonSerializer` we will get JSON object with 3 keys: `name`, `home` and `work`. Property `phones` is not serialized by default as it is a collection.

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

Of course, you can specify nested include/exclude paths, like:

~~~~~ java
	String json = JsonSerializer.create()
		.exclude('work')
		.include('phones')
		.exclude('phones.areaCode')
		.serialize(object);
~~~~~

This time we changed how the inner object (`Phone`) is serialized.

Include/exclude paths can contain a _wildcard_ (`*`). Wildcard replaces more properties at once. Wildcard can only substitute whole property names, not partials. Here is how it can be used:

~~~~~ java
	String json = new JsonSerializer
		.exclude('*')
		.include('name')
		.serialize(object);
~~~~~

Resulting JSON map this time contains just one key: `name`, as all others properties are excluded.

## JSON Annotation

Using include/exclude methods can be cumbersome if done frequently. *Json* provides a way to express these rules using annotation. The `@JSON` annotation marks a property (getter or a field) as _included_ by default.

In above example we may say that `Phones` are integral part of a `Person` and that we should always have them serialized. So we can do the following:

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

That's it! But wait, that's not all :) *Json* supports two ways how a class can be annotated:

+ In the _default_ mode, `JSON` annotations simply defines additional properties that have to be included. All other properties, that are not marked with an annotation, are also included according to the rules. This mode is usually used to include collection properties, that are excluded by default.

+ In the _strict_ mode, `JSON` annotation defines **only** properties that have to be included. All other properties, that are not marked with an annotation, are **not** included, even though they should be according to the rules. Strict mode is enabled by annotating the class with the annotation and setting the `strict` element to `true`:

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

Here property `work` is not serialized as it is not annotated and the class is serialized in `strict` mode.

## Custom key names

Furthermore, `JSON` annotation can change the name of the generated keys, e.g.:

~~~~~ java
	public class Person {

		@JSON
		private String name;
		@JSON(name = "home_address")
		private Address home;

		//...
	}
~~~~~

We have changed the name of the `home` property to `home_address`.

## Custom JSON Annotation

An awesome feature is that it is possible to set custom JSON annotation. If you do not want to use default annotation from *Jodd* *Json*, then just create your own annotation and register it. You don't have to copy all annotation fields, just those that you really need.

Custom annotations is a great way how you can integrate *Json* with the existing codebase.

## Excluding types

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
