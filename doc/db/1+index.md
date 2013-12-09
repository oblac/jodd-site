<js>javadoc('db')</js>

# Db & DbOom ![db logo](db.png "Db!")

<div class="doc1"><js>doc1('db',20)</js></div>
*Db* is an efficient, powerful and thin layer over JDBC that
significantly simplifies writing of database code. Using pure JDBC api
correctly requires writing the same code snippets over and over again,
what easily leads to unmaintainable application. Often there are
run-time problems just because of incorrect database handling. *Db*
introduces several smart façades that helps in writing smaller, cleaner
and maintainable code.

*DbOom* is the mapper between object and relational world using plain
SQL queries. It defines object-table mappings using annotations or
naming convention. However, relationships are not pre-defined, they are
set on very place where used. The best way how to think of *DbOom* is
from the JDBC perspective: it is not a full-blown complex ORM library;
instead, it is just a nice tool built over *Db* for efficient database
mapping.

## Reasons why

* Significantly simplified JDBC.
* Enhanced statements, named parameters.
* Throws unchecked exceptions.
* Fast, no performance loss, no \*QL parsing.
* Prepared statements debugging mode where all \'?\' are replaced with values.
* Plain good old SQL is used, not proprietary \*QL.
* Easy to learn and understand.
* Easy annotation-based mapping.
* Template-SQL for writing efficient queries.
