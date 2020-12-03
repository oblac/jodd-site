# DbQuery

`DbQuery` is an enhanced wrapper for prepared and regular JDBC statements. In the base scenario, it can be used anywhere where JDBC statements would be used. Nevertheless, `DbQuery` provides some additional very convenient features.

## Basic usage

The basic way how `DbQuery` can be created is by providing database connection. Once created, it can be used similarly as JDBC statement is used:

~~~~~ java
    DbQuery query = DbQuery.query(connection, "create table ...");
    query.executeUpdate();
    query.close();              // or just: query.autoClose().executeUpdate();
    ...
    query = DbQuery.query(connection, "select * from ....");
    query.setString(1, "param1");
    ResultSet rs = query.execute();
    ...
    query.closeResultSet(rs);   // not needed, but still nice to have
    query.close();
~~~~~

Method `autoClose()` enables 'auto-mode' when the very first next action closes the query. Besides displayed methods, there is method: `executeCount()` that is made for executing `select count` database queries, or any query that returns a `long` number in the first result row and column.

Closing queries is important. Fortunately, *DbOom* allows user to invoke `close()` method, and all the dirty work is done in the behind. When a query created some `ResultSet`, it is possible to explicitly close it using `closeResultSet()` method. However, this is not mandatory! User may just simply close a query, and the `DbQuery` will close all results set that were created by it! As will be shown later, it is even possible to have automatic query closing:)

## Named parameters

Prepared JDBC statement has only ordinal parameters. For long and dynamic SQL queries, setting ordinal parameters may be tricky, and user has to be unnecessary careful. Besides ordinal parameters, `DbQuery` offers named parameters as well.

~~~~~ java
    DbQuery query = DbQuery.query(connection,
        "select * from FOO where id=:id and name=:name");
    query.setLong("id", id);
    query.setString("name", "john");
    ResultSet rs = query.execute();
    ...
    query.close();
~~~~~

Named and ordinal parameters may mix in one query, although that is is not a good practice.

## Debug mode

When printing JDBC prepared statements, all parameters are represented with a question mark and not real values. This makes things difficult for debugging. `DbQuery` offers the _debug mode_ that will return the same query string, but populated with real values. Such debug query is just a quick-and-dirty preview and not always 100% syntaxly correct (e.g. strings are not escaped, etc), but sufficient for debugging purposes.

~~~~~ java
    DbQuery query = DbQuery.query(connection,
        "select * from FOO where id=:id and name=:name");
    query.setDebugMode();          // must be called before setting parameters
    query.setLong("id", id);
    query.setLong("name", "jodd");

    System.out.println(query);
~~~~~

Here is the difference that debug mode makes:

~~~~~ sql
    select * from FOO where id=? and name=?
    select * from FOO where id=173 and name='jodd'     -- debug mode
~~~~~

## Configuration & Lazy initialization

`DbQuery` initializes lazy. Creating an object still doesn't do anything with the database, therefore it can be configured as needed. `DbQuery` initializes on first concrete database-related method. Therefore, setting the debug mode (and other configuration) must be done immediately after the `DbQuery `object creation.

## Parameters setters

All prepared statement setting methods are implemented in `DbQuery`. As said, each method now has two versions: one that works with ordinal parameters and one for named parameters. Moreover, during setting of a parameter, value will be checked, and if it is `null`, the `setNull`() method will be invoked instead.

There are some new methods for setting parameter values, such as: `setBean()`, `setMap()`, `setObject()`, `setObjects()`...

With `setBean()` it is possible to populate query string where parameters are named as bean properties:

~~~~~ java
    DbQuery query = DbQuery.query(connection,
        "select * from FOO f where f.ID=:foo.id and f.NAME=:foo.names[0]");
    query.setBean("foo", Foo);
~~~~~

## SqlTypeManager and setObject()

`DbQuery` provides new method `setObject()` for setting objects of unknown type as parameters. For that purpose, `DbQuery` must resolve the way how to handle provided type and to invoke correct setter method.

*DbOom* has one central point for resolving SQL types from object types: `SqlTypeManager`, manager for all kind of different `SqlType`s. Each `SqlType` defines how a type is set and get from the database. There is a large amount of already defined types, however, it is easy to add new and more complex ones.

## Auto-generated columns

`DbQuery` supports auto-generated columns:

~~~~~ java
    // Example #1:
    DbOomQuery q = DbOomQuery.query(connection,
            "insert into FOO(Data) values('data')");
    q.setGeneratedColumns();            // indicate some auto-generated columns
    q.executeUpdate();

    // get the first auto-genereted column, i.e. usually ID
    long key = q.getGeneratedKey();
    q.close();
~~~~~

~~~~~ java
    // Example #2:
    DbOomQuery q = DbOomQuery.query(connection,
            "insert into FOO(Data) values('data')");
    q.setGeneratedColumns("ID");        // indicate auto-generated column
    q.executeUpdate();
    ResultSet rs = q.getGeneratedColumns();
    ...
    q.closeResultSet(rs);
    q.close();
~~~~~

You could also use `q.setGeneratedKey()` instead of `q.setGeneratedColumns()` in the first example, if that sounds better to you :) Please note that some old database drivers does not support this feature (like HSQLDB 1.x).

## Stored Procedures

`DbQuery` supports calling stored procedures. The result of the stored procedure is encapsulated in `DbCallResult`.

~~~~~ java
    DbQuery query = DbQuery.query(connection, "{ :upp = call upper( :str ) }");
    query.setDebugMode();
    query.setString("str", "some lowercase value");
    query.outString("upp");

    DbCallResult callResult = query.executeCall();
    // now work with result from stored procedure via DbCallResult
    String str = callResult.getString("upp")

    query.close();
~~~~~
