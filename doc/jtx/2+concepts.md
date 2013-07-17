# JTX concepts

*JTX* is all about: resources, resource managers, transactions and
transaction managers.

## Resources and Resource managers

Resource in *JTX* is anything that have transactions. Speaking
programatically, resource is any class than encapsulates some
transactional entity, for example: database session (for databases),
messages manager (for message queues). Resource knows how to
**maintain** a transaction.

Each resource (i.e. resource type) has its own resource manager. In
*JTX*, resource manager is responsible for managing transactions of the
resources of the same type. As seen in the code, `JtxResourceManager`
interface is fairly simple, two most important methods are
`beginTransaction()` and `rollbackTransaction()`.

We can say that `JtxResourceManager` serves as an **adapter** between
*JTX* framework and some transactional resource. For e.g. database that
would be an implementation that takes database session (or connection)
and creates a new transaction on it. Since it is an adapter, beginning
and rolling back the transactions can be now done through resource
manager, without touching the resource itself.

## Transaction manager

Transaction manager goes one step further. It's purpose is to control
all registered resource managers and to create/close transactions on all
acquired resources. *JTX* transaction manager also provides out-of-box
transaction propagation handling. Let's see more details of
`JtxTransactionManager`.

As said, *JTX* transaction manager is used to start transactions.
Actually, when needed transactions are **requested** from the *JTX*
manager. Depending on transaction **propagation**, manager will return
an existing transaction or a new one.

Requested transactions may be optionally scoped by context in which they
exists. Only one transaction may be opened in the context. For example,
context can be a class within the transactions are created, so only the
first method of that class will create the transaction; if that method
internally invoke other (transactional) methods, their requests will be
ignored.

## Transaction

Transaction is an unit of work that is performed by one or more
resources. Great definition, huh:)? In *JTX*, transactions are
encapsulated by `JtxTransaction` class. The most important thing to
remember about it is that:

`JtxTransaction` is a '**transactional request**'. Its existence
doesn't mean that real transaction is started on the resources(s).
{: .attn}

We said that `JtxTransactions` are **requested** from the
`JtxTransactionManager`. But only when a **resource** is requested from
the jtx transaction, a real transaction is started on the resource!

*JTX* supports several different resource types, i.e. a transaction can
be started over several resources. When committed, a real transaction is
committed on each resource, one by one. We are aware this is not the
ideal scenario for transactions over multiple resources, but it is
pragmatic; on the other hand *JTX* is usually used in one-resource-type
environment, where the only resource is database.

### Transaction status

*JTX* transaction goes through several statuses during it's usage; they
are very similar to JTA. On the very beginning, status is either
`ACTIVE` or `NO_TRANSACTION`. As said, *JTX* transaction is an actual
transaction **request**, therefore even if a real transaction is not
required - e.g. as defined by propagation, there will be a
`JtxTransaction` object in state `NO_TRANSACTION`.

Other statuses are self-explanatory and can be seen in javadoc or
source.

## Transaction mode

Following attributes defines transaction mode.

### Propagation behavior

Propagation behavior is used to define the transaction boundaries. It
defines behavior if a transactional method is executed when a
transaction context already exists.

*JTX* provides its own propagation management.

### Isolation level

Isolation level has something to do with the concurrency control. When
multiple transactions are running they may cause dirty reads, non
repeatable reads and phantom reads. It is the degree of isolation one
transaction has from the work of other transactions. For example, can
this transaction see uncommitted writes from other transactions?

Isolation level is currently not supported by *JTX*. It is expected to
be managed by transactional resource itself.

### Timeout

Defines how long this transaction may run before timing out. Currently,
*JTX* only checks the length of the transaction; longer transaction will
not be canceled after timeout period.

### readOnlyMode

Read-only transaction does not modify any data. Transaction should fail
on write attempt. *JTX* does not treat this flag, it just passes it to
the resource manager i.e. resource.

## Propagation behavior management

One very important feature provided by `JtxTransactionManager` is
propagation behavior management. This means that manager will handle
transaction propagation as defined by transaction mode attribute.

Following propagations are supported by *JTX*\:

* `PROPAGATION_REQUIRED` - Support a current transaction, create a new
  one if none exists;
* `PROPAGATION_SUPPORTS` - Support a current transaction, execute
  non-transactionally if none exists;
* `PROPAGATION_MANDATORY` - Support a current transaction, throw an
  exception if none exists;
* `PROPAGATION_REQUIRES_NEW` - Create a new transaction, suspend the
  current transaction if one exists;
* `PROPAGATION_NOT_SUPPORTED` - Execute non-transactionally, suspend the
  current transaction if one exists;
* `PROPAGATION_NEVER` - Execute non-transactionally, throw an exception
  if a transaction exists.

