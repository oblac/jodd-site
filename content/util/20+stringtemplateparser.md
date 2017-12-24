# StringTemplateParser

`StringTemplateParser` is the parser for string templates, where macros are
defined with markers. During the parsing, macros are replaced by
their values.

Usage of `StringTemplateParser` is simple:

~~~~~ java
    StringTemplateParser stp = new StringTemplateParser();
    stp.parse("xxx${small}xxx", String::toUpperCase);
~~~~~

The `parse()` method takes two arguments: the first is the template to parse. The second argument is a function that converts founded macros with the replacement values. In this example we simply convert a string to upper case.


## MapTemplateParser

While `StringTemplateParser` has generic usage, more convenient implementation is the `MapTemplateParser`. It replaces macros with the map value:

~~~~~ java
    String template = "Hello ${foo}. Today is ${dayName}.";
    ...

    // prepare data
    Map<String, String> map = new HashMap<String, String>();
    map.put("foo", "Jodd");
    map.put("dayName", "Sunday");
    ...

    // parse
    ContextTemplateParser ctp = MapTemplateParser.of(map);

    String result = ctp.parse(template);

    // result == "Hello Jodd. Today is Sunday."
~~~~~

The parsing is done in two steps: the first is creation of `ContextTemplateParser` and the second is the actual call to `parse()` method. This is done in two steps as often we can re-use created `ContextTemplateParser` and repeat parsing on multiple input templates.


## BeanTemplateParser

`BeanTemplateParser` is similar implementation to `MapTemplateParser` that works on any object. Template macros represents bean paths to the properties to fetch:

~~~~~ java
    BeanTemplateParser.of(bean).parse("Third user name: ${users[2].name}");
~~~~~

## Configuration

`StringTemplateParser` (and it's variations) is very configurable. You can set the escape
character, or starting and ending strings (by default: `${` and `}`).
There is an option if missing keys should be resolved, and the
replacement value for missing keys.

`StringTemplateParser` by default detects inner macros in passed string.
However, you can turn on parsing values as well.