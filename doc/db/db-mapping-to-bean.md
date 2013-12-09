# DbOom: Mapping to a bean

<div class="doc1"><js>doc1('db',20)</js></div>
There are cases when you have to write complex queries with some
calculations, string manipulation, etc. when some result set columns are
calculated and not simple table columns values. The question is how to
map such columns using *DbOom* and template SQL.

One answer is simple: you can map such result set into simple types,
like `Integer`, `String`, etc. classes. However, it would be more
convenient if you can map such result into a bean.

To do that, you can create a view in database. However, there are some
cases when you can't use views. Do not worry, *DbOom* can help you
anyway. Just use `$C` template-sql macro as alias column name.

Let's focus on the following sql:

~~~~~ sql
    select g.ID + 10, UCASE(g.NAME), g.* from GIRL g where g.ID=1
~~~~~

Two first columns are calculated ones. As said, we can map this result
to: `Long.class, String.class, Girl.class`. But lets see how we can map
first two columns into the some `Bean1` class, a pure POJO.

First thing is to annotate `Bean1` class with `@DbTable` and `@DbColumn`
annotations, as it is a mapped bean.

Then, you can write above query using the following template-sql:

~~~~~ sql
    select $g.id + 10 as $C{Bean1.sum}, UCASE($g.name) as $C{Bean1.bigName}, $C{g.*}
    from $T{Girl g}
    where $g.id=1
~~~~~

The key point here is to map columns using `$C` macro and the bean name.

