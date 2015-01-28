# Json Parser

*Jodd* *Json* parser reads JSON string and converts it into objects (i.e. object
graph). This can be quite complex task as JSON text contains no type
information. So mapping JSON data to Java objects may be tricky. *Jodd* *Json*
tries to make this mapping easy as possible, by using class property types
to map untyped generic JSON values into specific Java type. And *Jodd* does
the magic very fast.

## Basic usage

Main parser class is `JsonParser`. When no target type is provided, parser
will convert JSON objects and arrays to Java `Map`s and `List`s. Like this:

~~~~~ java
	JsonParser jsonParser = new JsonParser();
	Map map = jsonParser.parse(
		"{ \"one\" : { \"two\" : 285 }, \"three\" : true}");
~~~~~

This simple JSON is converted into a `Map` that contains 2 keys. One of the keys
(`one`) holds another `Map` instance. As you can see from the example, simple
JSON data types are converted into their counter-part Java types. Boolean value
is converted to `Boolean`, number is converted to a `Number` or `BigInteger`
etc. `JsonParser` finds the best possible type; for example, if number can
be stored into an `int` then `Integer` is returned, but if it is a decimal
value then `Double` is returned and so on.

Ok, let's now see how to map JSON to types.

## Parsing to types

Let's start with the JSON data:

~~~~~ json
	{
		"name" : "Mak",
		"bars" : {
			"123": {"amount" : 12300},
			"456": {"amount" : 45600}
		},
		"inters" : {
			"letterJ" : {"sign" : "J"},
			"letterO" : {"sign" : "O"},
			"letterD" : {"sign" : "D"}
		}
	}
~~~~~

This data can be mapped to Java type like:

~~~~~ java
	public class User {
		private String name;
		private Map<String, Bar> bars;
		private Map<String, Inter> inters;
		// ...
	}
~~~~~

Property `name` is a simple property. But `bars` is a `Map` of `Bars`:

~~~~~ java
	public class Bar {
		private Integer amount;
		// ...
	}
~~~~~

This is no problem for `JsonParser`. It will parse inner JSON maps to `Bar`
types, since the _generic_ type of the property specifies the map's
content type. In the same way `JsonParser` can handle the `inters` map.

~~~~~ java
	JsonParser jsonParser = new JsonParser();
	User user = jsonParser.parse(json, User.class);
~~~~~

`JsonParser` now converts JSON directly to a target type. Let's remember:

`JsonParser` lookups for type information from the target's property. This
includes property type and generics informations.
{: .attn}

Using this approach, `JsonParser` can parse complex JSON strings into Java
object graph, as long it can resolve the type information.


### Specifying target type

To introduce some more complexity, let's say that `Inter` is an interface:

~~~~~ java
	public interface Inter {
		public char getSign();
	}
~~~~~

and one of it's implementation is:

~~~~~ java
	public class InterImpl implements Inter {
		protected char sign;

		public char getSign() {
			return sign;
		}
		public void setSign(char sign) {
			this.sign = sign;
		}
	}
~~~~~

Now, this is something `JsonParser` can't figure out by looking at the
`inters` property types and it's generic information. We need to
explicitly specify the target type for maps values. As you could
guess, we can use _path_ to specify the mapping. But in this case,
the path needs to address the values of the map! No problem -
by using special path name `value` we can address all the values
of a map:

~~~~~ java
	User user = new JsonParser()
			.map("inters.values", InterImpl.class)
			.parse(json, User.class);
~~~~~

Nice! Similar with the `value`, we could specify the key's type, using the
path reference `keys`. Look at the following example:

~~~~~ java
	String json = "{\"eee\" : {\"123\" : \"name\"}}";

	Map<String, Map<Long, String>> map =
			new JsonParser()
			.map("values.keys", Long.class)
			.parse(json);
~~~~~

We changed the key type of the inner map. This is one more thing to remember:

Use `map()` method to map target type in the result object graph,
specified by it's path.
{: .attn}

Now we have a powerful tool that can parse about any JSON to any Java type.
Here is another example:

~~~~~ json
	{
	  "1": {
	    "first": {
	      "areaCode": "404"
	    },
	    "second": {
	      "name": "Jodd"
	    }
	  }
	}
~~~~~

May be parsed like this:

~~~~~ java
	Map<String, Pair<Phone, Network>> complex = new JsonParser()
			.map("values", Pair.class)
			.map("values.first", Phone.class)
			.map("values.second", Network.class)
			.parse(json);
~~~~~

Each value of returned map is going to be a `Pair` of two different types.

### Alt paths

As seen, path can contain special names like `values` or `keys` to reference
_all_ values of a map or _all_ keys of a map (or of an array). But you can not
change the type of particular map value, since these special paths address
_all_ items.

But there is a solution for this. By enabling the alternative paths
with `.useAltPaths()` we are telling `JsonParser` to match paths
to current map values! By default this option is disabled, for performance
reasons (there is some penalty because more paths are matched).

With alt paths enabled, you can reference any value in the map, too.


### Class metadata name

Sometimes, JSON string does contain an information about the target type,
stored in 'special' key like `class` or `__class`. If you have such JSON
or if you have used this option with `JsonSerializer`, you can enable this
feature with `JsonParser` as well:

~~~~~ java
	Target target =
			new JsonParser()
			.setClassMetadataName("class")
			.parse(json);
~~~~~

Now every JSON map will be scanned for this special key `class`
that holds the full class name of the target. But be careful:

Using class metadata name with `JsonParser` slows down the
parser.
{: .attn}

Every JSON map first must be converted to a `Map` so we can fetch the class name
and then converted to a target class. Because of this double conversion expect
performance penalties if using class metada name.

## Type conversion

As for everything in *Jodd*, `JoddParser` uses powerful `TypeConverter`
to convert between strings to real types.

## Value converters

Sometimes data comes in different flavors. For example, `Date` may be specified
as a string in `yyyy/MM/dd` format and not as a number of milliseconds.
So we need to explicitly convert the string into `Date`. For that
we can use `ValueConverter`:

~~~~~ java
	final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");

	Person person = new JsonParser()
			.use("birthdate", new ValueConverter<String, Date>() {
				public Date convert(String data) {
					try {
						return dateFormat.parse(data);
					} catch (ParseException pe) {
						throw new JsonException(pe);
					}
				}
			})
			.parse(json, Person.class);
~~~~~

It's clear what we did here.

## Loose mode

By default, *Json* parser consumes only valid JSON strings. If JSON
string is not valid, an exception is thrown with detailed message
of why parsing failed.

But real-world often does not play by the rules ;) Therefore, `JsonParser`
may run in so-called _loose_ mode, when it can process more:

~~~~~ java
	JsonParser jsonParser = new JsonParser().looseMode(true);
~~~~~

Here is what loose mode may handle:

+ both single and double quotes are accepted.
+ invalid escape characters are just added to the ouput.
+ strings may be unquoted, too.

For example, `JsonParser` in loose mode may parse the following input:

~~~~~
	{
		key : value,
		'my' : 'hol\\x'
	}
~~~~~

This JSON is not valid, but it can be parsed, too.

## Go out and play

This was a small summary of *Jodd* *Json* features. See testcases for more :)
