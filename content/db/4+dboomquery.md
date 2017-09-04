# DbOomQuery

**DbOomQuery** is all about convenient mapping of result set to target
classes.

`DbOomQuery` extends `DbQuery` by adding methods for mapping result sets
to objects.

Basically, there are two ways how object is mapped to some database
table. The first way is by following naming conventions. `DbOomQuery`
will try to map result set columns to objects as best as possible.
Second way is by using annotations on domain objects, i.e. explicit
markup, where no specific naming convention has to be followed. Of
course, it is possible to mix both and perform mappings in both ways.
Anyhow, from the usage point of view, it is absolutely identical how
`DbOomQuery` is used in both ways.

## find()

Method `DbOomQuery.find()` is used to find single set of objects from
database, i.e. to find exactly one row and to map it to some set of
objects.

~~~~~ java
    DbOomQuery q = new DbOomQuery(session,
            "select * from GIRL join BOY on... where...");
    Object[] girlAndBoy = (Object[]) q.find(Girl.class, Boy.class);
    Girl girl = (Girl) girlAndBoy[0];
    Boy boy = (Boy) girlAndBoy[1];
    girl.setBoy(boy);		// if there is such dependency
~~~~~

Here a join between two tables is mapped to two, explicitly specified,
classes. Since `DbOomQuery` is not aware of relationships, `boy`
instance would be not injected into the `girl`. Here, this has to be
done manually (line #5).

## How mapping works

Mapping process is the core of *DbOom* and it is important to understand
how result-set-to-object mapper works. It matches both table and column
names with provided array of bean classes and its properties. Mapper
reads meta-data from result set and then maps columns of same table to
its properties of corresponding class. This is repeated for all
remaining columns (and tables).

Since world is not perfect, some JDBC drivers doesn't provide table
name within result set meta-data (hello [Oracle][1]). When
table name is not available, mapper tries to to best possible job: it
tries to map columns to one class by matching just column names and bean
properties. While everything is OK (i.e. while there is a bean property
that matches result set columns), mapper continues using the same bean
object. If mapping fails i.e. if some column name is not founded among
bean properties, mapper takes the next bean class and repeats the
procedure. This approach has some sharp usage corners, but they can be
easily avoided.

*DbOom* offers a solution when table names are not available in JDBC
meta-data, that will be explained later.

As said, mapping works with bean classes, i.e. domain objects. Moreover,
mapper recognizes Java and *Jodd* number classes (configurable) as well
and they are mapped to one single column:

~~~~~ java
    q.find(Integer.class, Girl.class, Long.class,
            Boy.class, Float.class, String.class);
~~~~~

Mapping functionality of *DbOom* is modular and may be easily replaced
with custom implementation.

## find single type

When result set is mapped to single type, `find()` returns an `Object`
and not `Object` array. The following example has no casting at all:

~~~~~ java
    DbOomQuery q = new DbOomQuery(session, "select * from GIRL ... where...");
    Girl girl = q.find(Girl.class);
~~~~~

## list(), listSet()...

`DbOomQuery` has also methods for retrieving all records from the result
set. They are returned as list or set of object arrays.

~~~~~ java
    DbOomQuery q = new DbOomQuery(session,
            "select * from GIRL join BOY on... where...");
    List<Object[]> girlsAndBoys = q.list(Girl.class, Boy.class);
    Set<Object[]> girlsAndBoysSet = q.listSet(Girl.class, Boy.class);
    List<Girl> girls = q.list(Girl.class);
~~~~~

## Iterator

Sometimes fetching and instantiating of whole result set may be time and
memory expensive. In such cases it is possible to iterate over result
set using `iterate()` method. This method can be used very similar to
other methods explained here.

## Annotations

For mapping purposes it is possible to annotate domain objects to
specify table and column names that will be used during mapping process.
This is done using two annotations, `@DbTable` and `@DbColumn`\:

~~~~~ java
    @DbTable("BOY")
    public class BadBoy {

    	@DbColumn("ID")
    	Integer ajdi;

    	@DbColumn
    	String name;
    	...
    }
~~~~~

This domain object definition breaks naming convention on some
properties, therefore class and fields are marked to specify the table
and column names. If value element of an annotation is not given, name
will be created from class/field name.

Annotations `@DbTable` and `@DbColumn` just define table (or view) and
column names. Think of `@DbTable` like a set of resultset columns that
applies to one bean.

Using annotations is the preferred way for working with *DbOom*.
{: .attn}

## Join hints: 1-1 relations

When selecting a join of two or more entities, `DbOomQuery` maps the
result into the array of objects that are not connected anyhow. For
example, the query `"select * from GIRL join BOY..."` will return
for each row an array of two elements:
`Girl` and `Boy` instances. In order to put `Girl` instance in a `Boy`,
user has to do that manually in the code.

`DbOomQuery` offers simple way how to join resulting instances. To
specify what to join, user has to provide \'*join hints*\'. Join hint is
simple name of bean location in local context of the query. Here is an
example:

~~~~~ java
    DbOomQuery q = new DbOomQuery(session,
    	"select girl.*, boy.* from GIRL girl join BOY boy on girl.ID=boy.GIRL_ID");
    List<Boy> boys = q.withHints("boy.girl", "boy").list(Girl.class, Boy.class);
~~~~~

Every row of the query results will be mapped to two beans: `Girl` and
`Boy`. Using hints, we define that `Girl` instances should be injected
into `Boy` instances, for every row. As said, hints are just names of
created entities in query context. Here, `Boy` entity instance is named
as \'`boy`\'. `Girl` entity instance is named as \'`boy.girl`\',
indicating that `Girl` instance should be injected into the `boy.girl`
property.

Hint is the name/path of bean in the context of query result. When you
map query result to several beans or instances, with hints you can
organize them and inject one into another. Hints order is important!
{: .attn}

With hints it is possible to easy solve 1-1 relationships. Obviously, it
works for uni-directional relationships; bidirectional support should be
developed in Java, in setter method.

[1]: http://oracle.com/
