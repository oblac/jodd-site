# First Components

<%= render '/_wip.html' %>

By default, *Joy* scans the classpath for all:

+ *Madvoc* components and web components,
+ *Petite* bean,
+ *DbOom* entity beans.

This means that all you have to do is to just start adding your code!

## Madvoc

Add you `*Action` classes - they will be founded by *Joy* and registered. It make sense to add package-level annotation `@MadvocAction` to markup the root package for your actions.

## Petite

The same goes for the *Petite* - just start adding your *Petite* beans.

## Transactions

By default, the transactions will be managed on methods annotated with one of the `@Transaction` annotations.

## Db

*Joy* connects to the database and prepares the connection pool. Database is detected and properly configured.

Database entities can be found on the classpath.