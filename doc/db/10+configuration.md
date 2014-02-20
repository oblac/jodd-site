# Db configuration

<div class="doc1"><js>doc1('db',20)</js></div>
Configuration of *Db* and *DbOom* frameworks is set in `DbManager` and
`DbOomManager`. Both classes are singleton beans.

There are two things to remember when talking about *Db* configuration.

1.  **Configure first!** Try to configure before use or register
    entities. That would significantly reduce number of errors.
2.  **Be aware of JDBC driver varieties**! JDBC drivers behave
    differently. Some have implemented most of the specified methods and
    provides enough meta-data, others omit some informations. Therefore,
    be patient and learn what your database driver can do; and configure
    *DbOom* accordingly.

## DbManager

`DbManager` defines some providers:

* `connectionProvider` - default connection provider.
* `sessionProvider` - default session provider, by default it's
  `ThreadDbSessionProvider`.

and some query-related properties:

* `forcePreparedStatement` - if *Db* should always create prepared
  statements
* `type`, `concurrencyType`, `holdability` - default query options
* `fetchSize`, `maxRows `- default query values

and debug mode flag:

* `debug` - when turned on, prepared statement query will contains real
  values instead of ?

`DbManager` contains no logic.

## DbOomManager

`DbOomManager` contains more options about tables and object mappings.
First, there are properties regarding naming conventions:

* `schemaName` - schema name, sometimes needed by database
* `tableNames` - set of table naming strategy properties, like:
  uppercase, splitCamelCase, prefix, suffix...
* `columnNames` - set of column naming strategy properties.

There are properties about column alias:

* `defaultColumnAliasType` - default way how columns are aliased
* `columnAliasSeparator` - separator character used for some aliasing
  modes.

Besides configuration, `DbOomManager` is also a central place for
storing mappings between entities and tables, and also a factory for
entities and various *DbOom* classes. If you need, it make sense to
override it.

## Best practices

As said, every JDBC driver behaves differently. Here are some best
practice you can use in your projects:

* Establish convention between entity names and tables names.
* Use strict matching, i.e. set correct letter case for table and column
  names.
* Bidirectional mapping between table and entity may not work because of
  missing meta-data in JDBC driver. Try using explicit conversion to
  types.
* Use code `columnAliasType` if needed.
* Use `$C{}` just for selected columns, and nothing else.
* Don\'t forget that letter case of tables is different when created
  from the code.

Very often (at the beginning of the project), *DbOom* is not working
because of wrong letter case and mismatched conventions. Just experiment
a bit until you set it right:) Once set, everything goes smoothly:)

