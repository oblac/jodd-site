# Type Converter

Type converter is part of *Jodd* responsible for converting value of one
type into another. For example, it may convert a `String` representation
of a number into an `Integer`.

Each destination type has its own `TypeConverter`. Type converter
'knows' how to convert any value to destination type, if possible. So,
for example, `BooleanConverter` may convert strings "no",
"1", "true"... into correct boolean value.

There are many type converters available, for full list check javadoc.
Besides common conversions (from/to string and numeric types) there are
a lot more conversions. So you can convert into string arrays, class
names to classes...

All type converters are registered with `TypeConverterManager`. It is a
central place where all type converters are registered and from where
you can lookup for some that you need.

Type converter is used all over *Jodd*. It is used by
[BeanUtil](/beanutil), [DB framework](/db/),
[Madvoc](/madvoc/)...

## Convert utility

`Convert` utility class is one big class with many conversion methods
for common types, made for convenient and *faster* type conversion. With
`Convert` methods it is possible to perform the type conversion using
just a single line of code.

## Usage

### Lookup type converter

~~~~ java
    TypeConverter tc = TypeConverterManager.lookup(String.class);
    tc.convert(Integer.valueOf(123)
~~~~~

Using faster Convert class when target type is known

~~~~~ java
    Integer i = Convert.toInteger("173");
~~~~~

Full conversion (preferred when can't do with `Convert`)

~~~~~ java
    TypeConverterManager.convertType("173", Integer.class);
~~~~~

This is the most complete way how to convert types. Not only that this method lookups for the type converter, it also performs additional conversions, like recognizing arrays and enums.

## Custom type converter

New type converters are easy to add: just implement the interface and register it in the manager. From that point, new custom type is available all over the *Jodd* frameworks.
