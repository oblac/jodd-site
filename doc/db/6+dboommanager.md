# DbOomManager

<div class="doc1"><js>doc1('db',20)</js></div>
`DbOomManager` is a manager responsible for registering entity types and
holding various configuration information. It is used by various parts
of *Db* and *DbOom*, therefore it is created as singleton pattern.
Although we are not in love with singleton pattern, this time we made an
exception, in order to make *DbOom* usage easier. Moreover, *DbOom* is
designed to work with single database, so using singleton in this case
makes sense.

## Types registration

Anytime when some types are specified in `DbOomQuery` methods, they are
examined and parsed and these results are stored internally in
`DbOomManager`. This kind of registration is called _types registration_
since only class information is registered in manager.
This means that more then one entity types may be mapped to single
database table. In other words, this is one way mapping:

**Entity &rarr; Table, Entity name**
{: style="text-align:center;"}

Types may be registered manually, although there is no much need for
that, since, as said, all this anyway happens internally.

## Entity registration

To use the full potential of *DbOom*, all entity classes should be
registered as entities in the `DbOomManager` before the usage. Entity
registration supersede the type registration: types and tables now
becomes mapped in both ways:

**Entity &harr; Table, Entity name**
{: style="text-align:center;"}

Now each table name is also uniquely registered with one and only one
entity. While it is still possible to register more types to tables, it
is not possible to register one table name to more then one entities.
`DbOomQuery` will throw exception if that happens.

## Automatic registration

Since entities must be registered manually, there is nice way how all
annotated classes on class path can be registered automatically. This is
done by using `AutomagicDbOomConfigurator`. It scans the class path and
jar files (or part of it, as specified by user) and finds all classes
annotated with `@DbTable`. No class is loaded in class loader unless it
contains correct bytecode.

`AutomagicDbOomConfigurator` offers both way of registration.

## Resolving entities

One of the benefits of entity registration is the feature of resolving
the entities just from the result set meta data. In all `DbOomQuery`
examples, each method accepts explicit list of (entity) classes to which
the result set will be mapped. Now it is possible to omit the list and
let `DbOomQuery` resolve classes by itself:

~~~~~ java
    DbOomQuery q = new DbOomQuery(session, "select * from GIRL join BOY on... where...");
    Girl girl = q.findOne(Girl.class);  // ok
    Girl girl = (Girl) q.findOne();     // throws an exception

    DbOomManager.getInstance().registerEntity(Girl.class);
    Girl girl = (Girl) q.findOne();     // now it works
~~~~~

To some this feature is useful, others doesn't use since it is not so
visible what is the target entity.

