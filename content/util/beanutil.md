# BeanUtil

`BeanUtil` is bean manipulation library, that in a nutshell, allows
setting and reading bean properties. Several features make `BeanUtil`
distinct:

* *fast* (if not the fastest) bean manipulation utility
* works with both *attributes* and *properties*
* nested properties can be arrays, lists and maps
* missing inner properties may be created
* may work silently (no exception is thrown)
* offers few populate methods
* has strong-type conversion library

## Flavors of BeanUtil

Before we jump into the details, let's quickly learn what types of `BeanUtil`
exists. Implementations differ in the way how they threat private properties,
if they throw exceptions and, finally, if they force creation of missing inner
properties (more details later). You can build your own implementation easily
using `BeanUtilBean`, but these are already provided:

| name | access privates | throws exception? | force missing properties?
| `BeanUtil.pojo`           | no  | yes | no
| `BeanUtil.declared`       | yes | yes | no
| `BeanUtil.silent`         | no  | no  | no
| `BeanUtil.forced`         | no  | yes | yes
| `BeanUtil.declaredSilent` | yes | no  | no
| `BeanUtil.declaredForced` | yes | no  | yes
| `BeanUtil.declaredForcedSilent` | yes | no | yes
| `BeanUtil.forcedSilent`   | no  | no | yes

Let' jump into details!

## Working with bean properties

In `BeanUtil` world, bean property is a class field with its *optional*
setter and getter (aka accessors) methods. When accessing properties,
`BeanUtil` first tries to use accessors methods. If they don't exist,
`BeanUtil` fail-backs to using the field of the same visibility.
Therefore, existence of accessors methods is not required and depends on
usage, what often may be handy. `BeanUtil` is used internally inside
the *Jodd* library, so this behavior applies everywhere.

Simple bean:

~~~~~ java
    public class Foo {
    	private String readwrite;   // with getter and setter
    	private String readonly;    // with getter
    	...
    }
~~~~~

Usage:

~~~~~ java
    Foo foo = new Foo();
    BeanUtil.pojo.setProperty(foo, "readwrite", "data");
    BeanUtil.pojo.getProperty(foo, "readwrite");
    BeanUtil.declared.setProperty(foo, "readonly", "data");
~~~~~

Lines #2 and #3 show common and expected `BeanUtil` usage: setting value
of read-write property through it's accessors methods. Setting
`readonly` property in above example is only possible with default
implementation, so we use `BeanUtil.declared`. This variant first tries to
use `setReadonly()` method, but since such method doesn't exist,
field value is accessed directly.

## Nested properties

`BeanUtil` supports nested properties. Nested properties can be java beans,
a **List**, a **Map** or an **array** element:

~~~~~ java
    BeanUtil.pojo.getProperty(cbean, "list[0].map[foo].foo");
    BeanUtil.pojo.setProperty(cbean, "arr[4].map[elem.boo].foo", "test");
~~~~~

When accessing nested properties, `BeanUtil` access one property at time
and, by default, expects that all inner properties exist
i.e. are not-`null`. Above example is executed like the
following pseudo-code:

~~~~~ java
    cbean.getList().get(0).get("foo").getFoo();
    cbean.getArr()[4].get("elem.boo").setFoo("test");
~~~~~


## Forced setting of nested properties

Setting of nested properties fails if one of the inner elements is `null`.
Using *forced* feature of `BeanUtil`, such properties still may be set!

~~~~~ java
    BeanUtil.forced.setProperty(x, "y.foo", value);
    BeanUtil.forced.setProperty(x, "yy[2].foo", "xxx");
~~~~~

If the object `x` in above example has uninitialized property `y`,
`BeanUtil` will first create a new instance of `y`\'s type, and set it
to property `y`. Then, `foo` property of newly created object `y` will
be set. In the second example, `yy` is an array. If it is uninitialized,
`BeanUtil` will create a new array of length 3. Then, it will create a
new instance of `yy`\'s type that will be stored as third element of the
array. Finally, the `foo` property is set.

In forced mode, `BeanUtil` tries to instantiate all uninitialized properties
needed for setting the final property. Instantiation depends of the
inner property type: if it is a simple bean, no-args constructor will be invoked.
If it is a list, new `ArrayList` will be created. Similar applies for arrays
and map types. Additionally, `BeanUtil` will check the length of
existing initialized arrays and lists and if the current size is not
enough, list or array will be expanded by adding `null` elements up to
the new size.

### Generics support

When creating a new element of an list, `BeanUtil` will consider
existing generics information in order to create element of correct
type.

## Silent mode (no exceptions)

Property setting may fail for various reasons, causing an unchecked
exception `BeanUtilException` to be thrown. Sometimes this is not
desired behavior. For these cases, `BeanUtil` offers *silent* implementation
that does not throw any exception at all.

## Maps and lists instead of beans

You can pass maps and list instead of beans as a root object. Just omit
the bean name (since we do not work on a bean anymore):

~~~~~ java
    Properties properties = new Properties();
    BeanUtil.pojo.setProperty(property, "[ldap.auth.enabled]", "true");
~~~~~

## Testing of property existence

`BeanUtil` also offers convenient way to test if some property exists:

~~~~~ java
    BeanUtil.pojo.hasProperty(fb, "fooInteger")
~~~~~

## Type conversion

When setting properties, *BeanUtil* converts type of provided value to
match the destination. For this purpose it uses *Jodd*s [type converter](typeconverter.html) utility.

Getting properties always returns an `Object`. If you need to cast it to
some type, you can use `TypeConverterManager#convertType`. The following
snippet (from [Liferay](http://www.liferay.com) portal) shows the usage:

~~~~~ java
    public boolean getBoolean(Object bean, String param, boolean defaultValue) {
    	Boolean booleanValue = null;
    	if (bean != null) {
    		Object value = BeanUtil.pojo.getProperty(bean, param);
    		beanValue = TypeConverterManager.convertType(value, Boolean.class);
    	} catch (Exception ex) {
    		// log error
    	}
    	if (booleanValue == null) {
    		return defaultValue;
    	} else {
    		return booleanValue.booleanValue();
    	}
    }
~~~~~

## BeanUtilBean

`BeanUtil` is just an intreface. `BeanUtilBean` is the class that contains
all the logic. You can create your variant of bean utilities and share it in
your code. It should be thread-safe.

## BeanCopy

There is more: `BeanCopy` class offers copying functionality. It copies
properties from source to destination bean.

## BeanTemplateParser

`BeanTemplateParser` is based on
[StringTemplateParser](stringtemplateparser.html). a string template
with JSP-alike markers that indicates where provided context values will
be injected. Usage is quite simple:

~~~~~ java
    // prepare template
    String template = "Hello ${user.name}. Today is ${dayName}.";
    ...

    // prepare context
    Foo foo = new Foo();
    foo.getUser().setName("John Doe");
    foo.setDayName("Saturday");
    ...
    // parse
    BeanTemplateParser btp = new BeanTemplateParser();
    String result = btp.parse(template, foo);
    // result == "Hello John Doe. Today is Saturday."
~~~~~

## Performance test

`BeanUtil` seems almost 20% faster compared to
[Commons BeanUtils v1.8](http://commons.apache.org/beanutils/).
However, the performance is not the only reason why `BeanUtil` is a good choice, as seen above.

![BeanUtil performance test](beanutil-benchmark.png)
