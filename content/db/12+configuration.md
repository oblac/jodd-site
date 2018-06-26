# Db configuration

Configuration of *Db* and *DbOom* frameworks is set in `DbOom`.

There are two things to remember when talking about *Db* configuration.

1.  **Configure first!** Try to configure before use or register
    entities. That would significantly reduce number of errors.
2.  **Be aware of JDBC driver varieties**! JDBC drivers behave
    differently. Some have implemented most of the specified methods and
    provides enough meta-data, others omit some informations. Therefore,
    be patient and learn what your database driver can do; and configure
    *DbOom* accordingly.

Configurations are located mostly in the following classes:

+ `DbQueryConfig` - configuration related to queries.
+ `DbOomConfig` - everything related mapping, naming conventions etc.

## Best practices

As said, every JDBC driver and database behaves differently. Here are some best practice you can use in your projects:

* Establish convention between entity names and tables names.
* Use strict matching, i.e. set correct letter case for table and column
  names.
* Bidirectional mapping between table and entity may not work because of
  missing meta-data in JDBC driver. Try using explicit conversion to
  types.
* Use code `columnAliasType` if needed.
* Use `$C{}` just for selected columns, and nothing else.
* Don't forget that letter case of tables is different when created
  from the code.

Very often (at the beginning of the project), *DbOom* is not working because of wrong letter case and mismatched conventions. Just experiment a bit until you set it right:) Once set, everything goes smoothly:)
