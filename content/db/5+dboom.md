# DbOom

Up to now, *DbOom* was used as a convenient replacement for JDBC. *DbOom* has much more to offer!

The goal behind *DbOom* is _not_ to have an ORM tool - there are plenty solutions like that out there. Instead, *DbOom* is a thin Object-Mapping layer. Relations are not pre-defined, but defined when actually used: before the query execution; or not defined at all and set manually. Moreover, there is _no_ generic QL language that works across databases; instead you use the full power of native SQL of specific database that is in use. That does not mean that you can't address _entities_ in your queries! With *DbOom* you can use entity names and properties, and they will be converted into the database tables and columns.

## DbOom per database

*DbOom* works with as many databases as you need. Since using a single relational database is a common for projects (at least for projects that uses *Jodd* :) - *DbOom* considers this as a special case and offers many helpful shortcuts for his single-database usage (more later).

The central place in *DbOom* is... a `DbOom` instance (who would guess :). You will have one instance per database. `DbOom` recognizes the single-database usage, making available various shortcuts; mainly preventing you to carry on the instance of `DbOom`.

`DbOom` offers fluent builder to construct itself.

~~~~~ java
	DbOom dbOom = DbOom.create().get();
	dbOom.connect();
~~~~~

or:

~~~~~ java
	DbOom.create()
		.withSessionProvider(mySessionProvier)
		.withConnectionProvider(connectionPool)
		.get()
		.connect();
~~~~~

Once connected to database, `DbOom` detects the database vendor and applies some default naming convention.

## DbOom components

`DbOom` provides access to following components:

+ `DbOomConfig` - configuration, mainly naming conventions,
+ `DbQueryConfig` - query-related configuration,
+ `DbEntityManager` - manager of entity mappings,
+ `DbSessionProvider` - session provider,
+ `ConnectionProvider` - connection provider
+ `QueryMap` - map of named queries.

## DbOom factories

`DbOom` also is a factory for all *DbOom* working tools:

+ `entities()` - returns `DbEntitySql` factory,
+ `sql()` - creates new `DbSqlBuilder`,
+ `query()` - creates new `DbOomQuery()`.

In single-database mode, most of these can be used without referencing `DbOom`.
{: .attn}

The following pages describes all *DbOom* components and tools assuming the single-database mode; for the sake of simplicity.

## Single-database mode

As said, having a single database is a special use case for `DbOom`. Once when created, the instance of `DbOom` can be accessed using the following:

~~~~~ java
    DbOom dbOom = DbOom.get();
~~~~~

The `get()` method will throw exception if multiple databases are in use, or none.

Furthermore, all *DbOom* working tools (classes that are used for quering, mapping etc) have a constructor with `DbOom` as an argument. In single-database mode, you can use static constructor methods, that does not take `DbOom` instance. For example, this usage:

~~~~~ java
    DbOomQuery q = new DbOomQuery(dbOom, dbSession, "select * from ...");
~~~~~

can be replaced with:

~~~~~ java
	DbOomQuery q = DbOomQuery.query(dbSession, "select * from ...");
~~~~~

Finally, you can use the `DbOom` instance directly instead, no matter which mode is in use:

~~~~~ java
	dbOom.query("select * from ...");
~~~~~

The following documentation will assume the single-database mode, just for the sake of simplicity.