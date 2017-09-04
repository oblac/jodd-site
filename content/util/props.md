# Props

*Props* is super `properties`; containing all what is missing in JDK:
UTF8 support, macros, sections, profiles, fully configurable... and
more! Properties are stored in one or more `*.props` files, but its
architecture is open for any type of source. Moreover, *Props* is
compatible with Java properties.

The purpose of *Props* is not to provide the ultimate configuration
solution, but to replace Java properties with better alternative.
So if you are using properties in you application, consider
switching to *Props*.

## Basic rules

Bellow is set of basic rules for `props` file format. Some of them are
shown in the following example:

![props example](props-example.png)
{: style="text-align:center;"}

### UTF8 encoding

By default, `props` files are UTF8 encoded, but can be encoded in any
encoding. Whatever encoding is used, *Props* will still load Java
properties using ISO 8859-1.

### Trimming whitespaces

Leading and trailing spaces will be trimmed from section names and
property names. Leading and/or trailing spaces may be trimmed from
property values.

### Assignment property values

Either equal sign (`=`) or colon (`:`) are used to assign property
values.

### Quick append values

Use `+=` to append values (separated with comma) of properties with
the same name.

### Comments

Comments begin with either a semicolon (`;`), or a sharp sign (`#`) and
extend to the end of line. It doesn't have to be the first character.

### Escaping

A backslash (`\`) escapes the next character (e.g., `\#` is a literal
`#`, `\\` is a literal `\`).

### Multi-line values

If the last character of a line is backslash (`\`), the value is
continued on the next line with new line character included.

### Special characters

`\\uXXXX` is encoded as character. Also `\t`, `\r` and `\f` are encoded
as characters.

### Multiline values

Use triple-quote to define multi-line values in convenient way.

## Basic usage

Using *Props* is very easy. In a nutshell, properties are managed by
`Props` class.

~~~~~ java
    Props p = new Props();
    p.load(new File("example.props"));
    ...
    String story = p.getValue("story");
~~~~~

Properties can be loaded by `Props` in many different ways: from a
`File`, `InputStream`, `String` or `Properties`. Then props are ready
for usage and values can be looked up using `getValue()` method. This
method always returns a String value.

## Sections

Sections looks very much like INI file sections. In *Props*,
section simply represents the keys prefix for following keys, until the
section end or end of file.

Section names are enclosed between `[` and `]`. Properties following a
section header belong to that section. Section name is added as a prefix
to section properties. Section ends with empty section definition `[]`
or with new section start or end of file.

The following example:

~~~~~
[users.data]
weight = 49.5
height = 87.7
age = 63
[]
comment=this is base property
~~~~~

is identical to:

~~~~~
users.data.weight = 49.5
users.data.height = 87.7
users.data.age = 63
comment=this is base property
~~~~~

Sections, therefore, can shorten the file and make it more readable.

## Profiles

Often an application works in different environments and, therefore,
require different set of (some) properties; for example: the development
mode and deployment mode of a web application. One way how to organize
properties is to define different profiles where the same key name takes
different values.

*Props* supports property profiles. Profiles are defined within key
name: profile names are enclosed between `<` and `>`. One key may
contain one or more profile definitions. Also, profile definition can be
anywhere in the key name, even in the middle of the word; however, it is
a good practice to put them at the end.

Properties without a profile are _base_ properties. If look up for a
property of some profile fails, *Props* will examine the base
properties.

Profiles can be considered as a 'different views' or
'snapshots' of the same property set.

Example:

~~~~~
db.port=3086

db.url<develop>=localhost
db.username<develop>=root

db.url<deploy>=192.168.1.101
db.username<deploy>=app2499
~~~~~

In this example 3 keys are defined; two keys have different values in
two profiles (`develop` and `deploy`) and no base value.

Since sections are just a prefix definition and since profile can be
anywhere in the key name, therefore section name can contain profile
definition as well. Above example can be written as:

~~~~~
db.port=3086

[db<develop>]
url=localhost
username=root

[db<deploy>]
url=192.168.1.101
username=app2499
~~~~~

When looking up for a value, it is possible to specify which profiles
are active:

~~~~~ java
    String url = props.getValue("db.url", "develop");
    String user = props.getValue("db.username", "develop");
~~~~~

More then one profile can be specified at a time. The order
of specified profiles is important! When one key
is defined in more then one active profile, the FIRST
value (of first matched profile) is returned.
{: .attn}

It is also possible to lookup only for base properties
(ignoring the profiles) - using `getBaseValue()` method.
Base properties are those that don't belong to
any profile.

### Default active profiles

Usually, only one set of profiles is active during the application's
lifetime. Instead of passing active profiles to `getValues()` methods
each and every time, *Props* allows to define so called active profiles
externally, in the same `props` files used for loading properties.

Active profiles are default profiles when looking for a property using
method `getValue(String)`.

Active profiles can be set in the `props` files - this way the
configuration set can be changed (i.e. active profiles can be modified)
without the need to recompile the code. Active profiles are defined
under the special base key named `@profiles`. Example:

~~~~~
key1=hello
key1<one>=Hi!

@profiles=one
~~~~~

and the following Java code:

~~~~~ java
    String value = props.getValue("key1");
~~~~~

would return the value `Hi!`, since active profile is `one`.

Active profiles can be set from Java, too, using method:
`setActiveProfiles()`.

### Inner profiles

There are situations where two ore more profiles share the most of the
configuration and only few properties are different (or: specific) for
one profile (i.e. configuration). To avoid repeating of all properties
for each profile, it is possible to define properties assigned to inner
profiles only for those differences. *Props* will first lookup keys in
inner profiles, then go up to the base level. Example:

~~~~~
key1<one>=Hi!
key2<one>=...
....
key100<one>=...

key1<one.two>=Hola!
~~~~~

This example defines two profiles. First one is named `one` and
contains 100 properties. Second profile is an inner property named
`one.two`. It contains only 1 property (`key1`) - but all properties
from its upper profile are available! So what happens when Java code
calls the following: `props.getValue("key1", "one.two")`? *Props* will:

* lookup for property in inner profile `one.two`
* if value is not found, `Props` will check upper profile: `one`
* if value is not found and there are no more upper profiles, *Props* will check base properties.

There can be many levels of inner profiles.

## Macros

The biggest *Props* strength are macros. Macro is a reference to some
keys value, used in value of other key. Macros are enclosed between `${`
and `}`. Here is a simple example:

~~~~~
key1=Something ${foo}
...
foo=nice
~~~~~

Value of `key1` is `Something nice`. Macros can refer to any
existing property key, no matter where it is defined.

Nested macros are also supported. Example:

~~~~~
key1=**${key${key3}}**
key3=2
key2=foo
~~~~~

Value of `key1` is `**foo**`.

### Macros and profiles

Macros are always resolved using the currently active or provided
profile. The value of macro may change if current profile is changed.

This behavior is controlled with flag: `useActiveProfilesWhenResolvingMacros`.
Here is an example:

~~~~~
root=/app
root<foo>=/foo
data.path=${root}/data
~~~~~

What is the value of `data.path` when `foo` profile is set as active?
Since `foo` is active, `root` value becomes `/foo`, therefore
the `data.path` is going to be set to `/foo/data` value.

If we turn of profiles (and use only base propertes), the `data.path`
value is going to be `/app/data`.

It is also possible to explicitly set macro's profile:

~~~~~
root=/app
root<foo>=/foo
data.path=${root<foo>}/data
~~~~~

In this example, `root` macro will always use the `foo` profile
regardless of the currently selected profiles. So `data.path`
value would be always be: `/foo/data`.


## Multiline values

When enabled, multilines values may be defined with triple-quotes.
Everything between is considered as a value. Example:

~~~~~
email.body='''
	Hello $n,

	welcome!
'''
~~~~~

Note that multiline values are **NOT** trimmed! Therefore, the value
from the example will consist of 5 rows.

## Iteration and keys order

*Props* keeps your keys in order! It is possible to iterate all *Props*
keys in the same order as they are listed in the props file(s).
So instead doing this:

~~~~~
foo.1=value1
foo.2=value2
...
~~~~~

you can simply iterate props using:

~~~~~ java
    Props props = ....
    Iterator<PropsEntry> it = p.iterator();
~~~~~

The order of iteration is the same as the order of props definitions!

But there is more - it is possible to furthermore tune the iterator, by
adding a filter for profiles to look and/or sections to iterate.
So you can write something like this:

~~~~~ java
    Iterator<PropsEntry> it = p.entries()
            .section("one.two")
            .profile("prof1", "prof2")
            .iterator();
~~~~~

to iterate only props in given section and for given profiles.

Due to profiles usage, one key may be defined on many places in
props file. For example, you can specify value for two profiles.
In this case, it is not clear what is the 'correct' order of the
keys: should it be the first appearance of the key, or the place
where it gets its value? Either way, you can control this behavior
using `skipDuplicatesByValue()` and `skipDuplicatesByPosition()`
during iterator building.

## Copy operator

Imagine you have certain number of properties that is, by default,
the same for some number of different categories. For example:

~~~~~
com.jodd.action1=value1
com.jodd.action2=value2
...
org.jodd.action1=value1
org.jodd.action2=value2
...
net.jodd.... # etc
~~~~~

*Props* allows you to use _copy operator_: `<=` to minimize the duplicate
props. Above props can be written as:

~~~~~
[actions]
action1=value1
action2=value2
...

[]
org.jodd <= actions

[com]
jodd <= actions

[net.jodd]
<= actions
~~~~~

This example shows three different ways how to use copy operator, without
sections, with partial section or with full section. All three ways
are identical and it's up to you which one you gonna use.

Remember that copied values are set as macros, so all above
copied properties are identical to:

~~~~~
org.jodd.action1=${actions.action1}
com.jodd.action1=${actions.action1}
....
~~~~~

All rules for resolving macros applies.

## Configuration

*Props* behavior can be fine-tuned using several configuration settings:

### escapeNewLineValue

Specifies the new line string when EOL is escaped. Default value is an
empty string, so multi-line values will be joined in single-line value.
If this value is set to, e.g., `\n`, multi-line values will be
persisted as multi-lines.

### valueTrimLeft

Specifies if values should be trimmed from the left.

### valueTrimRight

Specifies if values should be trimmed from the right.

### ignorePrefixWhitespacesOnNewLine

Defines if the leading whitespaces should be ignored when value is split
into the lines (by escaping EOL). By default it is set to `true`, so the
following multi-line props:

~~~~~
key1=line1\
     line2\
line3
~~~~~

will be read as `line1line2line3` (joined).

### skipEmptyProps

Flag for skipping empty properties.

### appendDuplicateProps

When set, duplicate props key will not override existing one, but will
be appended and separated by comma.

### multilineValues

When enabled (default), multi-line values may be written in more
convenient way using triple-quote (as in python). Everything between
triple-quotes is considered as a value, so new line does not need to be
escaped.

## IntelliJ IDEA plugin

There is [IntelliJ IDEA plugin][1] that provides support
for *Props* files. For now, this support is very basic, but it will be
enhanced in time. Feel free to improve it :)


[1]: http://plugins.intellij.net/plugin/?idea&id=5984
