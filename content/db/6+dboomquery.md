# DbOomQuery

**DbOomQuery** is all about convenient mapping of result set to target classes. `DbOomQuery` extends `DbQuery` by adding methods for mapping result sets to objects.

There are two ways how object is mapped to database table. The first way is by following naming _conventions_. `DbOomQuery` will try to map result set columns to objects as best as possible. Second way is by using _annotations_ on domain objects, i.e. explicit markup, where no specific naming convention has to be followed. It is possible to mix both and perform mappings in both ways. Anyhow usage of `DbOomQuery` is absolutely identical in both cases.

## find()

`DbOomQuery.find()` is used to find single set of objects from database, i.e. to find exactly one row and to map it to some set of objects.

~~~~~ java
    DbOomQuery q = DbOomQuery.query(session,
            "select * from GIRL join BOY on... where...");
    Object[] girlAndBoy = (Object[]) q.find(Girl.class, Boy.class);
    Girl girl = (Girl) girlAndBoy[0];
    Boy boy = (Boy) girlAndBoy[1];
    girl.setBoy(boy);		// if there is such dependency
~~~~~

The join between two tables is mapped to two, explicitly specified, classes. Since `DbOomQuery` is not aware of relationships, `boy` instance would be not injected into the `girl`. Here this is done manually (line #5).

## How mapping works

Mapping process is the core of *DbOom* and it is important to understand how _result-set-to-object_ mapper works. It matches both table and column names with provided array of bean classes and its properties. Mapper reads meta-data from result set and then maps columns of same table to its properties of corresponding class. This is repeated for all remaining columns (and tables).

Some JDBC drivers doesn't provide table name within result set meta-data. When table name is not available, mapper tries to to best possible job: it tries to map columns to one class by matching just column names and bean properties. While everything is OK (i.e. while there is a bean property that matches result set columns), mapper continues using the same bean object. If mapping fails i.e. if some column name is not founded among bean properties, mapper takes the next bean class and repeats the procedure. This approach has some sharp usage edge, but they can be easily avoided.

To summarize: *DbOom* mapping uses a type a long as it could.
{: .attn}

*DbOom* offers a solution when table names are not available in JDBC meta-data, that will be explained later.

As said, mapping works with bean classes, i.e. domain objects. Moreover, mapper recognizes Java and *Jodd* number classes (configurable) as well and they are mapped to one single column:

~~~~~ java
    q.find(
        Integer.class, Girl.class, Long.class,
        Boy.class, Float.class, String.class);
~~~~~

Mapping functionality of *DbOom* is modular and may be easily replaced
with custom implementation.

## Find single type

When result set is mapped to a single type, `find()` returns an `Object` and not `Object` array. The following example has no casting at all:

~~~~~ java
    DbOomQuery q = DbOomQuery.query(session, "select * from GIRL ... where...");
    Girl girl = q.find(Girl.class);
~~~~~

## list(), listSet()...

`DbOomQuery` has also methods for retrieving all records from the result set. They are returned as list or set of object arrays.

~~~~~ java
    DbOomQuery q = DbOomQuery.query(session,
            "select * from GIRL join BOY on... where...");
    List<Object[]> girlsAndBoys = q.list(Girl.class, Boy.class);
    Set<Object[]> girlsAndBoysSet = q.listSet(Girl.class, Boy.class);
    List<Girl> girls = q.list(Girl.class);
~~~~~

## Iterator

Sometimes fetching and instantiating of whole result set may be time and memory consuming. In such cases it is possible to iterate over result set using `iterate()` method.

## Annotations

It is possible to annotate entity objects to specify table and column names that will be used during mapping process. This is done using two annotations, `@DbTable` and `@DbColumn`:

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

This example breaks naming convention on some properties, therefore class and fields are marked to specify the table and column names. If value element of an annotation is not given, name will be generated from the class/field name.

Annotations `@DbTable` and `@DbColumn` just define table (or view) and column names. Think of `@DbTable` like a set of ResultSet columns that applies to one bean.

Using annotations is the preferred way for working with *DbOom*, but not the only one.
{: .attn}

## Join hints: 1-1 relations

When selecting a join of entities, `DbOomQuery` by default maps the result into the array of objects that are not connected anyhow. For example, the query `"select * from GIRL join BOY..."` will return
for each row an array of two elements: `Girl` and `Boy` instances. In order to put `Girl` instance into a `Boy`, user has to do that manually in the code.

`DbOomQuery` offers a simple way how to join resulting instances. To specify what to join, user has to provide so-called *join hints*. Join hint is a simple name of entities and their properties in the context of the query. Here is an example:

~~~~~ java
    DbOomQuery q = DbOomQuery.query(session,
    	"select girl.*, boy.* from GIRL girl join BOY boy on girl.ID=boy.GIRL_ID");
    List<Boy> boys = q.withHints("boy.girl", "boy").list(Girl.class, Boy.class);
~~~~~

Every row of the query results will be mapped to two beans: `Girl` and `Boy`. Using provided hints, we define that `Girl` instances should be injected into the `Boy` instances, for every row. Here, `Boy` entity instance is named as `boy`. `Girl` entity instance is named as `boy.girl`, indicating that `Girl` instance should be injected into the `boy.girl` property.

Hint is the name/path of bean in the context of query result. With hints you can organize resulting entities inject one into another. Hints order is important!
{: .attn}

With hints it is possible to solve 1-1 relationships. Obviously, it works for uni-directional relationships; bidirectional support should be developed in Java, in setter method.
