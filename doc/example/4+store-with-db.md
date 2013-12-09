# Store with Db

<div class="doc1"><js>doc1('example',22)</js></div>
After setting the presentation layer and the service layer, we are now
ready to dive into the database. The first thing is to connect to one.
As expected, we will initialize database connection in `AppCore`. But
that is not all, we need to set up the *DbOom* tool in such way to
minimize all work with the framework as much as possible. And at the
end, we will present a micro database layer that emphasizes simplicity
of working with database. So lets start.

## Database initialization

Method `initDb()` from `AppCore` was already introduced before and here
is how it may look like:

~~~~~ java
    void initDb() {
    	// connection pool
    	petite.registerBean("dbpool", CoreConnectionPool.class);
    	ConnectionProvider cp = (ConnectionProvider) petite.getBean("dbpool");
    	cp.init();

    	// global settings
    	DbDefault.debug = true;
    	DbDefault.connectionProvider = cp;
    	DbDefault.sessionProvider = new ThreadDbSessionProvider(true);

    	DbOomManager dbOomManager = DbOomManager.getInstance();

    	// manual configuration (before entities registration)
    	dbOomManager.setTableNamePrefix("je_");
    	dbOomManager.setTableNameUppercase(false);
        dbOomManager.setColumnNameUppercase(false);

    	// automatic configuration
    	AutomagicDbOomConfigurator dbcfg = new AutomagicDbOomConfigurator();
    	dbcfg.setIncludedEntries(this.getClass().getPackage().getName() + ".*");
    	dbcfg.configure(dbOomManager);
    }
~~~~~

Let's analyze what we did here.

## Connection pool

Here we use `CoreConnectionPool` as application connection pool. It is
working, it is simple and it is available out of Tomcat. Of course,
nothing is stopping us from using `DataSource` - in that case we would
use the `DataSourceConnectionProvider` instead. However, data source is
not available out of Tomcat; then usually you need to put jdbc driver in
Tomcats lib folder...

Notice little trick we used: connection pool is manually registered as
*Petite* bean, and then immediately lookuped from the container. Why that?
So the connection pool instance becomes aware of *Petite* properties
(defined in previous step). Properties will be loaded during *Petite*
initialization and then injected into the bean on its creation.

This trick allow us to externalize connection pool configuration in the
`app.props` file:

~~~~~
    # database
    jdbc.driverClassName=com.mysql.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/jodd-example
    jdbc.username=root
    jdbc.password=root!

    # db pool
    dbpool.driver=${jdbc.driverClassName}
    dbpool.url=${jdbc.url}
    dbpool.user=${jdbc.username}
    dbpool.password=${jdbc.password}
    dbpool.maxConnections=50
    dbpool.minConnections=5
    dbpool.waitIfBusy=true
~~~~~

## SessionProvider

Since we do not want to manually open sessions, we can setup the session
provider: nice, friendly class that will provide database session when
required. Since we are building a web application, we can assume that
each request is a separate thread, so we can create a db session and
store it in the thread storage to make it available during the request.
This is set in lines 9 and 10. When `ThreadSessionProvider` is created
with `true` flag, it will be create db sessions if missing (otherwise it
throws an exception).

## DbOom configuration

*DbOom* is set through `DbOomManager`. The only thing we set here is the
table prefix and if table names and columns names are in lowercase. Of
course, by using the same trick as above, we can also externalize
*DbOom* settings in the props file, too.

The best part is left for the end: automatic registration of all db
entities found on the class path.

## DB Entities

Although Db entities in *Jodd* are POJOs, it will be healthy to create
one base abstract type for all entities. To make our life simpler, we
gonna put some more assumptions: lets say that all entities have `Long`
primary key named `ID`. Now, if `id` property of entity is set, we say
that entity is persistent (stored in database), if property is `null`,
we say entity is new, not saved yet. So our abstract entity may look
like:

~~~~~ java
    public abstract class Entity {

    	@DbId
    	protected Long id;
    	public Long getId() {
    		return id;
    	}
    	public void setId(Long id) {
    		this.id = id;
    	}

    	public boolean isPersistent() {
    		return id != null;
    	}

    	@Override
    	public int hashCode() {
    		if (id == null) {
    			return System.identityHashCode(this);
    		}
    		return 31 * id.hashCode();
    	}

    	@Override
    	public boolean equals(Object o) {
    		if (this == o) {
    			return true;
    		}
    		if (o instanceof Entity == false) {
    			return false;
    		}
    		Entity entity = (Entity) o;
    		if (id == null && entity.id == null) {
    			return this == o;
    		}
    		if ((id == null) || (entity.id == null)) {
    			return false;
    		}
    		return id.equals(entity.id);
    	}

    	@Override
    	public String toString() {
    		return "Entity{" + this.getClass().getSimpleName() + ':' + id +	'}';
    	}
    }
~~~~~

Now create domain/model objects that inherits the `Entity`\:

~~~~~ java
    @DbTable
    public class User extends Entity {

        @DbColumn
        private String name;

        @DbColumn
        private String email;

        ...
        // accessors methods
    }
~~~~~

`User` entity is now \'mapped\' to the following database table (MySql
syntax):

~~~~~ sql
    create table je_user(
        id int unsigned not null primary key auto_increment,
        name varchar(20),
        email varchar(20)
    );
~~~~~

This makes mapping done! We are ready to use our mapped table, but...
let's first make things even more easier :)

## Generic Dao

Now we are able to create generic DAO for basic operations. We will use
`DbEntitySql` generators for that. Before we continue, we will assume
one last thing: the IDs are autogenerated on insert. Again, we can build
the generic DAO in other cases as well, such as using sequences for
calculating the next ID value or using specific tables etc; this all
depends on how *Y**ou* would like to organize the database.

Back to generic DAO source:

~~~~~ java
    import static jodd.db.oom.DbOomQuery.query;
    import static jodd.db.oom.sqlgen.DbEntitySql.insert;
    import static jodd.db.oom.sqlgen.DbEntitySql.updateAll;

    @PetiteBean
    public class AppDao {

    	public <E extends Entity> E store(E entity) {
    		if (entity.isPersistent() == false) {
    			DbQuery q = query(insert(entity));
    			q.setGeneratedColumns();
    			q.executeUpdate();
    			long key = q.getGeneratedKey();
    			entity.setId(Long.valueOf(key));
    			q.close();
    		} else {
    			query(updateAll(entity)).executeUpdateAndClose();
    		}
    		return entity;
    	}

    	public <E extends Entity> E findById(Class<E> entityType, Long id) {
    		return query(DbEntitySql.findById(entityType, id))
                    .findOneAndClose(entityType);
    	}

    	public <E extends Entity> E findOne(E criteria) {
    		return (E) query(DbEntitySql.find(criteria))
                    .findOneAndClose(criteria.getClass());
    	}

    	public <E extends Entity> List<E> find(E criteria) {
    		return (List<E>) query(DbEntitySql.find(criteria))
                    .listOneAndClose(criteria.getClass());
    	}

    	public void deleteById(Class entityType, Long id) {
    		query(DbEntitySql.deleteById(entityType, id))
                    .executeUpdateAndClose();
    	}
    ....
    }
~~~~~

Notice there is no single line of SQL used in the code. Common SQL
codes, like for creating and finding are generated by `DbEntitySql`.

## Usage example, finally

We all waited this :) From here you can continue in any direction you
like. Here is just a quick usage example. First, lets wire `AppDao` with
`FooService`\:

~~~~~ java
    @PetiteBean
    public class FooService {

    	@PetiteInject
    	AppDao appDao;

    	public void storeUser(User user) {
    		appDao.store(user);
    	}
    }
~~~~~

Here is how we can use it from our `LocalRunner`\:

~~~~~ java
    public class LocalRunner {

    	public static void main(String[] args) {
    		AppCore appCore = new AppCore();
    		appCore.start();

    		PetiteContainer pc = appCore.getPetite();
    		FooService fooService = (FooService) pc.getBean("fooService");

    		User user = new User();
    		user.setName("test");
    		user.setEmail("test@foo.com");

    		fooService.storeUser(user);     // insert new user
     		System.out.println(user);

    		user.setEmail("user@foo.com");
    		fooService.storeUser(user);     // update user

    		ThreadDbSessionProvider.closeThreadDbSession();

    		appCore.stop();
    	}
    }
~~~~~

Code is self-explanatory. User object is created and then stored in the
database. Database session is created in line #14 (before user is saved
in the DB) and assigned to current thread. In line #18, on update,
session is reused from the thread storage. At the end, we must close
session explicitly, in line #20 (that's because we do this from the
command line). Of course, this is something that has to be moved to
`AppCore.stop()` method.

## Recapitulation

We learned here to create POJO entity that is mapped to the database
table. We also learned that for basic DB operations we don't even have
to write any SQL.

