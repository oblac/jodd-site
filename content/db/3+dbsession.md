# DbSession

`DbSession` encapsulates a database connection. It also plays nicely with `DbQuery`-ies and has some convenient features.

## Connection providers

Connection provider is an object that provides connection to database when requested; and release one when not needed anymore. It encapsulates real mechanism how the database connection is actually retrieved and released.

*DbOom* offers several `ConnectionProvider` implementations: using `DataSource`, `DriverManager`, `XADataSource` or `ConnectionPoolDataSource`. More, *DbOom* has its own connection pool implementation, `CoreConnectionPool`, that works quite nicely.

## Basic usage

`DbSession` uses `ConnectionProvider` for getting the actual database connections. Once created, `DbSession` are used for creating `DbQuery`-ies. `DbSession` takes care of created `DbQuery` instances during its session and closes all resources at the end: all queries and therefore all created result sets. At the end, `DbSession `returns connection back to `ConnectionProvider`. Here is an example of basic `DbSession` usage:

~~~~~ java
    DbSession session = new DbSession(connectionProvider);
    ...
    session.beginTransaction();
    DbQuery query = new DbQuery(session, "insert into...");
    query.executeUpdate(true);      // 'true' -> query closes after execution
    session.commitTransaction();
    ....
    query2 = new DbQuery(session, "select * from... ");
    ResultSet rs = query2.execute();
    ....
    session.close();				// only session is explicitly closed :)
~~~~~

In above example only `DbSession` is explicitly closed. As said, `DbSession` keeps track of all created `DbQuery`-ies. On session closing, all open queries will be implicitly closed; therefore all created and still open ResultSet's will be closed. Even this is nice feature, some may like more to explicitly close each resource - with *Db* this is just matter of couple of lines anyway.

## DbThreadSession

`DbSession` is open for extension. One such extension already exists: `DbThreadSession`. Upon creation, it assigns created session to the current thread. From there, it is possible to retrieve the current session in any other part or layer of the application, without the need to carry it on through method arguments or any other way. This might be useful when one session (i.e. connection) is used per single thread, through application layers.

~~~~~ java
    // create session and assign it to the thread
    DbSession session = new DbThreadSession(connectionProvider);
    ...
    ...// some layers in between
    ...
    // retrieve session from thread
    DbSession session = DbThreadSession.getCurrentSession();
    DbQuery query = new DbQuery(session, "select...");
    ...
    ...// going back
    ...
    session.close();		// close the session and remove it from thread storage
~~~~~

## DbSessionProvider

Above code that works with `DbQuery` suffers from following issue: it has strong dependency on concrete `DbSession` implementation! The goal would be to loose coupling between `DbQuery` and `DbThreadSession` on the place where `DbQuery` is used. *DbOom* has solution for this problem, too.

`DbSessionProvider` implementation is responsible for returning `DbSession` inside some context (thread, request...). This may be a new session or existing one. It is possible to register default `DbSessionProvider` implementation, so no `DbSession` has to be specified when creating new `DbQuery`. `ThreadDbSessionProvider` is default session provider and it manages sessions inside a thread. Above code may be re-written like this:

~~~~~ java
    // create session and assign it to the thread
    DbSession session = new DbThreadSession(connectionProvider);
    ...
    ...// some layers in between
    ...
    DbQuery query = new DbQuery("select...");	// no session reference is needed
    ...
    ...// going back
    ...
    session.close();		// close the session and remove it from thread storage
~~~~~

When `DbQuery` is created without provided session or connection argument, it uses default session provider, which is, by default, `ThreadDbSessionProvider`. This provider returns assigned session from current thread. If no session is assigned, exception is thrown.

`DbSessionProvider` implementation does not control `DbSession` lifecycle!
{: .attn}

It is very important to understand that `DbSessionProvider` does not controls the `DbSession` - it does not open or close one. So database session should be created manually before usage; and then assigned or connect somehow to the `DbSessionProvider` instance; also it has to be closed manually after the usage.

## Transactions

`DbSession` works with transactions in expected way.

~~~~~ java
    session.beginTransaction(
        new DbTransactionMode().isolationNone().setReadOnly(true));
    try {
    	DbQuery query = new DbQuery(session, "insert into...");
        // 'true' means that query will be closed after execution
    	query.executeUpdate(true);
    	session.commitTransaction();
    } catch(DbSqlException dbsex) {
    	session.rollbackTransaction();
    }
    System.out.println(session.isTransactionActive());
~~~~~

The last row prints `false`, since transaction is not active anymore. When a session is not under transaction, it is in the auto-commit mode.

This is just basic transaction usage, *Jodd* offers more complex transaction management, using also propagations.