<js>javadoc('json')</js>

# Jodd JSON

JavaScript Object Notation (aka [JSON](http://json.org/)) is a
very popular lightweight data-interchange format.
*Jodd* *Json* is lightweight library for (de)serializing
Java objects into and from JSON.

Before you say: "_Yet another one?_", please check what makes *Json* different.
The power of *Jodd* *Json* library is its control over the process
of serialization and parsing; ease of use and great performances.

## Quick go

Let's see how it looks working with *Json*:

~~~~~ java
	Book book = new Book();

	String json = new JsonSerializer()
			.include("authors")
			.serialize(book);

	Book book2 = new JsonParser()
			.parse(json, Book.class);
~~~~~

This is just a tip of the json-berg! Continue with more
details about the [serializer](json-serializer.html) and
[parser](json-parser.html).

<js>docnav('json')</js>