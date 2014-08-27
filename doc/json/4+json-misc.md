# Miscellaneous JSON

*Jodd* *Json* has more tricks in its sleeves.

## Convert bean to map

Sometimes you may want to convert an object into a map, using the
`JsonSerializer` exclude/include rules. This can be done
with `BeanSerializer`, in few steps like this:

~~~~~ java
	final Map<String, Object> map = new HashMap<String, Object>();

	JsonContext jsonContext = new JsonSerializer().createJsonContext(null);

	BeanSerializer beanSerializer = new BeanSerializer(jsonContext, bean) {
		@Override
		protected void onSerializableProperty(
				String propertyName, Class propertyType, Object value) {
			map.put(propertyName, value);
		}
	};

	beanSerializer.serialize();
~~~~~

`BeanSerializer` parse beans and match properties to all include/exclude rules.
Resulting map will contain all _included_ properties of a bean.
Serializing this map or the bean should give exactly the same results!

This may be handy if you have some further filtering options on some bean.

## Use JsonWriter

`JsonWriter` is simple class that writes JSON to the output.
You can use it to construct JSON directly, without serialization:

~~~~~ java
	StringBuilder sb = new StringBuilder();
	JsonWriter jsonWriter = new JsonWriter(sb);

	jsonWriter.writeOpenObject();
	jsonWriter.writeName("one");
	jsonWriter.writeNumber(Long.valueOf(123));
	jsonWriter.writeComma();
	jsonWriter.writeName("two");
	jsonWriter.writeString("UberLight");
	jsonWriter.writeCloseObject();
~~~~~

This can be handy when e.g. you need to wrap your serialized JSON
into another simple map. Instead of creating a new `Map` object
you can simply use the writer with the JSON result to create the
same thing, but faster.

## Global configuration

Most of the configurations for `JsonSerializer` and `JsonParser` can be set
on global level, too. Class `JoddJson` holds the default configuration.

Enjoy!

<js>docnav('json')</js>