# Mapping

When it comes to mapping, *DbOom* tries its best to match database types with Java types of POJO properties (i.e. mapped columns). *DbOom* knows how to convert between various SQL types and common Java types, including `enums`. SQL types in *DbOom* are actually implementations of `SqlType`, that defines how to convert values between SQL and Java types.

## Custom Mapping

It is possible to define custom SQL types, i.e. custom type mappings. They can be defined in two ways:

+ _globally_: custom `SqlType` implementation is registered in `SqlTypeManager`. Such SQL types are available all across the application.

+ _locally_: defined in `@DbColumn` annotation by setting `sqlType` element, this custom type applies only on annotated property.

SQL types defined in annotation are always used, even if java type of a property has its own SQL type already registered.

## Naming strategies

For successful mapping and *DbOom* functionality, table and column naming strategies must match how used database works.

This is very important to understand! *DbOom* has table and column name naming strategies that define how entity/column names are converted _to_ and _from_ the mapped class/property names. Notice that these naming strategies are used in **both** directions: when converting from table/column name to class/property and vice-versa (i.e. _mapping_); and when converting from class/property to table/column name (i.e. _resolving_).

For example, if you have a table `JJ_FOO_BAR` (prefix and uppercase) and column `value_data` (lowercase), it may be mapped to class `FooBar` (camel-case strategy) and property `valueData` (again, camel-case). The opposite mapping also has to match: class `UserData` may be resolved to e.g. table `EX_USER_DATA_N` (uppercase with both prefix and suffix); property `valueData` may be resolved to column `value_date` (lowercase).

Here are the possible naming strategies options (defined in `DbOomManager`):

+ `splitCamelCase` - if camel case words should be split with `separatorChar`.
+ `separatorChar` - simple char used when `splitCamelCase` is `true`, by default its `_`
+ `changeCase` - when `true` (default) table or column names will be changed to upper or lowercase.
+ `uppercase` or `lowercase` - defines it table or column name should be converted to upper case or lowercase.
+ `prefix` and `suffix` - table names may have prefix and/or a suffix.

Why naming is important? Naming strategies must match how target database works. Wrong naming strategy is the most common configuration mistake when using *DbOom*!
{: .attn}

Therefore, when working with *DbOom*, please use uniform naming convention across the whole database and please match it with how JDBC drivers work! One thing that can help is to enable logging. If you see WARN message like this:

     [WARN] Column SQL type not available: DbEntity: TESTER2.TIME

then it is a sign that mapping or naming conventions might be wrong.

## Database auto-detection

Upon start, `DbOom` connects to the database and detects the vendor. Depending of the used database, `DbOom` should set correct naming conventions.

## Mapping Example

<table width="96%">
<tr><td width="200px" markdown="1">
~~~~~ java
@DbTable
public class Foo {

    @DbId
    public long id;

    @DbColumn
    public MutableInteger number;

    @DbColumn(
        sqlType = IntegerSqlType.class)
    public String string;

    @DbColumn
    public String string2;

    @DbColumn
    public Boo boo;

    @DbColumn
    public FooColor color;

    @DbColumn(
        sqlType = FooWeigthSqlType.class)
    public FooWeight weight;

    @DbColumn
    public Timestamp timestamp;

    @DbColumn
    public Clob clob;

    @DbColumn
    public Blob blob;

    @DbColumn
    public BigDecimal decimal;

    @DbColumn
    public BigDecimal decimal2;

    @DbColumn
    public LocalDateTime jdt1;

    @DbColumn
    public LocalDateTime jdt2;
}
~~~~~
</td><td width="200px" markdown="1">
~~~~~ sql

create table FOO (


    ID          integer     not null,


    NUMBER      integer     not null,


    STRING      integer     not null,



    STRING2     integer     not null,


    BOO         integer     not null,


    COLOR       varchar     not null,



    WEIGHT      integer     not null,


    TIMESTAMP   timestamp   not null,


    CLOB        longvarchar not null,


    BLOB        longvarbinary not null,


    DECIMAL     decimal     not null,


    DECIMAL2    varchar     not null,


    JDT1        bigint      not null,


    JDT2        varchar     not null,

    primary key (ID)
)
~~~~~
</td></tr>
</table>

Most of above mappings are straightforward: number fields are mapped to number java types, varchars to strings, etc. There are some useful additional mappings, like mapping `String` values to integer columns - of course, it is assumed that string contains only digits. In this example you can see two explicit local mapping, when SQL type is defined in `@DbColumn` annotation.

### Custom mappings

Now something interesting: property `boo` has a custom type `Boo`, and it is also mapped to database. Of course, this mapping can't be done automatically. We must provide custom `SqlType` that explains how to convert database value to and from `Boo` type. Since we want to use this mapping everywhere, we might register it globally:

~~~~~ java
    SqlTypeManager.get().register(Boo.class, BooSqlType.class);
~~~~~

and `BooSqlType` may look like:

~~~~~ java
    public class BooSqlType extends SqlType<Boo> {

        @Override
        public void set(PreparedStatement st, int index, Boo value)
                throws SQLException {
            st.setInt(index, value.value);
        }

        @Override
        public Boo get(ResultSet rs, int index) throws SQLException {
            Boo boo = new Boo();
            boo.value = rs.getInt(index);
            return boo;
        }
    }
~~~~~

In this simple example, `Boo` is stored as an integer in database; however, you can create a more complex SQL type and conversion.

### Enum mappings

Lets see how simple enumeration (`FooColor`) can be stored to database. Enumerations, by default, are stored as strings (varchars...).

Now, enumeration may be stored as other SQL type, but it is necessary to define custom `SqlType` for mapping conversion. One such implementation may look like:

~~~~~ java
    public class FooWeigthSqlType extends SqlType<FooWeight> {

        @Override
        public void set(PreparedStatement st, int index, FooWeight value)
                throws SQLException {
            st.setInt(index, value.getValue());
        }

        @Override
        public FooWeight get(ResultSet rs, int index) throws SQLException {
            return FooWeight.valueOf(rs.getInt(index));
        }
    }
~~~~~

If you have enumerations that are mapped to an integer, you don't even have to write custom SQL types! So above `SqlType` is NOT needed if you design your enumeration like this:

~~~~~ java
    public enum Status {
        PENDING(0),
        ACTIVE(1),
        COMPLETED(99);

        final int status;
        final String statusString;

        private Status(int status) {
            this.status = status;
            this.statusString = String.valueOf(status);
        }

        public int value() {
            return status;
        }

        @Override
        public String toString() {
            return statusString;
        }
    }
~~~~~

The key thing here is `toString()` that returns int value as a `String`. When you map such enum to a column of some int type, everything will work out of box! This is because of behavior of *BeanUtil* tool. Note that we have cached int value for better performances, to avoid string conversion on every access.

### Other mappings

Other mappings from the example are also straightforward. It is interesting to notice that `LocalDateTime` is stored as number of milliseconds (compatible with `System.currentTimeMillis()`).
