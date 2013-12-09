# Db and annotations

<div class="doc1"><js>doc1('jtx',20)</js></div>
*JTX* supports multiple resource types, but its most efficient with
single resource type, such as relational database. Therefore, there is
whole layer build on top of generic *JTX* classes that serves just to
simplify use and usage of transaction over databases.

## Declarative transactions

But that is not all. Transactions, in general, are a perfect example of
scattered logic, that can be encapsulated via aspects. With help of
*Proxetta*, *JTX* can be applied on methods that are annotated with
`@Transaction` annotation.

### Custom transactions

In most applications we would have only two types of transactions: one
that only read and one that allows writing data. `@Transaction`
annotation by default matches read-only transactions, meaning that on
every place where read-write transaction is needed, user have to write
this with annotation elements.

To reduce this boilerplate code, it is possible to define custom
annotation that takes different default values.
