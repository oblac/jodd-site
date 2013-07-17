# Relations & Hints

We have already seen how to use *hints* to inject values into resulting
objects. Lets analyze this topic more and see how to deal with the
**one-to-one** and **one-to-many** relations efficiently.

## Problem

Here is the real-life problem. Lets say that we have a list of some
telecommunication centers in database. Each center has one or more
associated prefixes. Also, each center belongs to one country (i.e.
region). We need to fetch all telecom data, as they do not change during
the application runtime.

## Model

Model is no-brainer.

~~~~~ java
    @DbTable
    public class Telecom extends Entity {
    	@DbId
    	private long telecomId;
    	@DbColumn
    	private String name;
    	@DbColumn
    	private long countryId;
    	...
    }
~~~~~

~~~~~ java
    @DbTable
    public class TelecomPrefix extends Entity {
    	@DbId
    	protected long prefix;
    	@DbColumn
    	protected long telecomId;
    	...
    }
~~~~~

~~~~~ java
    @DbTable
    public class Country extends Entity {
    	@DbId
    	long countryId;
    	@DbColumn
    	String name;
    	...
    }
~~~~~

The rest of fields just hold various entity data. All methods are POJO
setters and getters. Model objects, for now, are independent.

Note that each model object extends `Entity` class. This is not
mandatory, but is considered as a good practice. `Entity` class usually
contains implementation of `hashCode()` and `equals()` methods, based on
the **primary key** of the class. Again, this is also not mandatory and
some would consider the whole instance state then just primary keys.
This is fine; using just primary keys is somewhat more pragmatic - and
faster - if code is written with having that in mind.

## Lazy approach

Lazy approach is fetching data without joins, firing several database
queries. In our example we would need to execute the following queries:

* fetch all `Telecom`s.
* For each `Telecom`, fetch list of its `TelecomPrefix`
* For each `Telecom`, fetch the belonging `Country`.

There is nothing special to mention here, each query and *DbOom* usage
is simple.

## Entity relationships

Up to now, there was no dependencies between entities. Obviously, it
make sense to have list of `TelecomPrefix`es inside of `Telecom`, as
well as the single `Country`. Therefore, we can write something like
this:

~~~~~ java
    @DbTable
    public class Telecom extends Entity {
    	...
    	protected TelecomPrefix[] prefixes;
    	protected Country country;
    	// get/set methods for above fields
    	...
    }
~~~~~

Instead of an array of `TelecomPrefix`es, we could use any
`Collection`.
{: .attn}

In the lazy approach, the whole *wiring* would be done manually, by
developer. Once when he get list of `TelecomPrefix` entities for some
`Telecom` he would need to manually convert it to an array and set it
to target.

## Join

This is nice case when we can use a *join* of three tables to fetch
all data in one call. So the code may look like this:

~~~~~ java
		DbOomQuery q = query(sql(
				"select $C{t.*}, $C{tp.*}, $C{c.*} " +
				"from $T{Telecom t} join $T{TelecomPrefix tp} using ($.telecomId) " +
				"join $T{Country c} using ($.countryId)"));

		telecoms = q.list(Telecom.class, TelecomPrefix.class, Country.class);
~~~~~

Here we create join of three tables. Each result set row is mapped to
an object array with three elements: telecom, telecom prefix and
country. And finally, each such object array is stored in resulting
list.

On the first sight, there are no improvements here: for each row, we
still need to manually wire results.

## Hints

Hints to the rescue! As we explained, *hints* defines how to wire
objects within the single row. We want to use hints to inject e.g.
`Country` instance into the `Telecom` instance, in the single row.
Here is how to do so:

~~~~~ java
		DbOomQuery q = query(sql(
				"select $C{t.*}, $C{t.prefixes:tp.*}, $C{t.country:c.*} " +
				"from $T{Telecom t} join $T{TelecomPrefix tp} using ($.telecomId) " +
				"join $T{Country c} using ($.countryId)"));

		telecoms = q.list(Telecom.class, TelecomPrefix.class, Country.class);
~~~~~

The change is small, yet powerful! With hints we instruct to append
all `TelecomPrefix` into the `Telecom.prefixes` property, as well to
inject `Country` into the `Telecom.country`! Resulting list elements
would have just **one** element, a `Telecom`, since all other mapped
elements are injected into this instance.

While this perfectly works with **one-to-one** relationships, like
with `Country`; there is a failure with **one-to-many** relationships,
like with `TelecomPrefix`. This is because for the each row of result
set, *DbOom* will create a **new** instance of `Telecome`. Hence, if a
telecom contain two prefixes, it will be listed twice and each time
telecom will link just one, different, telecom prefix!

## Cache entities

Fortunately, the problem is easy to solve: by enabling caching on
query level (i.e. on result-set level). So this code:

~~~~~ java
		DbOomQuery q = query(sql(
				"select $C{t.*}, $C{t.prefixes:tp.*}, $C{t.country:c.*} " +
				"from $T{Telecom t} join $T{TelecomPrefix tp} using ($.telecomId) " +
				"join $T{Country c} using ($.countryId)"));

		q.cacheEntities(true);
		telecoms = q.list(Telecom.class, TelecomPrefix.class, Country.class);
~~~~~

*DbOoom* now caches **all entities** during the execution of a query
and re-uses existing instances if already exist! In our case this
means that instead of creating several instances of `Telecom` for each
its prefix, there will be just one instance, with many prefixes
injected into it.

Using query cache increases memory usage.
{: .attn}

There is just one thing to be aware of - the resulting list will still
contain duplicated records (hey, it's the same with Hibernate:) The
trivial way to fix this is to use a `Set` instead of `List`\:

~~~~~ java
		DbOomQuery q = query(sql(
				"select $C{t.*}, $C{t.prefixes:tp.*}, $C{t.country:c.*} " +
				"from $T{Telecom t} join $T{TelecomPrefix tp} using ($.telecomId) " +
				"join $T{Country c} using ($.countryId)"));

		q.cacheEntities(true);
		telecoms = q.listSet(Telecom.class, TelecomPrefix.class, Country.class);
~~~~~

What we have now is the set of unique entities, properly injected with
related content.

## EntityAware mode

But using `Set` is not always an option. Can we have a `List`, but
**without** duplicate entries? Sure! `DbOomQuery` supports so called
"entity mode". It goes one step further from
`cacheEntities`, so enabling the entity mode will also enable cached
entities.

In entity aware mode, not only that objects are cached, but also they
are compared to the previous result! The very same example from above:

~~~~~ java
		DbOomQuery q = query(sql(
				"select $C{t.*}, $C{t.prefixes:tp.*}, $C{t.country:c.*} " +
				"from $T{Telecom t} join $T{TelecomPrefix tp} using ($.telecomId) " +
				"join $T{Country c} using ($.countryId)"));

		q.entityAwareMode(true);
		telecoms = q.list(Telecom.class, TelecomPrefix.class, Country.class);
~~~~~

will now return `List` **without** the duplicates! Just a nice object
tree, ready to be used :)
