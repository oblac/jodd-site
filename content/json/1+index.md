---
javadoc: 'json'
---

# Jodd JSON

JavaScript Object Notation (aka [JSON](http://json.org/)) is a very popular lightweight data-interchange format. *Jodd* *Json* is lightweight library for (de)serializing Java objects into and from JSON.

Before you say: "_Yet another one?_", please check what makes *Json* different. The power of *Jodd* *Json* library is its control over the process of serialization and parsing; ease of use and great performances.

## Quick Start

Let's see how it looks working with *Json*:

~~~~~ java
	Book book = library.getBook("Jodd In Action");

	String json = JsonSerializer.create()
			.include("authors")
			.serialize(book);
~~~~~

The resulting JSON may look like this:

~~~~~json
    {
    	"name" : "Jodd In Action",
    	"year" : 2018,
    	"authors" : [
    		{ "firstName" : "Igor" }
    	]
    }
~~~~~

Finally, parse it back:

~~~~~ java
	Book book2 = new JsonParser()
			.parse(json, Book.class);
~~~~~

Pretty simple, right? But don't get blinded by the simplicity, *Json* is pretty powerful. Did I mention it is on of the fastest JSON frameworks out there?

## Values

+ simple syntax and fluent interface,
+ lazy parser that is super fast,
+ annotations for better conversion control,
+ convenient `JSONObject` and `JSONArray` classes,
+ powerful exclusion and inclusion rules,
+ serializer definition for types,
+ the only library that can handle any number size,
+ pretty formatting of the JSON output,
+ loose, more forgiving, parsing mode,
+ ways to address keys and values of the Maps
+ flexible fine-tuning,
+ and more...

Continue with more details about the [serializer](json-serializer.html) and [parser](json-parser.html).

