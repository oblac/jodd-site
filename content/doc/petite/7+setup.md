# Setup

*Petite* uses annotation based configuration to make setup and
configuration simple as possible. It doesn't depend on any external
(XML) files; by default all configuration is done automagically, from
Java. Nevertheless, it is easy to configure and extend *Petite* to match
any requirements.

## Installation

Installation is trivial: put *Jodd* jars on the classpath.

## Using session scope

In order to use `SessionScope` (in some servlet container), the
following listeners has to be added to the `web.xml`\:

~~~~~ xml
    <?xml version="1.0" encoding="UTF-8"?>
    <web-app ...>
    	...
    	<listener>
    		<listener-class>
                jodd.servlet.RequestContextListener
            </listener-class>
    	</listener>
    	...
    </web-app>
~~~~~

## Using session scope outside of container

When container has session scope beans, it can't be used out of servlet
container. This makes testing outside of container hard. However,
*Petite* has one nice feature: it is possible to register scopes
manually. In regular use case, it is not necessary to deal with scopes
registration, since scopes will be resolved and instantiated on their
first usage. Anyhow, it is possible to register specific scope instance
for any scope that will be used instead of required one.

For example, it is possible to replace session scope with the singleton
scope, what is usually enough for the tests:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    petite.getManager().registerScope(SessionScope.class, new SingletonScope());
~~~~~

Now all session scope beans will be registered within singleton scope,
assuming there is one and only one, big session.

## Bean Iteration

At any time, all registered beans may be iterated. This is useful when
some additional modification has to be performed on bean classes, after
being registered. Method `beansIterator` iterates all beans - actually,
it iterates all bean definitions! This means that beans may not be even
initialized yet (there was no first lookup yet).

## Configuration

*Petite* container is quite configurable. Configuration is available via
method `getConfig()`.

### defaultScope

Default scope for beans registration, when explicit scope is not
specified. Default value: `SingletonScope.class`.

### defaultWiringMode

Defines default wiring mode. Can be one of the following:

* `WiringMode.NONE` - no wiring,
* `WiringMode.STRICT` - throws an exception if injection failes
  (default),
* `WiringMode.OPTIONAL` - ignores unsuccessful injections
* `WiringMode.AUTOWIRE` - tries to wire all fields

Mode can be changed during runtime, although this is not recommended.

### detectDuplicatedBeanNames

Flag for detecting duplicated bean names during registration (`false` by
default). If set to `true`, *Petite* will throw an exception if bean
with the same name already exists in the container.

### resolveReferenceParameters

Flag for resolving parameter references (`true` by default). *Petite*
parameters can define a value that contains value of other parameter.
For example: `defineParameter("name", "${name2}");` will define
parameter **name** with value equals to value of other parameter,
**name2**.

### useFullTypeNames

Defines what will be the default bean name, when no explicit name is
provided. If set to `false` (default), uncapitalized simple type name
will be used as bean name (for example, `app.service.SomeService` will
be named as `someService`).

If set to `true`, then full bean type name will be used as bean name.

### lookupReferences

Defines reference lookup order. When looking up for a bean reference,
*Petite* may look for it in different ways. By default, the lookup order
is the following:

* `PetiteReference.NAME`
* `PetiteReference.TYPE_SHORT_NAME`
* `PetiteReference.TYPE_FULL_NAME`

User may change or modify this lookup order.

### useParamo

When set to `true` (default), *Petite* will use *Paramo* to extract
constructor and method argument names - this information is not provided
by java reflection API and must be read from debug information in
bytecode. If set to `false`, injection by name will not be available
for constructor and method arguments.
