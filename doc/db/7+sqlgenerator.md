# Sql Generator

SQL generator just helps in building *native* SQL queries: using entity
and property names in the query or just using one-liner method calls.

There is more convenient way for writing queries that you should use
in practice: Template-SQL i.e. TSQL (see next chapter).
{: .attn}

Until now, all queries used by *Db* and *DbOom* were just plain old
native SQL queries. *DbOom* goes further and allows SQL queries to be
(somehow) generated or dynamically build. Sql generator may be very
powerful and convenient tool. In general, sql generator is an
`SqlGenerator` instance that generates and returns query string, its
parameters, and, optionally, column data and join hints. *DbOom* offers
few `SqlGenerator` implementations.

`DbOomQuery` may use `SqlGenerator` instance instead of sql query
string.

*DbOom* offers following ways to build sql queries:

* using java methods to build the query by joining query chunks (the
  basic way);
* using T-SQL (template sql) - allows user to write sql queries using
  entities and properties;
* using java methods to generate complete common queries - wraps all
  above in single method call.

The basic way of query generation (by joining chunks using java) is not
used much in practice. Other ways (template sql) are much more
convenient. However, since all other ways use this basic functionality
internally, let's learn and understand what is under the hood.

## DbSqlBuilder

`DbSqlBuilder` is generic and powerful sql query builder. It basically
builds a query by its (string) chunks, allowing to generate some parts
of the query by referencing registered java entities. `DbSqlBuilder`
creates column names, table names, all standard create/update/insert
queries etc., just by referencing registered entities mapped to
corresponding tables and columns.

Furthermore, `DbSqlBuilder` introduces sql-alike template language built
on top of chunk creation that allows easier sql generation. This
template language is no a proprietary query language - it is just a
template language with macros that will be simply replaced. It is still
a native sql at the end, open for all neat optimization.

Detailed explanation follows.

## Query: table()

`table()` method defines a table from entity reference and generates
table chunk of sql query.

~~~~~ java
    import static jodd.db.orm.sqlgen.DbSqlBuilder.*;

    // entity registration
    dbOom.registerEntity(Boy.class);
    dbOom.registerEntity(Girl.class);

    DbSqlBuilder s;
    // using entity name
    s = sql().table("Boy");             // s.generateQuery() == "BOY"
    sql().table("Boy", null);           // -//-
    sql().table("Boy", "bbb");          // "BOY bbb", table name with alias
    sql().table("Boy bbb");             // "BOY bbb"

    // using entity class
    sql().table(Boy.class);             // "BOY boy"
    sql().table(Boy.class, null);       // "BOY"
    sql().table(Boy.class, "bbb");      // "BOY bbb"

    // using use()
    sql().table("bbb").use("bbb", Boy.class);       // "BOY bbb"
    sql().table("bbb", null).use("bbb", Boy.class); // "BOY"
    sql().table("bbb", "x").use("bbb", Boy.class);  // "BOY x"
~~~~~

For the sake of simplicity, all example entities are registered using
naming convention: table and entity name is the same. Of course this is
not the requirement, entity class may be named differently then table
and annotated with correct table name.

Tables are always parsed first and their references may be used in all
other chunks.

## Query: column()

`column()` method generates column reference(s). Some new features are
introduced in the example, that will be explained just after the code.

~~~~~ java
    // single column
    sql().column("Boy.id").table("Boy", null);    // s.generateQuery() == "BOY.ID BOY"
    sql().column("Boy.id").table("Boy");          // "Boy.ID BOY Boy"
    sql().column("b.id").table("Boy", "b");       // "b.ID BOY b"
    sql().column("Boy.id").table(Boy.class);      // "Boy.ID BOY Boy"

    // all columns
    sql().column("b.*").table("Boy", "b");        // "b.ID, b.GIRL_ID, b.NAME.... BOY b"

    // primary key only
    sql().column("b.+").table("Boy", "b");        // "b.ID BOY b"

    // various references
    sql().column("b.id").table("Boy", "b")
            .aliasColumnsAs(COLUMN_CODE);         // "b.ID as col_0_ BOY b"
    sql().column("b.id").table("Boy", "b")
            .aliasColumnsAs(TABLE_REFERENCE);     // "b.ID as b$ID BOY b"
    sql().column("b.id").table("Boy", "b")
            .aliasColumnsAs(TABLE_NAME);          // "b.ID as BOY$ID BOY b"
~~~~~

Column references are defined using java bean property names! Entity
bean properties will be replaced with the column names.

There is an easy way how to generate **all** table columns, by using
\'**\***\' column macro. It simply generates all columns, starting with
primary keys followed with sorted list of other columns.

It is possible to generate reference just to single id column, by using
\'**+**\' column macro. More about identity properties later.

There is a variety of options how columns may be aliased. More about
column aliasing later.

`column()` is used for defining columns (e.g. after `select`).

## Id column

*DbOom* offers a (optional) possibility to annotate the single identity
property. This is not necessary thing to do, and may be avoided.
However, to unlock the full potential of sql generation it is
recommended to mark a field as identity:

~~~~~ java
    @DbTable
    public class Boy {

        @DbId               // used identically as @DbColumn
        Integer id;

        @DbColumn
        String name;

        @DbColumn
        Integer girlId;

        ...
    }
~~~~~

One of the benefits having marked identities is already shown in previous
examples, line #11.

## Column name aliasing

Why aliasing is important? As said before, when columns from one record
of result set are being mapped to provided set of classes, *DbOom*
checks result set meta-data. There it can figure what is the table name
for each returned column. Unfortunately, some JDBC drivers (Oracle)
doesn't provide table name information with column data.

Using column aliasing solves any potential ambiguous problem with column
names. The idea is that column alias contains also the table name or
reference. This table name hint is given as a prefix, separated with
\'**$**\' from real column name.

*DbOom* recognize three types of column aliases:

* `TABLE_NAME` - full table name is added as prefix, e.g. `BOY$ID`.
  Problem with this type of alias is the final column name length, since
  database often has upper limit for column alias (e.g. 30 characters).
* `TABLE_REFRENCE` - just table reference (i.e. alias) is used as table
  prefix. Usually, table aliases are shorter, so there is less chance to
  have too long column alias names.
* `COLUMN_CODE` - is the safest option, but the least readable. Column
  aliases are named as `col_n_`, where `n` is the ordinal number of
  column.
* none (`null`) - no column aliases are used.

## Query: ref()

`ref()` references defined column, later in the query (in `where` part).
Reference works similar to `column()`, except type of column aliases
doesn't affect reference query chunk generation. Moreover, it is
possible to reference identity column (\'**+**\'), but it is not
possible to reference all columns (\'**\***\').

## Query: value()

`value()` is used for injecting parameters into the query. Values are
generated as `DbOom` named parameters.

~~~~~ java
    sql().value("zzz", Integer.valueOf(173));       // ":zzz"
    sql().value(Integer.valueOf(2));                // ":p0"
    sql().value("zzz", list);                       // ":zzz0, :zzz1, :zzz2"...
~~~~~

Parameters may be named explicitly (as in line #1), or not, when
`DbSqlBuilder` generates name internally (line #2). If parameter value
is a `Collection`, it will be generated as comma separated list of
properties, for each collection value.

## Query: insert() and update set()

`insert()` and `set()` methods helps in generating `insert` and `update`
sql queries. Both methods generates sql chunk based on provided entity
instance.

~~~~~ java
    // "insert into BOY (GIRL_ID, ID) values (:boy.girlId, :boy.id)"
    sql().insert("Boy", boy);
    sql().insert(Boy.class, boy);   // -//-
    sql().insert(boy);              // -//-

    // "set b.GIRL_ID=:boy.girlId, b.ID=:boy.id BOY b"
    sql().set("b", b).table("Boy", "b");

    // "set b.GIRL_ID=:boy.girlId, b.ID=:boy.id, b.NAME=:boy.name BOY b"
    sql().setAll("b", b).table("Boy", "b");
~~~~~

`insert()` generates sql chunk for inserting all non-`null` data of
entity. `set()` generates the set chunk for all non-null entity values.
`setAll()` generates set for all values, including `null` ones.

## Query: match()

`match()`generates sql chunk for filtering records. It will generate
equality relation for all non-`null` entity values. Here is an example
of complete code for single query:

~~~~~ java
    Boy bb = new Boy();
    Girl bg = new Girl();

    DbSqlBuilder dsb = sql()
            ._("select")            // "select"
            .columnsAll("bb")       // "bb.ID, bb.GIRL_ID, bb.NAME"
            .columnsIds("bg")       // "bb.NAME, bg.ID"
            ._(" from")             // " from" (hardcoded string)
            .table(bb, "bb")        // "BOY bb"
            .table(bg, "bg")        // ", GIRL bg"
            ._()                    // " " (single space)
            .match("bb", bb)        // "(1=1)"  since all bb fields are null
            ._(" and ")             // " and "
            .match("bg", bg);       // "(1=1)" since all bg fields are null.
~~~~~

Result:

~~~~~ sql
    select bb.ID, bb.GIRL_ID, bb.NAME, bg.ID from BOY bb, GIRL bg (1=1) and (1=1)
~~~~~

Another example:

~~~~~ java
    Boy bb = new Boy();
    Girl bg = new Girl();
    bb.id = bg.id = Integer.valueOf(1);

    DbSqlBuilder dsb = sql().
            _("select")                 // "select"
            .("bb")                     // "b.ID, bb.GIRL_ID, bb.NAME" (all columns)
            .columnsIds("bg")           // "bg.ID" (just id)
            ._(" from")                 // " from"
            .table(bb, "bb")            // "BOY bb"
            .table(bg, "bg")            // ", GIRL bg"
            ._(" where ")               // " where "
            .match("bb", bb)            // "(bb.ID=:badBoy.ajdi)"
            ._(" and ")                 // " and "
            .match("bg", bg)            // "(bg.ID=:badGirl.fooid)"
            ._(" or ")                  // " or "
            .refId("bb")                // "bb.ID"  (reference id)
            ._("=")                     // "="
            .value(Long.valueOf(5L));   // ":p0"
~~~~~

Result:

~~~~~ sql
    select bb.ID, bb.GIRL_ID, bb.NAME, bg.ID from BOY bb, GIRL bg where
    (bb.ID=:badBoy.ajdi) and (bg.ID=:badGirl.fooid) or bb.ID=:p0
~~~~~

With `DbSqlBuilder` it is possible to create dynamic sql queries using
just java.

## Hardcoded chunks

Important to note is that all chunks with static strings are added with
the same method (`_()` or `append()`), i.e. there is no specific methods
for \'`select`\', \'`where`\', \'`and`\', \'`or`\' strings and so on.
This is done to makes things simple, without the need to implement all
kind of database keywords. However, it is possible to extend
`DbSqlBuilder` to provide this functionality as well.

<js>docnav('db')</js>