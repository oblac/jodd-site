# Template SQL (T-SQL)

Native SQL contains table and column names. As *DbOom* is an object mapper, it would be more natural to use entity and property names instead.

Template SQL is a SQL-alike query string with an add-on: _the macros_. Macros allow usage of entity and property names instead of tables and columns names.

Example:

~~~~~ sql
    select $C{bb.*}, $C{bg.+}
        from $T{BadGirl bg} join $T{Boy bb} on $bg.+=bb.girlId
~~~~~

Result:

~~~~~ sql
    select bb.GIRL_ID, bb.ID, bb.NAME, bg.ID
        from GIRL bg join BOY bb on bg.ID=bb.GIRL_ID
~~~~~

## Table macro $T

Table macro converts entity names into table names. Optionally it may define table alias for further reference, otherwise entity name is used instead. One table macro may define more tables definitions separated by comma.

Usages:

* `$T{<entity> [<alias>]}`

Example:

~~~~~ sql
    select * from $T{Foo f}
~~~~~

Result:

~~~~~ sql
    select * from FOO f
~~~~~

## Columns macro $C

Columns macro renders property name into single column, all columns or id column of a table (usually used for `select` queries). It also support generation of column aliases that are later used as hints in mapping result sets into objects.

Usages:

* `$C{<entity>.<property>}` - renders single column
* `$C{<entry>}` or `$C{<entry>.*}` - renders all table columns, ordered
  by name.
* `$C{<entry>.+}` - renders id column of a table.
* `$C{<hint>:<entity>...}` - defines a hint.
* `$C{.<columnName>}` - defines a column name as is (not a property).

Examples:

~~~~~ sql
    select $C{f.bar} from $T{Foo f}
~~~~~

Result:

~~~~~ sql
    select f.BAR from FOO f
~~~~~

Example that renders all columns using a joker sign `*`:

~~~~~ sql
    select $C{f.*} from $T{Foo f}
~~~~~

Result:

~~~~~ sql
    select f.BAR, f.ID, f.ZAP from FOO f
~~~~~

Example that renders id column using joker sign `+`':

~~~~~ sql
    select $C{f.+} from $T{Foo f}
~~~~~

Result:

~~~~~ sql
    select f.ID from FOO f
~~~~~

Column aliases can be generated in several ways. First, column alias may contain table name (`TABLE_NAME`).

~~~~~ sql
    select $C{f.bar} from $T{Foo f}
~~~~~

Result:

~~~~~ sql
    select f.BAR as FOO$BAR from FOO f
~~~~~

Example for generating column names using table references (i.e. entity names, `TABLE_REFERENCE`)

~~~~~ sql
    select $C{f.bar} from $T{Foo f}
~~~~~

Result:

~~~~~ sql
    select f.BAR as Foo$BAR from FOO f
~~~~~

Finally, there is a third variant, the most safe one, using column code, a generated name (`COLUMN_CODE`). Useful when table names are big and together with column name exceed max allowed column alias name.

~~~~~ sql
    select $C{f.bar} from $T{Foo f}
~~~~~

Result:

~~~~~ sql
    select f.BAR as col_0 from FOO f
~~~~~

### Special case

When entity is not a table reference, then `$C` macro renders just alias name.

## Reference macro $

Reference macro renders simply columns names from properties. Used in `where` part of the sql query.

Usages:

* `$<entity>.<property>` - renders mapped column
* `$<entity>.+` - renders id column
* `$<entity>` - renders table name
* `$.<property>` - renders just column name

Examples:

~~~~~ sql
    select $C{f.bar} from $T{Foo f} where $f.zap=173
~~~~~

Result:

~~~~~ sql
    select f.BAR from FOO f where f.ZIP=173
~~~~~

If table alias is not used, reference will render column using table
name:

~~~~~ sql
    select $C{Foo.bar} from $T{Foo} where $Foo.zap=173
~~~~~

Result:

~~~~~ sql
    select FOO.BAR from FOO where FOO.ZIP=173
~~~~~

## Match macro $M

When using templates it is often needed to provide some additional data, e.g. values that are references in the templated query. For example, for `$M` macro, reference value must be assigned to the template. This is done using method `use()`.

~~~~~ java
    Boy boy = new Boy();
    boy.id = 1;
    boy.girlId = 3;
    DbSqlBuilder s =
        sql("select * from $T{boy} where $M{boy=boy}").use("boy", boy);
~~~~~

Result:

~~~~~ sql
    select * from BOY boy where (boy.GIRL_ID=:boy.girlId and boy.ID=:boy.id)
~~~~~

Here a value reference `boy` is named as table reference. This is not a good practice, and here is done line that to show the difference between table references and value references (added with `use()`)

## Simple join hints

With sql templates it is even more easier to specify joining hints:

~~~~~ java
    // Standard way:
    q = DbOomQuery.query(session, sql(
    	"select $C{girl.*}, $C{boy.*} from $T{Girl girl} " +
    	"join $T{Boy boy} on girl.id=$boy.girlId"));
    boy = (Boy) q.withHints("boy.girl, boy").find(Girl.class, Boy.class);
~~~~~

~~~~~ java
    // Inline way:
    q = DbOomQuery.query(sql(
        // hint inside column name
    	"select $C{boy.girl.*}, $C{boy.*} from $T{Girl girl} " +
    	"join $T{Boy boy} on girl.id=$boy.girlId"));
    boy = (Boy) q.find(Girl.class, Boy.class);
~~~~~

This is clean and visible way for specifying hints, without extra method call.

When using join hints in T-SQL, simple convention has to be followed: table reference name (`girl` in above example) used in the hint should be equal to property name of a target entity (e.g. property
`boy.girl` must exist).
{: .attn}

If target property name is not the same as reference name, you can specify it like this: `$C{boy.girlAlt:girl.*}`.

For more powerful hints configuration, use `withHints()` method.

## ParsedSql

You can gain some performance by parsing the template query only once.

~~~~~ java
	ParsedSql q1 = sql("select ....").parse();
~~~~~

If you store the value of `ParsedSql`, you can easily re-use it in your methods, by passing it to the constructor of `DbOomQuery`. Just be sure that parsing is done _after_ the *DbOom* initialization!

## DbEntitySql

With `DbSqlBuilder` engine it is possible to create high-level factories that can simplify database usage. One such factory already exist: `DbEntitySql`. Here are some usage examples:

~~~~~ java
    DbOomQuery.query(session,
        dbOom.entities().insert(new Girl(...)).executeUpdate();
    // more fluent
    dbOom.entities().insert(new Girl(...)).
        query(session).executeUpdate();

    Girl girl = ...
    dbOom.entities()..find(girl);
    dbOom.entities()..findById(girl);    // find entity only by id,
                                        // other properties are ignored
    dbOom.entities()..deleteById(girl);  // deletes by id
~~~~~

Of course, it is possible to create even higher level of encapsulation,
but this not something what library such this should provide.
