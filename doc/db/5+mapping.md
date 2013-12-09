# Mapping

<div class="doc1"><js>doc1('db',20)</js></div>
When it comes to mapping, *DbOom* tries to do it best to match
destination type of POJO properties. By default, *DbOom* will now to
convert between various database (aka sql) types and java types. That
also includes basic `enum` support and so on.

Moreover, it is possible to give additional hints for mapping
conversion, by specifying `sqlType` annotation element of `@DbColumn`.
Sql type is actually one of `SqlType` classes that defines how results
are read from database and stored to bean and vice-versa.

## Example

The best thing to explain all possibilities is the following example:

<table width="96%">
<tr><td width="200px" markdown="1">
~~~~~ java
@DbTable
public class Foo {

    @DbId
    public long id;

    @DbColumn
    public MutableInteger number;

    @DbColumn(sqlType = IntegerSqlType.class)
    public String string;

    @DbColumn
    public String string2;

    @DbColumn
    public Boo boo;

    @DbColumn
    public FooColor color;

    @DbColumn(sqlType = FooWeigthSqlType.class)
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
    public JDateTime jdt1;

    @DbColumn
    public JDateTime jdt2;
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

First two properties are straightforward. Next two properties (lines #11
and #14) are identical: they are `String`s mapped to integer columns.
The first one just shows how to explicitly specify the destination
`SqlType`. Of course, for basic types it is not necessary to specify the
sql type.

### Custom mappings

Now something interesting: line #17 shows how some custom type, `Boo`,
is mapped to database. Of course, this can't be done automatically. One
solution is to specify the sql type in annotation. However, this is not
the only way. Instead, it is possible to register sql type in the
following way:

~~~~~ java
    SqlTypeManager.register(Boo.class, BooSqlType.class);
~~~~~

where `BooSqlType` may look like:

~~~~~ java
    public class BooSqlType extends SqlType<Boo> {

        @Override
        public void set(PreparedStatement st, int index, Boo value) throws SQLException {
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

### Enum mappings

Line #20 shows how simple enumeration (`FooColor`) can be stored to
database. Enumerations, by default, are stored as strings (varchars...).

Now, enumeration may be stored as other sql type, but it is necessary to
define `SqlType` for mapping conversion. One such may look like:

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

### Other mappings

Other mappings from the example are also straightforward. Maybe it is
important to notice that `JDateTime` is stored as number of milliseconds
(compatible with `System.currentTimeMillis()`).
